# -*- encoding : utf-8 -*-
Tekala::School.controllers :v1 do
  register WillPaginate::Sinatra
  enable :sessions
  Rabl.register!
  before :except => [:login, :unlogin, :logout] do

	  if session[:school_id]
	    @school= School.get(session[:school_id])
	  else
	    redirect_to(url(:v1, :unlogin))  
	  end
	end

	post :login, :provides => [:json] do
    	if params[:demo].present?
        @demo   = params[:demo]
				@school = School.first
				render 'school'
      else
				@school = School.authenticate(params[:phone], params[:password])
				if @school
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

end