Tekala::School.controllers :v1, :comments do
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
      @users    =  UserComment.first
      @total    =  1
    else
      users  =  @school.users
      if users.present?
        user_ids    = users.aggregate(:id)
        @comments   =  UserComment.all(:user_id => user_ids)
        @total      =  @comments.count
        render 'comments'
      end
    end
  end

  get :show, :map => 'v1/comments/:id', :provides => [:json] do
    @comment = UserComment.get(params[:id])
    if @comment
      render 'comment'
    else
      {:status => :failure, :msg => '未能找到该评论'}.to_json
    end
  end

  delete :index, :map => 'v1/comments/:id', :provides => [:json] do
    @comment = UserComment.first(:id => params[:id])
    if @comment.present?
      { :status => @comment.destroy ? :success : :failure }.to_json
    else
      { :status => :failure, :msg => '该评论已删除' }.to_json
    end
  end

end