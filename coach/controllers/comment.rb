Tekala::Coach.controllers  :v1, :comments  do
	before :except => [] do
	    
	    if session[:teacher_id]
	    	@teacher = Teacher.get(session[:teacher_id])
		  else
		    redirect_to(url(:v1, :unlogin))
		  end

	end

	get "/", :provides => [:json] do 
	  @comments   = TeacherComment.all(:teacher_id => @teacher.id, :order => :created_at.desc)
	  @total      = @comments.count
	  @comments   = @comments.paginate(:page => params[:page], :per_page => 20)

	    #加上这句会减少数据库查询次数 
	    @comments.each do |comment|
	    	puts comment.user.name if !comment.user.nil?
	    end

	    @comments.each do |comment|
	    	puts comment.teacher
	    end
	    #加上这句会减少数据库查询次数

	   render 'teacher_comments'
	end

	get :order, :provides => [:json] do 
	  @comment   = TeacherComment.all(:teacher_id => @teacher.id, :order_id => params[:order_id])
	  render 'teacher_comment'
	end

	get :to_me, :provides => [:json] do 
		@comment  = TeacherComment.first(:order_id => params[:order_id])
		 if @comment.nil?
		 	{:status => :failure, :msg => '暂未有评论'}.to_json 
		 else
	  		render 'teacher_comment'
		 end
  end


end