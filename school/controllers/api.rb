# -*- encoding : utf-8 -*-
Tekala::Manager.controllers :v1 do
  register WillPaginate::Sinatra
  enable :sessions
  Rabl.register!
  before :except => [:login, :unlogin, :logout, :about, :letter, :pay_record, :rank] do 

	  if session[:teacher_id]
	    @manager= Teacher.get(session[:teacher_id])
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

	get :logout, :provides => [:json] do
		 session[:teacher_id] = nil
		 {:status => :success, :msg => '退出成功'}.to_json
	end

	get :unlogin, :provides => [:json] do
	  {:status => :failure, :msg => '未登录'}.to_json
	end

end