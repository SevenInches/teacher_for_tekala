Tekala::Admin.controllers :roles do
  get :index do
    @title = '人员管理'
    @users = RoleUser.all
    @users = @users.all(:role_id => params[:role_id]) if params[:role_id].present?
    @users = @users.paginate(:page => params[:page],:per_page => 5)
    @users = @users.reverse
    render "roles/index"
  end

  post :create do
    @user = RoleUser.new(params[:user])
    if @user.save
      flash[:success] = pat(:create_success, :model => 'RoleUser')
      redirect(url(:roles, :index))
    else
      render 'roles/index'
    end
  end

  delete :destroy, :with => :id do
    @title = "人员管理"
    push = RoleUser.get(params[:id])
    if push
      if push.destroy
        flash[:success] = pat(:delete_success, :model => 'Push', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'Push')
      end
      redirect url(:roles, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'Push', :id => "#{params[:id]}")
      halt 404
    end
  end

end
