# -*- encoding : utf-8 -*-
Tekala::Channel.controllers :v1 do
	register WillPaginate::Sinatra
  	enable :sessions
  	Rabl.register!

  	before :except => [:login, :unlogin, :logout] do
  		if session[:channel_id]
  			@channel = Channel.get(session[:channel_id])
  		else
  			redirect_to(url(:v1, :unlogin))  
  		end
	end

	post :login, :provides => [:json] do
    		@channel = Channel.authenticate(params[:phone], params[:password])
    		if @channel
    			session[:channel_id] = @channel.id
    			render 'channel'
    		else
    			{:status => :failure, :msg => '登录失败'}.to_json
    		end
	end

	post :logout, :provides => [:json] do
		 session[:channel_id] = nil
		 {:status => :success, :msg => '退出成功'}.to_json
	end

	get :unlogin, :provides => [:json] do
		{:status => :failure, :msg => '未登录'}.to_json
	end

end