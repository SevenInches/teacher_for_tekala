Tekala::Admin.controllers :logins do
  get :index do
    render "/login/index"
  end

  post :create do
    school = RoleUser.authenticate(params[:school], params[:phone], params[:password])
    if school.present?
      set_current_account(school)
      p 'CCC'
      redirect url(:base, :index)
    else
      p 'ddd'
      params[:school] = h(params[:school])
      params[:phone]  = h(params[:phone])
      flash.now[:error] = pat('login.error')
      render "/login/index"
    end
  end

  delete :destroy do
    set_current_account(nil)
    redirect url(:logins, :index)
  end
end