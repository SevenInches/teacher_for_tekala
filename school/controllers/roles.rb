Tekala::School.controllers :v1, :roles  do

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :roles, :map => '/v1/roles', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @roles    = Role.first
      @total    = 1
    else
      @roles  = @school.roles
      @total  = @roles.count
      @roles  = @roles.paginate(:per_page => 20, :page => params[:page])
    end
    render 'roles'
  end

  post :roles, :map => '/v1/roles', :provides => [:json] do
    if params[:name].present?
      @role = Role.new(:name => params[:name], :school_id => @school.id)
      @role.last_login_at = @role.created_at = Time.now
      @role.mobile        =  params[:mobile]       if params[:mobile].present?
      @role.password      =  params[:password]     if params[:password].present?
      @role.cate          =  params[:cate]         if params[:cate].present?
      if @role.save
        {:status => :success, :msg => '人员添加成功' }.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :role, :map => '/v1/roles/:role_id', :provides => [:json] do
    if params[:role_id].present?
      @role = Role.get(params[:role_id])
      @role.name     =  params[:name]           if params[:name].present?
      @role.mobile     =  params[:mobile]       if params[:mobile].present?
      @role.password   =  params[:password]     if params[:password].present?
      @role.cate       =  params[:cate]         if params[:cate].present?
      @role.last_login_at  = Time.now
      if @role.save
        {:status => :success, :msg => '人员资料修改成功'}.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  delete :role, :map => '/v1/roles/:role_id', :provides => [:json] do
    current = Role.get(params[:role_id])
    if current.destroy
      {:status => :success, :name => "管理员:#{current.name}删除成功"}.to_json
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end
end