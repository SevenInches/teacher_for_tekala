# -*- encoding : utf-8 -*-
Tekala::Coach.controllers :v1 do
  register WillPaginate::Sinatra
  enable :sessions
  Rabl.register!
  before :except => [:login, :unlogin, :logout, :about, :letter, :pay_record, :rank] do
	  if session[:teacher_id]
	    @teacher = Teacher.get(session[:teacher_id])
	  else
	    redirect_to(url(:v1, :unlogin))  
	  end
	end

	post :login, :provides => [:json] do
	    @teacher = Teacher.authenticate(params[:mobile], params[:password])
	    if @teacher
	      #教练设备
	      @teacher.device = params[:device] || '未知'
	      @teacher.login_count ||= 0
	      @teacher.login_count += 1
	   	  @teacher.save

	      session[:teacher_id] = @teacher.id
	      # 把订单已结束，但未点完成的订单，修改状态
	      @teacher.check_order
	      render 'teacher'
	    else
	      {:status => :failure, :msg => '登陆失败'}.to_json
	    end
	end

	get :earn_history, :provides => [:json] do
		month =  params[:month]+'-01'
		next_month = month.to_date + 1.months
		str_next_month = next_month.strftime('%Y-%d-%m')
		@orders = Order.all(:teacher_id => @teacher.id, :status => Order::pay_or_done, :sum_time.not => nil )
    	@orders = @orders.all(:sum_time.gt => month.to_date, :sum_time.lt => next_month)
    	
        orders = DataMapper.repository.adapter.select("SELECT * FROM orders where sum_time != '' and sum_time > '#{month}' and sum_time < '#{next_month}' and teacher_id='404' group by DATE(sum_time) ")
        data = []
        orders.each do |order|
        	current_orders = Order.all(:teacher_id => 404, :status => Order::pay_or_done, :sum_time.gt => order.sum_time.strftime("%Y-%m-%d"), :sum_time.lt => (order.sum_time+1.days).strftime("%Y-%m-%d"))
        	data << {:date => order.sum_time.strftime("%Y-%m-%d"), :total => current_orders.sum(:price) ? current_orders.sum(:price) : 0 } if  current_orders.sum(:price) && current_orders.sum(:price) > 0
        end
        {:data => data }.to_json
	end

	get :logout, :provides => [:json] do
		 session[:teacher_id] = nil
		 {:status => :success, :msg => '退出成功'}.to_json
	end

	get :unlogin, :provides => [:json] do
	  {:status => :failure, :msg => '未登录'}.to_json
  end

	put :password, :provides => [:json] do
		if params[:old_password].present? && params[:new_password].present?
			if @teacher.has_password?(params[:old_password])
				password = ::BCrypt::Password.create(params[:new_password])
				if @teacher.update(:crypted_password => password)
					{:status => :success, :msg => '密码修改成功'}.to_json
				else
					{:status => :failure, :msg => @teacher.errors.first.first}.to_json
				end
			else
				{:status => :failure, :msg => '原密码错误'}.to_json
			end
		else
			{:status => :failure, :msg => '参数错误'}.to_json
		end
	end

	get :about, :provides => :html do 
		render 'about'
	end

	get :rule, :provides => :html do 
		render 'rule'
	end

	get :ads, :provides => [:json] do
		@ads = Ad.all(:type => 1)
		@total = @ads.count
		render 'ads'
		
	end

	get :info, :provides => [:json] do
		 @teacher = Teacher.get(session[:teacher_id])
		 render 'teacher'
	end


	get :questions, :provides => :json do
		@questions = Question.all(:order=>:weight.asc, :show => true)
		@questions = @questions.paginate(:page => params[:page], :per_page => 20)
    @total = @questions.count
    render 'question_student'
	end

	get :my_train_fields, :provides =>[:json] do 
		train_field_ids = TeacherTrainField.all(:teacher_id => @teacher.id).map(&:train_field_id)
		@train_fields = TrainField.all(:id => train_field_ids).all(:open => 1)
		@total = @train_fields.count
		@train_fields = @train_fields.paginate(:page => params[:page], :per_page => 20)
		render "train_fields"
	end

	get :train_fields, :provides =>[:json] do 
		@train_fields = TrainField.all(:city_id => @teacher.city_id, :open => 1)
		@train_fields = @train_fields.all(:area => params[:area]) if params[:area]
		@total = @train_fields.count
		@train_fields = @train_fields.paginate(:page => params[:page], :per_page => 20)
		render "train_fields"
	end

	get :letter do 
		render "static_page/letter"
	end

	get :notices, :provides =>[:json] do 
		@notices = @teacher.notices
		@total   = @notices.count
		@notices = @notices.paginate(:page => params[:page], :per_page => 20)
		render 'notices'
	end

end