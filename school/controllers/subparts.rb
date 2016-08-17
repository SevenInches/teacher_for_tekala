Tekala::School.controllers :v1, :subparts  do

  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
      $school_remark  = 'school_' + session[:school_id].to_s
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
    array = $redis.lrange $school_remark, 0, -1
    if array.present?
      @notices = []
      count_hash = count_array(array)
      parts = Subpart.all
      parts.each do |part|
        part.count = 0
        count_hash.each do |value|
          if value[0].to_s == part.name
            part.count = value[1]
          end
        end
        @notices  << part
      end
    end
    render 'subnotices'
  end
end