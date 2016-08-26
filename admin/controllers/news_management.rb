Tekala::Admin.controllers :news_management do
  get :index do
    @title = '新闻管理'
    @news = News.all(:school_id => session[:school_id])
    @news = @news.paginate(:page => params[:page],:per_page => 20)
    @news = @news.reverse
    render "/news_management/index"
  end

  post :create do
    @news           = News.new(params[:news])
    @news.school_id = session[:school_id]
    if @news.save
      card = MessageCard.new(:school_id => session[:school_id])
      card.title    = @news.title
      card.tag      = '今日新闻'
      card.created_at = Time.now
      card.url        = MessageCard::HOME + 'news_card/' + @news.id.to_s
      card.save

      flash[:success] = pat(:create_success, :model => 'News')
      redirect(url(:news_management, :index))
    else
      render '/news_management/index'
    end
  end

  get :detail ,:with => :id do
    @news = News.first(:id => params[:id])
    @news.view_count = @news.view_count + 1
    @news.save
    p @news
    p @news.view_count
    render '/news_management/detail'
  end

  get :destroy, :with => :id do
    @title = "删除新闻"
    news = News.get(params[:id])
    if news
      if news.destroy
        flash[:success] = pat(:delete_success, :model => 'News', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'News')
      end
      redirect url(:news_management, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'News', :id => "#{params[:id]}")
      halt 404
    end
  end

  get :new do
    @title  = '新闻管理'
    render "/news_management/new"
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "News #{params[:id]}")
    @news = News.get(params[:id])
    if @news
      render 'news_management/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'article', :id => "#{params[:id]}")
      halt 404
    end
  end

  post :edit_deal, :with => :id do
    @title = pat(:update_title, :model => "News #{params[:id]}")
    @news = News.get(params[:id])
    if @news
      params[:news].each do |param|
          @news[param[0]] = param[1] if param[1].present?
        end
      if @news.save
        flash[:success] = pat(:update_success, :model => 'News', :id =>  "#{params[:id]}")
        redirect(url(:news_management, :index))
      else
        flash.now[:error] = pat(:update_error, :model => 'News')
        render 'news_management/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'News', :id => "#{params[:id]}")
      halt 404
    end
  end

  get :detail_mobile ,:with => :id do
    @news = News.first(:id => params[:id])
    @news.view_count = @news.view_count + 1
    @news.save
    p @news
    p @news.view_count
    render 'news_management/detail_mobile', :layout => false
  end

end