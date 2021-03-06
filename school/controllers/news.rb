Tekala::School.controllers :v1, :news  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :news, :map => '/v1/news', :provides => [:json] do
    if params['demo'].present?
      @demo = params['demo']
      @news = New.first
      @total = 1
    else
      @news = @school.news
      @total = @news.count
      @news  = @news.all(:order => :created_at.desc).paginate(:per_page => 20, :page => params[:page])
    end

    render 'news'
  end

  post :news, :map => '/v1/news', :provides => [:json] do
    if params[:title].present? && params[:content].present?
      @news = News.new(:school_id => @school.id)
      @news.title = params[:title]
      @news.content = params[:content]
      @news.photo   = params[:photo]     if params[:photo].present?
      @news.view_count = params[:view_count] if params[:view_count].present?
      if @news.save
        render 'new'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  put :news, :map => 'v1/news/:news_id', :provides => [:json] do
    @news = News.get(params[:news_id])
    if @news.present?
      @news.title   = params[:title]     if params[:title].present?
      @news.content = params[:content]   if params[:content].present?
      @news.photo   = params[:photo]     if params[:photo].present?
      @news.view_count = params[:view_count] if params[:view_count].present?
      if @news.save
        render 'new'
      end
    else
      {:status => :failure, :msg => '此新闻id不存在'}.to_json
    end
  end

  delete :new, :map => '/v1/news/:news_id', :provides => [:json] do
    news = News.get(params[:news_id])
    if news.present?
      if news.destroy
        {:status => :success, :msg => "此新闻(id:#{params[:news_id]})删除成功"}.to_json
      end
    else
      {:status => :failure, :msg => '此新闻id不存在'}.to_json
    end
  end

end