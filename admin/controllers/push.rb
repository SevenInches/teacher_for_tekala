Tekala::Admin.controllers :push do
  get :index do
    @title = '推送管理'
    @pushs = Push.all
    @pushs = @pushs.paginate(:page => params[:page],:per_page => 20)
    @pushs = @pushs.reverse
    render "push/index"
  end

  post :create do
    @push = Push.new(params[:push])
    @push.school_id = session[:school_id]
    if @push.save
      flash[:success] = pat(:create_success, :model => 'Push')
      Push.jpush_message(@push)
      redirect(url(:push, :index))
    else
      render 'roles/index'
    end
  end

  get :send, :with => :id do
    @title = pat(:send_title, :model => "Push #{params[:id]}")
    push = Push.get(params[:id])
    Push.jpush_message(push)
    redirect(url(:push, :index))
  end
end
