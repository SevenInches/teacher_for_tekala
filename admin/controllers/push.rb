Tekala::Admin.controllers :push do
  get :index do
    @title = '推送管理'
    @pushs = Push.all
    @pushs = @pushs.paginate(:page => params[:page],:per_page => 20)
    @pushs = @pushs.reverse
    render "push/index"
  end

  get :new do
    @title = '新建推送'
    render "push/new"
  end

  post :create do
    @push = Push.new(params[:push])
    if @push.save
      flash[:success] = pat(:create_success, :model => 'Push')
      redirect(url(:push, :index))
    else
      render 'roles/index'
    end
  end

  get :send, :with => :id do
    @title = pat(:send_title, :model => "Push #{params[:id]}")
    push = Push.get(params[:id])
    tags = []
    p push.editions
    if push.present? && push.editions.present?
      p 'test'
      push.editions.split(':').each do |edition|
        tags << 'channel_' + push.channel_id.to_s if push.channel_id.present?
        tags << 'version_' + push.version if push.version.present?
        tags << 'school_'  + push.school_id.to_s if push.school_id.present?
        tags << 'status_'  + push.user_status.to_s if !push.user_status.nil?
        JPush.send_message(tags, push.message, edition)
      end
      flash[:success] = pat(:send_success, :model => 'Push', :id => "#{params[:id]}")
      #redirect url(:push, :index)
      redirect_to(url(:push, :index))
    end
  end
end
