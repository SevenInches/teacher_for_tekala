Tekala::Admin.controllers :edit_psd do
  before :except => [:login, :unlogin, :logout] do
    if session[:role_user_id]
      @role_user = RoleUser.get session[:role_user_id]
      @school_no = session[:school_no]
      @mobile     = session[:mobile]
    elsif !params['demo'].present?
      redirect_to(url(:edit_psd, :unlogin))
    end
  end

  get :index do
    @title = '修改密码'
    render "/edit_psd/index"
  end

  post :change do
    role_user = @role_user.change_psd(@school_no, @mobile, params[:old_password],params[:new_password], params[:confirm_password])
    if role_user
      redirect_to(url(:edit_psd, :index))
    else

    end

  end

  get :unlogin, :provides => [:json] do
    {:status => :failure, :msg => '未登录'}.to_json
  end

  delete :destroy do
    set_current_account(nil)
    redirect url(:logins, :index)
  end
end