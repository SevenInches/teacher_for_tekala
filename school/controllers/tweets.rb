Tekala::School.controllers :v1, :tweets do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
      $school_remark  = 'school_' + session[:school_id].to_s
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :index, :provides =>[:json] do
    $redis.lrem $school_remark, 0, "学员动态"
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
        @tweets   =  @tweets.all(:order => :created_at.desc).paginate(:per_page => 20, :page => params[:page])
        render 'tweets'
      end
    end
  end

  get :show, :map => 'v1/tweets/:tweet_id', :provides => [:json] do
    @tweet = Tweet.get(params[:tweet_id])
    if @tweet 
      render 'tweet'
    else
      {:status => :failure, :msg => '未能找到该动态'}.to_json
    end
  end

  delete :tweets, :map => 'v1/tweets/:tweet_id', :provides => [:json] do
    tweet = Tweet.get params[:tweet_id]
    if tweet
      tweet.tweet_photos.destroy
      tweet.tweet_comments.destroy
      tweet.tweet_likes.destroy
      if tweet.destroy!
        { :status => :success, :msg => '动态删除成功'}.to_json
      end
     else
      { :status => :failure, :msg => '参数错误' }.to_json
     end
  end

  get :comments, :map => 'v1/tweets/:tweet_id/comments', :provides => [:json] do
    last_id   = params[:last_id].to_i
    @comments = TweetComment.all(:tweet_id => params[:tweet_id], :order => :created_at.asc)
    @comments = @comments.all(:order => :created_at.asc, :id.gt => last_id, :limit =>20) if last_id > 0
    @total    = @comments.count
    @comments = @comments.all(:order => :created_at.desc).paginate(:per_page => 20, :page => params[:page])
    render 'tweet_comments'
  end

  delete :comment, :map => 'v1/tweets/:tweet_id/comments/:comment_id', :provides => [:json] do
    @comment = TweetComment.get(params[:comment_id])
    if @comment && @comment.destroy
      {:status => :success, :msg => '评论删除成功' }.to_json
    else
      {:status => :failure, :msg => '参数错误' }.to_json
    end
  end
end