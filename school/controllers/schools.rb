Tekala::School.controllers :v1, :schools  do

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end

  end

  get :pushes, :map => '/v1/pushes', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @pushes   = Push.first
      @total    = 1
    else
      @pushes = @school.pushes.all
      @total  = @pushes.count
      @pushes = @pushes.paginate(:per_page => 20, :page => params[:page])
    end
    render 'pushes'
  end

  get :exams, :map => '/v1/exams', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @exams    = UserCycle.first
      @total    = 1
    else
      @exams  = @school.users.cycles
      @total  = @exams.count
      @exams  = @exams.paginate(:per_page => 20, :page => params[:page])
    end
    render 'exams'
  end
end