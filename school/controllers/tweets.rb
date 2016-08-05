Tekala::School.controllers :v1, :tweets do

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :index, :provides =>[:json] do
    if params['demo'].present?
      @demo     =  params['demo']
      @users    =  Tweet.first
      @total    =  1
    else
      users  =  @school.users
      if users.present?
        user_ids = users.aggregate(:id)
        @tweets   =  Tweet.all(:user_id => user_ids)
        @total    =  @tweets.count
        render 'tweets'
      end
    end
  end

  get :show, :map => 'v1/tweets/:id', :provides => [:json] do
    @tweet = Tweet.get(params[:id])
    if @tweet 
      render 'tweet'
    else
      {:status => :failure, :msg => '未能找到该tweet'}.to_json
    end
  end

  delete :index, :map => 'v1/tweets/:id', :provides => [:json] do
    @tweet = Tweet.first(:id => params[:id])
    if @tweet.present?
      { :status => @tweet.destroy ? :success : :failure }.to_json
    else
      { :status => :failure, :msg => '该评论已删除' }.to_json
    end
  end

end