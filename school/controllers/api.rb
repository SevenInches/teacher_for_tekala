# -*- encoding : utf-8 -*-
Tekala::School.controllers :v1 do
  register WillPaginate::Sinatra
  enable :sessions
  Rabl.register!

  before :except => [:login, :unlogin, :logout, :price] do
	  if session[:school_id]
	    @school = School.get(session[:school_id])
			@role = Role.get(session[:role_id])
			$school_remark = 'school_' + session[:school_id].to_s
		elsif !params['demo'].present?
	    redirect_to(url(:v1, :unlogin))  
	  end
	end

	post :login, :provides => [:json] do
		if params[:demo].present?
			@demo   = params[:demo]
			@school = School.first
			render 'school'
		else
			@role = Role.authenticate(params[:school], params[:phone], params[:password])
			if @role.present?
        session[:role_id] = @role.id
				@school = @role.school
				session[:school_id] = @school.id
				# 把订单已结束，但未点完成的订单，修改状态
				render 'school'
			else
				{:status => :failure, :msg => '登陆失败'}.to_json
			end
		end
	end

	post :logout, :provides => [:json] do
		 session[:school_id] = nil
		 {:status => :success, :msg => '退出成功'}.to_json
  end

	get :unlogin, :provides => [:json] do
		{:status => :failure, :msg => '未登录'}.to_json
	end

	put :password, :provides => [:json] do
		if params[:old_password].present? && params[:new_password].present?
			if @role.has_password?(params[:old_password])
				password = ::BCrypt::Password.create(params[:new_password])
				if @role.update(:crypted_password => password)
					{:status => :success, :msg => '密码修改成功'}.to_json
				else
					{:status => :failure, :msg => @role.errors.first.first}.to_json
				end
			else
				{:status => :failure, :msg => '原密码错误'}.to_json
			end
		else
			{:status => :failure, :msg => '参数错误'}.to_json
		end
  end

  get :branches, :map => '/v1/all_branches', :provides => [:json] do
		@branches = @school.branches
		@total 		= @branches.count
		render 'all_branches'
  end

	get :shops, :map => '/v1/all_shops', :provides => [:json] do
		@shops = @school.shops
		@total = @shops.count
		render 'all_shops'
	end

	get :products, :map => '/v1/all_products', :provides => [:json] do
		@products = @school.products
    @total 		= @products.count
		render 'all_products'
  end

	get :fields, :map => '/v1/all_fields', :provides => [:json] do
		@fields   = @school.train_fields
		@total 		= @fields.count
		render 'all_fields'
  end

	get :cars, :map => '/v1/all_cars', :provides => [:json] do
		@cars   = @school.cars
		@total 		= @cars.count
		render 'all_cars'
	end

	get :price,  :map => '/v1/price' do
    key      = "20150607mm"
    token    = Digest::MD5.hexdigest("#{params[:user_id]}#{key}")
    if params[:token] != token
			{:status => :failure, :msg => 'token 不正确'}.to_json
    else
			@price = Price.first(:school_id => session[:school_id])
			render 'static_pages/price'
    end
	end

	#定价计时
	post :price, :provides => [:html] do
		@price = Price.new(:school_id => session[:school_id])
		@price.c1_common = params['c1_common']   if params['c1_common'].present?
		@price.c2_common = params['c2_common']   if params['c2_common'].present?
		@price.c1_hot    = params['c1_hot']      if params['c1_hot'].present?
		@price.c2_hot    = params['c2_hot']      if params['c2_hot'].present?
		if @price.save
			render 'static_pages/success'
		else
			redirect(:v1, :price)
		end
  end

	get :complain,  :map => '/v1/complains', :provides => [:json] do
		if params['demo'].present?
			@demo      = params['demo']
			@complains = Complain.first
			@total     = 1
    else
			$redis.lrem $school_remark, 0, '学员投诉'
			@complains = @school.complains.all(:order => :created_at.desc)
			@total     = @complains.count
			@complains = @complains.paginate(:per_page => 20, :page => params[:page])
		end
		render 'complains'
  end

	get :feedback,  :map => '/v1/feedbacks', :provides => [:json] do
		if params['demo'].present?
			@demo      = params['demo']
			@feedbacks = Feedback.first
			@total     = 1
    else
			$redis.lrem $school_remark, 0, '意见反馈'
			@feedbacks = @school.feedbacks.all(:order => :created_at.desc)
			@total     = @feedbacks.count
			@feedbacks = @feedbacks.paginate(:per_page => 20, :page => params[:page])
		end
		render 'feedbacks'
  end

	get :exams, :map => '/v1/exams', :provides => [:json] do
		if params['demo'].present?
			@demo     = params['demo']
			@exams    = UserCycle.first
			@total    = 1
    else
			$redis.lrem $school_remark, 0, '考试'
			@exams  = @school.users.cycles.all(:order => :date.desc)
			@total  = @exams.count
			@exams  = @exams.paginate(:per_page => 20, :page => params[:page])
		end
		render 'exams'
  end

	put :exams, :map => '/v1/exams/:exam_id/pass', :provides => [:json] do
		exam = UserCycle.get params[:exam_id]
    if exam.present?
			exam.result = !exam.result
			if exam.save
				{:status => :success, :msg => '修改成功'}.to_json
			else
				{:status => :failure, :msg => exam.errors.first.first}.to_json
      end
    else
			{:status => :failure, :msg => '此考试记录不存在'}.to_json
    end
  end

	delete :exams, :map => '/v1/exams/:exam_id', :provides => [:json] do
		exam = UserCycle.get params[:exam_id]
		if exam.present?
			if exam.destroy
				{:status => :success, :msg => '修改成功'}.to_json
      else
				{:status => :success, :msg => exam.errors.first.first}.to_json
      end
		else
			{:status => :failure, :msg => '此考试记录不存在'}.to_json
		end
  end

  get :hot_messages, :map => '/v1/messages/hot', :provides => [:json] do
    @messages  = MessageCard.all(:order => [:created_at.desc, :weight.desc], :school_id =>session[:school_id].to_i, :limit => 5)
    @total  =  @messages.count
    render 'messages'
  end

	get :messages, :map => '/v1/messages', :provides => [:json] do
		@messages  =  MessageCard.all(:order => [:created_at.desc, :weight.desc], :school_id =>session[:school_id].to_i)
		@total     =  @messages.count
		@messages  =  @messages.paginate(:per_page => 20, :page => params[:page])
		render 'messages'
  end

  put :message, :map => '/v1/messages/:message_id', :provides => [:json] do
		msg = MessageCard.get(params[:message_id])
    if msg.present?
			msg.click_num += 1
      if msg.save
				{:status => :success, :msg => '消息更新'}.to_json
			end
		else
			{:status => :failure, :msg => '消息不存在'}.to_json
    end
  end

  get :news, :map => '/v1/news_card/:news_id' do
		new  = News.get(params[:news_id])
    if new.present?
			@title   = new.title
			@date    = new.created_at.strftime("%y年%m月%d日")
			@content = new.content
			render 'static_pages/message'
    end
  end

	get :daily, :map => '/v1/daily_card/:daily_id' do
		@daily = Daily.get(params[:daily_id])
    if @daily.present?
			@title   = @school.name.present? ? @school.name + '今日速报' : '日报'
			@date    = @daily.created_at.strftime("%y年%m月%d日")
			render 'static_pages/message'
    end
  end

	get :push, :map => '/v1/push_card/:push_id' do
		push  = Push.get(params[:push_id])
    if push.present?
			@title   = '系统推送消息'
			@date    = push.created_at.strftime("%y年%m月%d日")
			@content = push.message
			render 'static_pages/message'
    end
	end
end