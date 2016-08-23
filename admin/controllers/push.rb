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
      card = MessageCard.new(:school_id => session[:school_id], :type => 3)
      card.content    = @push.message
      card.created_at = Time.now
      card.message_id = @push.id
      card.save

      flash[:success] = pat(:create_success, :model => 'Push')
      redirect(url(:push, :index))
    else
      render 'roles/index'
    end
  end

  get :send, :with => :id do
    @title = pat(:send_title, :model => "Push #{params[:id]}")
    push = Push.get(params[:id])
    push.jpush
    redirect(url(:push, :index))
  end
end
