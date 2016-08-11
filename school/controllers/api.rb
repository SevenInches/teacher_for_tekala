# -*- encoding : utf-8 -*-
Tekala::School.controllers :v1 do
  register WillPaginate::Sinatra
  enable :sessions
  Rabl.register!

  before :except => [:login, :unlogin, :logout] do
	  if session[:school_id]
	    @school = School.get(session[:school_id])
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
				user = RoleUser.authenticate(params[:school], params[:phone], params[:password])
				if user
					@school = user.role.school
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

  get :branches, :map => '/v1/all_branches', :provides => [:json] do
		@branches = @school.branches
		@total 		= @branches.count
		render 'all_branches'
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

	get :price,  :map => '/v1/price', :provides => [:html] do
		render 'static_pages/price'
	end

	#定价计时
	post :price, :provides => [:html] do
		@price = Price.new(:school_id => @school.id)
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
			@user_ids  = @school.users.aggregate(:id)
			@complains = Complain.all(:user_id => @user_ids)
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
			@user_ids  = @school.users.aggregate(:id)
			@feedbacks = Feedback.all(:user_id => @user_ids)
			@total     = @feedbacks.count
			@feedbacks = @feedbacks.paginate(:per_page => 20, :page => params[:page])
		end
		render 'feedbacks'
	end
end