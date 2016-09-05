Tekala::School.controllers :v1, :pushes do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :index, :provides =>[:json] do
    if params['demo'].present?
      @demo      =  params['demo']
      @pushes    =  Push.first
      @total     =  1
    else
      @pushes  =  @school.pushes
      @total   =  @pushes.count
      @pushes = @pushes.all(:order => :created_at.desc).paginate(:per_page => 20, :page => params[:page])
    end
    render 'pushes'
  end

  get :show, :map => 'v1/pushes/:id', :provides => [:json] do
    @push = Push.get(params[:id])
    if @push
      render 'push'
    else
      {:status => :failure, :msg => '未能找到该通知'}.to_json
    end
  end

  post :push, :map => 'v1/pushes', :provides => [:json] do
    @push = Push.new(:school_id => session[:school_id])
    @push.message = params[:message] if params[:message].present?
    @push.type = params[:type] if params[:type].present?
    @push.channel_id = params[:channel] if params[:channel].present?
    @push.version = params[:version] if params[:version].present?
    @push.user_status = params[:user_status] if params[:user_status].present?
    @push.editions = params[:editions] if params[:editions].present?
    if @push.save
      render 'push'
    end
  end

  put :push, :map => 'v1/pushes/:push_id', :provides => [:json] do
    @push = Push.get(params[:push_id])
    if @push.present?
      @push.message      =  params[:message]       if params[:message].present?
      @push.type         =  params[:type]          if params[:type].present?
      @push.channel_id   =  params[:channel]       if params[:channel].present?
      @push.version      =  params[:version]       if params[:version].present?
      @push.user_status  =  params[:user_status]   if params[:user_status].present?
      @push.editions     =  params[:editions]      if params[:editions].present?
      if @push.save
        render 'push'
      end
    end
  end

  get :send, :map => 'v1/pushes/send/:push_id' do
    push = Push.get(params[:push_id])
    if push.jpush
      {:status => :success, :msg => '推送成功'}.to_json
    else
      {:status => :failure, :msg => '推送失败'}.to_json
    end
  end

  delete :push, :map => 'v1/pushes/:id', :provides => [:json] do
    @push = Push.first(:id => params[:id])
    if @push.present?
      { :status => @push.destroy ? :success : :failure }.to_json
    else
      { :status => :failure, :msg => '该通知已删除' }.to_json
    end
  end
end