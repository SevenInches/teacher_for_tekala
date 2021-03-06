Tekala::Admin.controllers :login do
  get :index do
    @title  = '登录'
    render "/login/index"
  end

  post :create do
    role_user = Role.authenticate(params[:school], params[:phone], params[:password])
    if role_user.present?
      set_current_account(role_user)
      # session[:role_id] = role_user.role_id
      session[:role_user_id] = role_user.id
      session[:school_no] = role_user.school_id
      session[:mobile]    = params[:phone].to_i
      session[:school_id] = School.first(:school_no => params[:school]).id
      redirect url(:base, :index)
    else
      params[:school] = h(params[:school])
      params[:phone]  = h(params[:phone])
      flash.now[:error] = pat('login.error')
      @error = true
      render "/login/index"
    end
  end

  # before
  #   role = RoleUser.get(session[:role_id])

  delete :destroy do
    set_current_account(nil)
    redirect url(:login, :index)
  end

  get :logout do
    session[:role_user_id] = nil
    session[:school_no] = nil
    session[:mobile] = nil
    {:status => :success, :msg => '退出成功'}.to_json
    redirect_to(url(:login, :index))
  end

end