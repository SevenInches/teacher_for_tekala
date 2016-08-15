Tekala::School.controllers :v1, :users  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :users, :map => '/v1/users', :provides => [:json] do
    if params['demo'].present?
      @demo    =  params['demo']
      @users   =  @school.users.first
      @total   =  1
    else
      @users  = @school.users
      if params[:key].present?
        if params[:key].to_i > 0
          @users  = @users.all(:mobile => params[:key])
        else
          @users  = @users.all(:name => params[:key])
        end
      end

      if params[:status].present?
        @users  = @users.all(:status_flag => params[:status])
      end
      if params[:shop].present?
        @users  = @users.all(:shop_id => params[:shop])
      end
      if params[:exam_type].present?
        @users  = @users.all(:exam_type => params[:exam_type])
      end
      if params[:sex].present?
        @users  = @users.all(:sex => params[:sex])
      end

      @total = @users.count
      @users  = @users.paginate(:per_page => 20, :page => params[:page])
    end
    render 'users'
  end

  get :user, :map => '/v1/users/:id', :provides => [:json] do
    @user = User.get(params[:id])
    render 'user'
  end

  get :orders, :map => '/v1/users/:id/orders', :provides => [:json] do
    user    = User.get(params[:id])
    if user.present?
      @orders = user.orders
      @total  = @orders.count
      render 'orders'
    end
  end

  get :comments, :map => '/v1/users/:id/comments', :provides => [:json] do
    user        = User.get(params[:id])
    if user.present?
      @comments   = user.comments
      @total      = @comments.count
      render 'comments'
    end
  end

  post :users, :map => '/v1/users', :provides => [:json] do
    if params[:mobile].present? && params[:product].present?
      @user = User.new(:mobile => params[:mobile], :product_id => params[:product], :school_id => @school.id)
      @user.shop_id          = params[:shop]       if params[:shop].present?
      @user.branch_id        = params[:branch]     if params[:branch].present?
      @user.id_card          = params[:card]       if params[:card].present?
      @user.address          = params[:address]    if params[:address].present?
      @user.status_flag      = params[:status]     if params[:status].present?
      @user.signup_at        = params[:signup_at]  if params[:signup_at].present?
      @user.sex              = params[:sex]        if params[:sex].present?
      @user.name             = params[:name]       if params[:name].present?
      if @user.save
        render 'user'
      else
        {:status => :failure, :msg => @user.errors.to_s}.to_json
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :users, :map => '/v1/users/:id', :provides => [:json] do
    if params[:id].present?
      @user = User.get(params[:id])
      @user.mobile           = params[:mobile]     if params[:mobile].present?
      @user.product_id       = params[:product]    if params[:product].present?
      @user.shop_id          = params[:shop]       if params[:shop].present?
      @user.branch_id        = params[:branch]     if params[:branch].present?
      @user.id_card          = params[:card]       if params[:card].present?
      @user.address          = params[:address]    if params[:address].present?
      @user.status_flag      = params[:status]     if params[:status].present?
      @user.signup_at        = params[:signup_at]  if params[:signup_at].present?
      @user.sex              = params[:sex]        if params[:sex].present?
      @user.name             = params[:name]       if params[:name].present?
      if @user.save
        render 'user'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  delete :users, :map => '/v1/users/:id', :provides => [:json] do
    user = User.get(params[:id])
    if user.destroy
      {:status => :success, :msg => "学员(id:#{params[:id]})删除成功"}.to_json
    else
      {:status => :failure, :msg => '删除错误'}.to_json
    end
  end

  put :edit_status, :map => '/v1/users/:id/status', :provides => [:json] do
    if params[:status]
      user = User.get params[:id]
      if user.update(:status_flag => params[:status])
        {:status => :success, :msg => '修改成功', :status => user.status_flag_word }.to_json
      else
        {:status => :failure, :msg => '参数错误'}.to_json
      end
    end
  end

  put :edit_score, :map => '/v1/users/:id/score', :provides => [:json] do
    user =User.get(params[:id])
    if user.user_exam.present?
      user_exam = user.user_exam
      user_exam.update(:exam_one => params[:exam_one])    if params[:exam_one].present?
      user_exam.update(:exam_four => params[:exam_four])  if params[:exam_four].present?
      {:status => :success, :msg => '修改成功'}.to_json
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :edit_plan, :map => '/v1/users/:id/plan', :provides => [:json] do
    user =User.get(params[:id])
    if user.user_plan.present?
      user_plan = user.user_plan
      user_plan.update(:exam_two => params[:exam_two])      if params[:exam_two].present?
      user_plan.update(:exam_three => params[:exam_three])  if params[:exam_three].present?
      {:status => :success, :msg => '修改成功'}.to_json
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  get :exams, :map => '/v1/users/:id/exams', :provides => [:json] do
    user    = User.get(params[:id])
    if user.present?
      @exams  = user.cycles
      @total  = @exams.count
      render 'user_exams'
    end
  end

  post :exams, :map => '/v1/users/:id/exams', :provides => [:json] do
    user  = User.get(params[:id])
    if user.present?
      cycle = UserCycle.new(:user_id => user.id)
      cycle.date    = params[:date]     if params[:date].present?
      cycle.level   = params[:level]    if params[:level].present?
      cycle.result  = params[:result]   if !params[:result].nil?
      cycle.note    = params[:note]     if params[:note].present?
      if cycle.save
        {:status => :success, :msg => '新增成功'}.to_json
      else
        {:status => :failure, :msg => '参数错误'}.to_json
      end
    end
  end

  put :exams, :map => '/v1/user_exams/:exam_id', :provides => [:json] do
    cycle = UserCycle.get(params[:exam_id])
    if cycle.present?
      cycle.date    = params[:date]     if params[:date].present?
      cycle.level   = params[:level]    if params[:level].present?
      cycle.result  = params[:result]   if !params[:result].nil?
      cycle.note    = params[:note]     if params[:note].present?
      if cycle.save
        {:status => :success, :msg => '修改成功'}.to_json
      else
        {:status => :failure, :msg => '参数错误'}.to_json
      end
    end
  end

  get :pays, :map => '/v1/users/:id/pays', :provides => [:json] do
    user    = User.get(params[:id])
    if user.present?
      @pays   = user.pays
      @total  = @pays.count
      render 'user_pays'
    end
  end

  post :pays, :map => '/v1/users/:id/pays', :provides => [:json] do
    user  = User.get(params[:id])
    if user.present?
      pay = UserPay.new(:user_id => user.id)
      pay.pay_at    = params[:date]     if params[:date].present?
      pay.amount    = params[:amount]   if params[:amount].present?
      pay.explain   = params[:explain]  if params[:explain].present?
      if pay.save
        {:status => :success, :msg => '新增成功'}.to_json
      else
        {:status => :failure, :msg => '参数错误'}.to_json
      end
    end
  end

  put :pays, :map => '/v1/user_pays/:pay_id', :provides => [:json] do
    pay = UserPay.get(params[:pay_id])
    if pay.present?
      pay.pay_at    = params[:date]     if params[:date].present?
      pay.amount    = params[:amount]   if params[:amount].present?
      pay.explain   = params[:explain]  if params[:explain].present?
      if pay.save
        {:status => :success, :msg => '修改成功'}.to_json
      else
        {:status => :failure, :msg => '参数错误'}.to_json
      end
    end
  end

  get :level, :map => '/v1/all_levels', :provides => [:json] do
    {'data':UserCycle.level_array}.to_json
  end
end