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
      news = New.first
      @total = 1
    else
      @news = @school.news
      @total = @news.count
      @news  = @news.paginate(:per_page => 20, :page => params[:page])
    end

    render 'news'
  end

  post :news, :map => '/v1/news', :provides => [:json] do
    if params[:title].present? && params[:content].present?
      @new = News.new
      @new.title = params[:name]
      @new.content = params[:content]
      @new.view_count = params[:view_count] if params[:view_count].present?
      @new.school_id = @school.id
      if @new.save
        render 'new'
      end
    else
      {:status => :failure, :msg => '参数错误'}.to_json
    end
  end

  get :new, :map => '/v1/news/:id', :provides => [:json] do
    @new = News.get(params[:id])
    render 'new'
  end

end