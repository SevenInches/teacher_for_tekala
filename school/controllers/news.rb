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

end