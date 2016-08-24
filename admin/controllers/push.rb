Tekala::Admin.controllers :push do
  get :index do
    @title = '推送管理'
    # @pushs = Push.all(:school_id => session[:school_id])
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

  get :delete,:with => :id do
    push = Push.get(params[:id])
    if push
      if push.destroy
        flash[:success] = pat(:delete_success, :model => 'Push', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'Push')
      end
      redirect url(:push,:index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'Push', :id => "#{params[:id]}")
      halt 404
    end
  end
end
