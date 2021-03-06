# -*- encoding : utf-8 -*-
Tekala::Shop.controllers :v1 do
	register WillPaginate::Sinatra
  	enable :sessions
  	Rabl.register!

  	before :except => [:login, :unlogin, :logout] do
	  if session[:shop_id]
	    @shop = Shop.get(session[:shop_id])
	  else
	    redirect_to(url(:v1, :unlogin))  
	  end
	end

	post :login, :provides => [:json] do
    		@shop = Shop.authenticate(params[:phone], params[:password])
    		if @shop
    			session[:shop_id] = @shop.id
    			a = Student.user_num + Consultant.user_num.to_f
			b = Student.user_num
			c = ( a == 0 ? 1.0 : b / a )

			@consultant_count = a
			@student_count = Student.user_num
			@consultant_chu_student = c

    			render 'shop'
    		else
    			{:status => :failure, :msg => '登录失败'}.to_json
    		end
	end

	post :logout, :provides => [:json] do
		 session[:shop_id] = nil
		 {:status => :success, :msg => '退出成功'}.to_json
	end

	get :unlogin, :provides => [:json] do
		{:status => :failure, :msg => '未登录'}.to_json
  end

	put :password, :provides => [:json] do
		if params[:old_password].present? && params[:new_password].present?
			if @shop.has_password?(params[:old_password])
				password = ::BCrypt::Password.create(params[:new_password])
				if @shop.update(:crypted_password => password)
					{:status => :success, :msg => '密码修改成功'}.to_json
				else
					{:status => :failure, :msg => @shop.errors.first.first}.to_json
				end
			else
				{:status => :failure, :msg => '原密码错误'}.to_json
			end
		else
			{:status => :failure, :msg => '参数错误'}.to_json
		end
  end

	get :index, :provides => [:json], :map => '/v1' do
		a = Student.user_num + Consultant.user_num.to_f
		b = Student.user_num
		c = ( a == 0 ? 1.0 : b / a )
		{:status => :success, :data => {:consultant_count => a, :student_count => Student.user_num, :consultant_chu_student => c}}.to_json
  end

end