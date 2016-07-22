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
    			#{:status => :success, :msg => '登录成功'}.to_json
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

	get :index, :provides => [:json], :map => '/v1' do
		a = Consultant.count.to_f
		b = Student.count
		c = ( b == 0 ? 0 : a / b )
		{:consultant_count => Consultant.count, :student_count => Student.count, :consultant_chu_student => c}.to_json
	end

end