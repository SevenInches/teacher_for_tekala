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

	get :pay_record do
		teacher_id = params[:teacher_id]
		token      = Digest::MD5.hexdigest("#{teacher_id}20150607mm")

		if token != params[:token]
			return 'token 不匹配'
		end

		@teacher    = Teacher.get(params[:teacher_id])


	    num    = params[:num].nil? ? -1 : params[:num].to_i
	    @num   = num
	    today  = Date.today

	    start_date  = today - (today.wday - 1).days + (num * 7).days
	    end_date    = start_date + 7.days

	    week_name   = "#{start_date.strftime('%Y年%m月%d日')} - #{(end_date-1.days).strftime('%m月%d日')}"

	    @orders     = @teacher.orders
	                  .all(:book_time => (start_date..end_date), 
	                       :order => :book_time.asc,
	                       :type => Order::PAYTOTEACHER,
	                       :status=>Order.pay_or_done)

	    
	    

	    @date_remark = start_date.strftime('%Y%m%d') + (end_date-1.days).strftime('%Y%m%d')

        teacher_pay = TeacherWeekPay.first(:date_remark => @date_remark, :teacher_id => @teacher.id)

        if num >= 0
        	@result     = "#{@teacher.name}教练，本周（#{week_name}）订单未结算。"
        elsif teacher_pay

	    	@result     = "#{teacher_pay.teacher.name}教练，本周（#{week_name}）您总共接单#{teacher_pay.c1_hours + teacher_pay.c2_hours}学时，其中C1手动档#{teacher_pay.c1_hours}学时，C2自动档#{teacher_pay.c2_hours}学时，收入#{teacher_pay.total}元，平台服务费#{teacher_pay.total - teacher_pay.should_pay}元，实际收入#{teacher_pay.should_pay}元。"
        else
        	c2_hours    = @orders.all(:exam_type=>2).sum(:quantity).to_i
		    c1_hours    = @orders.sum(:quantity).to_i - c2_hours

		    total_hours = c1_hours + c2_hours
		    income      = c1_hours * 119 + c2_hours * 129
		    fee         = @teacher.vip? ? (income * 0.1).to_i : 0
		    net_income  = income - fee

	   		@result     = "#{@teacher.name}教练，本周（#{week_name}）您总共接单#{total_hours}学时，其中C1手动档#{c1_hours}学时，C2自动档#{c2_hours}学时，收入#{income}元，平台服务费#{fee}元，实际收入#{net_income}元。"

        end

	    render 'pay_record'

	end

end