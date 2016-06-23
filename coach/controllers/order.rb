Szcgs::Coach.controllers  :v1, :orders  do
	before :except => [] do
	    if session[:teacher_id]
	    	@teacher = Teacher.get(session[:teacher_id])
		  else
		    redirect_to(url(:v1, :unlogin))
		  end

	end

  get '/', :provides => [:json] do 

    # @orders = Order.all(:teacher_id => @teacher.id, :order => :id.desc, :type => 0)
    @orders = Order.all(:teacher_id => @teacher.id, :status.gt => 101, :order => :id.desc, :type => Order::NORMALTYPE, :order_confirm => OrderConfirm.all(:status => 1))
    
    @total  = @orders.count
    @orders = @orders.paginate(:page => params[:page], :per_page => 20)
    # #性能优化 
    @orders.each do |orders|
      orders.user
      orders.teacher
    end
    # #性能优化 
    render 'orders'
  end

  get :details, :provides => [:json] do 
    @order = Order.first(:id => params[:order_id], :teacher_id => @teacher.id)
    render 'order'
  end

  #添加user 评论
  post '/', :provides => [:json] do 
  	@order = Order.get params[:order_id]
    return {:status => "failure", :msg => '订单不存在' }.to_json if !@order 
  	return {:status => "failure", :msg => '评论失败' }.to_json if @order && !@order.teacher_can_comment

    @comment            = UserComment.new
    @comment.content    = params[:content]
    @comment.order_id   = @order.id
    @comment.rate       = params[:rate] if !params[:rate].nil? && !params[:rate].empty?
    @comment.user_id    = @order.user_id
    @comment.teacher_id = @teacher.id
    if @comment.save
     render 'user_comment'
    else
      {:status => :failure, :msg => @comment.errors.full_messages.join(',') }.to_json
    end
    
  end

  get :done, :provides => [:json] do 
    @teacher.check_order

    @orders = @teacher.done_or_cancel_orders.all(:order => :book_time.desc)
    @orders = @orders.paginate(:page => params[:page], :per_page => 20)
    
    @total  = @orders.count
    #性能优化 
    @orders.each do |orders|
      orders.user
      orders.teacher
    end
    #性能优化

    render 'orders'
  end

  post :finish, :provides => [:json] do 
    order_id = params[:order_id]

    order = Order.get order_id

    if order && order.teacher_id == @teacher.id 
      order.done_at = Time.now
      order.status = 103
      if order.save
        JPush::order_finish order.id
        {:status => :success}.to_json
      else
        {:status => :failure}.to_json
      end
    else
      return {:status => :failure}.to_json
    end
  end

  get :has_accept, :provides =>[:json] do 
    @orders = Order.all(:teacher_id => @teacher.id, :order => :book_time.asc, :status => 104, :book_time.gt => Time.now)
    
    #性能优化 
    @orders.each do |orders|
      orders.user
      orders.teacher
    end 
    #性能优化
    
    render 'orders'
  end

  get :can_comment, :provides => [:json] do 
    @orders = Order.all(:teacher_id => @teacher.id, :order => :done_at.desc, :status => 103)
    @can_comment = []
    @orders.each do |order|
     @can_comment << order if order.teacher_can_comment
    end
    @orders = @can_comment
    @total  = @orders.count
    #性能优化 
    @orders.each do |orders|
      orders.user
      orders.teacher
    end
    #性能优化
    render 'orders'

  end

  #订单已完成，学员未评价
  # get :done_no_comment, :provides => [:json] do 

  #   @orders = Order.all(:teacher_id => @teacher.id, :order => :done_at.desc, :status => 103)
  #   @done_no_comment = []
    
  #   @orders.each do |order|
  #    @done_no_comment << order if !order.user_has_comment
  #   end

  #   @orders = @done_no_comment
  #   #性能优化 
  #   @orders.each do |orders|
  #     orders.user
  #     orders.teacher
  #   end
  #   #性能优化
  #   render 'orders'

  # end


  get :new, :provides => [:json] do 
    # @orders = Order.all(:teacher_id => @teacher.id, :book_time => ((Date.today-5)..(Date.today+1)), :order => :book_time.asc, :status => 102).paginate(:page => params[:page], :per_page => 20)
    @orders = []
    @order_confirm = OrderConfirm.all(:teacher_id => @teacher.id, :status => 0, :order => :created_at.desc )

    @order_confirm.each do |oc|
      order = oc.order
      @orders << order if order && order.book_time > Time.now && order.status == 102
    end

    @total = @orders.count
    
    #性能优化 
    @orders.each do |order|
      if order 
        order.user
        order.teacher
      end
    end
    #性能优化

    render 'orders'
  end

  #今日订单
  get :today, :provides =>[:json] do 
    @orders = Order.all(:teacher_id => @teacher.id, :book_time => ((Date.today)..(Date.today+1)), :order => :book_time.asc, :type => Order::NORMALTYPE, :status => 104).paginate(:page => params[:page], :per_page => 20)
    @total  = @orders.count
    #性能优化 
    @orders.each do |orders|
      orders.user
      orders.teacher
    end
    #性能优化

    render 'orders'
  end

  #最近七天订单
  get :recent, :provides =>[:json] do 
    @orders = Order.all(:teacher_id => @teacher.id, :book_time => ((Date.today)..(Date.today+8)), :order => :book_time.asc, :type => Order::NORMALTYPE, :status => 104).paginate(:page => params[:page], :per_page => 20)
    @total  = @orders.count
    #性能优化 
    @orders.each do |orders|
      orders.user
      orders.teacher
    end
    #性能优化
    render 'orders'
  end

  

  #待教学
  get :waiting, :provides => [:json] do 
    @orders = Order.all(:teacher_id => @teacher.id, :status => 104, :order => :book_time.desc, :type => Order::NORMALTYPE)

    @total  = @orders.count
    @orders = @orders.paginate(:page => params[:page], :per_page => 20)
    #性能优化 
    @orders.each do |orders|
      orders.user
      orders.teacher
    end
    #性能优化 
    render 'orders'

  end

  #未完成订单
  get :uncomplete, :provides => [:json] do 
    @orders = []
    @order_tmps = Order.all(:teacher_id => @teacher.id, :status => 103, :order => :book_time.desc, :limit => 10, :type => Order::NORMALTYPE)
    @order_tmps.each do |o|
     @orders << o if !o.paid || (o.can_comment && !o.user_has_comment)
    end
    render 'orders'

  end

  #已取消
  get :cancel, :provides => [:json] do 
    @orders = Order.all(:teacher_id => @teacher.id, :status => [2, 1, 0], :order => :book_time.desc, :type => Order::NORMALTYPE)

    @orders = @orders.paginate(:page => params[:page], :per_page => 20)
    render 'orders'
  end

  #是否接受
  post :is_accept, :provides => [:json] do  
    
    order_id  = params[:order_id]
    is_accept = params[:is_accept].downcase
    return {:status => :failure, :code => 401, :meg => '未选择拒绝或接受'}.to_json if is_accept.nil? 
    
    order = Order.get order_id

    if order && order.teacher_id == @teacher.id 
      if is_accept == 'yes'

        if order && order.status == 0
          return {:status => :failure, :msg => '学员已取消该订单'}.to_json
        end
        
        order_confirm = OrderConfirm.first(:order_id => order_id)
        order.confirm = 1 if order.train_field_id != 5
        order.status  = 104 #教练已经确定 
        order.save
        
        teacher = order.teacher
        user    = order.user  
        train_field_name = order.train_field ? order.train_field.name : ''
        week_name = %w(周日 周一 周二 周三 周四 周五 周六)

        teacher_word = "#{teacher.name}教练您好，学员#{user.name}(手机:#{user.mobile})预约#{order.book_time.strftime("%m-%d %H:00")} (#{week_name[order.book_time.wday]})在#{train_field_name}训练场练车#{order.quantity}小时。请提前10分钟到场，并在教学中保持耐心和友好。如有疑问，请立即联系我们4008456866"
        member_word  = "#{user.name}同学，您已成功预约#{teacher.name}教练(手机：#{teacher.mobile})，#{order.book_time.strftime("%m-%d %H:00")}-#{(order.book_time.strftime("%H").to_i+order.quantity)}#{":00"} (#{week_name[order.book_time.wday]}) ，在#{train_field_name}训练场练车。请提前10分钟自行前往训练场，祝您学车愉快。"
        
        if order.has_sms != 1 
          
          info = Sms.new( :teacher_word   => teacher_word,
                          :teacher_mobile => teacher.mobile,
                          :member_mobile  => user.mobile,
                          :member_word    => member_word)
           if info.send_sms == 'success'
              order.has_sms = 1
              order.save
           end
        end
        
        if order_confirm
          order_confirm.status = 1
          order_confirm.save
        end

        #队列一个小时前推送给学员
        begin 
         delay_seconds = ((order.book_time).to_i - (Time.now.to_i))-3600
         NotificationJob.perform_in(delay_seconds, order.id) if order.save
        rescue Exception => e
          puts e
        end
      
      #拒绝接单
      elsif is_accept == 'no'
        order_confirm = OrderConfirm.first(:order_id => order_id)
        order.status  = 0 #教练已经确定
        order.save
        if order_confirm
          order_confirm.status = 2
          order_confirm.save
          JPush::order_cancel(order.id)
        end

      end

      {:status => :success}.to_json

    else
      {:status => :failure, :code=>400, :msg => '未能找到该订单'  }.to_json
    end

  end

end



