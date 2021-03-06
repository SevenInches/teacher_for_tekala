Tekala::School.controllers :v1, :signups  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
      $school_remark  = 'school_' + session[:school_id].to_s
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :signups, :map => '/v1/signups', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      signup  = Signup.first
      if signup.present?
        @data = User.all(:id => signup.user_id)
      end
      @total    = 1
    else
      $redis.lrem $school_remark, 0, "报名"
      @data = @school.users
      if params[:pay].to_i == 1
        pay_users = Signup.all(:status => 2, :school_id => session[:school_id]).aggregate(:user_id)
        @data  = @data.all(:id => pay_users.compact)
      else
        unpay_users = Signup.all(:status => 1, :school_id => session[:school_id]).aggregate(:user_id)
        @data  = @data.all(:id => unpay_users.compact)
      end

      if params[:origin].present?
        origins = params[:origin].split(/-/)
        @data  = @data.all(:origin => origins)
      end

      if params[:pay_type].present?
        types  = params[:pay_type].split(/-/)
        @data = @data.all(:pay_type => types)
      end

      if params[:product].present?
        products = params[:product].split(/-/)
        @data   = @data.all(:product_id => products)
      end

      if params[:sex].present?
        sexes  = params[:sex].split(/-/)
        @data = @data.all(:sex => sexes)
      end

      if params[:apply_type].present?
        applys  = params[:apply_type].split(/-/)
        @data = @data.all(:apply_type => applys)
      end

      if params[:local].present?
        locals  = params[:local].split(/-/)
        @data = @data.all(:local => locals)
      end

      @data  = @data.all(:mobile => params[:mobile])     if params[:mobile].present?
      @data  = @data.all(:name => params[:name])         if params[:name].present?
      @total = @data.count
      @data  = @data.all(:order => :created_at.desc).paginate(:per_page => 20, :page => params[:page])
    end
    render 'signups'
  end

  get :signup, :map => '/v1/signups/:user_id', :provides => [:json] do
    @data = User.get(params[:user_id])
    render 'signup'
  end

  post :signups, :map => '/v1/signups', :provides => [:json] do
    if params[:mobile].present? && params[:product].present?
      user = User.first(:mobile => params[:mobile])
      if user.present?
        {:status => :failure, :msg => '手机号已被注册'}.to_json
      else
        @data = User.new(:school_id =>session[:school_id])
        @data.name         =  params[:name]
        @data.mobile       =  params[:mobile]        if params[:mobile].present?
        @data.sex          =  params[:sex]           if params[:sex].present?
        @data.id_card      =  params[:id_card]       if params[:id_card].present?
        @data.address      =  params[:address]       if params[:address].present?
        @data.origin       =  params[:origin]        if params[:origin].present?
        @data.branch_id    =  params[:branch]        if params[:branch].present?
        @data.manager_no   =  params[:manager_no]    if params[:manager_no].present?
        @data.operation_no =  params[:operation_no]  if params[:operation_no].present?
        @data.apply_type   =  params[:apply_type]    if params[:apply_type].present?
        @data.local        =  params[:local]         if params[:local].present?
        @data.exam_type    =  params[:exam_type]     if params[:exam_type].present?
        @data.pay_type     =  params[:pay_type]      if params[:pay_type].present?
        @data.status_flag  =  (params[:pay].to_i == 1) ? 1 : 0
        @data.product_id   =  params[:product]
        @data.password     =  '123456'
        if @data.save
          signup = Signup.new(:school_id =>session[:school_id], :user_id => @data.id)
          signup.product_id  =  params[:product]
          signup.amount      =  params[:amount].present? ? params[:amount] : Product.get(params[:product]).price
          signup.exam_type   =  params[:exam_type]     if params[:exam_type].present?
          signup.status      =  (params[:pay].to_i == 1) ? 2 : 1
          if signup.save
            render 'signup'
          end
        else
         {:status => :failure, :msg => @data.errors.first.first}.to_json
        end
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :signups, :map => '/v1/signups/:user_id', :provides => [:json] do
    @data = User.get(params[:user_id])
    if @data.present?
      signup  =  @data.signup
      signup.product_id   = params[:product]     if params[:product].present?
      signup.amount       = params[:amount]      if params[:amount].present?
      signup.status       = params[:status]      if params[:status].present?
      if signup.save
        render 'signup'
      end
    else
      {:status => :failure, :msg => '用户不存在'}.to_json
    end
  end

  delete :signup, :map => '/v1/signups/:signup_id', :provides => [:json] do
    signup = Signup.get(params[:signup_id])
    if signup.present?
      if signup.destroy
        {:status => :success, :msg => '报名订单删除成功'}.to_json
      else
        {:status => :success, :msg => signup.errors.first.first }.to_json
      end
    else
      {:status => :failure, :msg => '报名订单不存在'}.to_json
    end
  end
end