Tekala::School.controllers :v1, :signups  do
  require "redis"

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :index, :map => '/v1/subparts', :provides => [:json] do
    if params['demo'].present?
      @demo     =  params['demo']
      @subparts =  Subpart.first
      @total    =  1
    else
      @subparts = Subpart.all
      @total 		= @subparts.count
    end
    render 'subparts'
  end

  get :notice, :map => '/v1/notices', :provides => [:json] do


  end

end