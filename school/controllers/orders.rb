Tekala::School.controllers :v1, :orders  do
  before :except => [] do
    if session[:school_id]
      @school = School.get(session[:school_id])
      $school_remark  = 'school_' + session[:school_id].to_s
    elsif !params['demo'].present?
      redirect_to(url(:v1, :unlogin))
    end
  end

  get :orders, :map => '/v1/orders', :provides => [:json] do
    if params['demo'].present?
      @demo     = params['demo']
      @orders = Order.first
      @total    = 1
    else
      $redis.lrem $school_remark, 0, '约车订单'
      @orders = @school.users.orders.all
      if params[:user_key].present?
        if params[:user_key].to_i > 0
          users = @school.users.all(:mobile => "%#{params[:user_key]}%")
        else
          users = @school.users.all(:name.like => "%#{params[:user_key]}%")
        end
        if users.present?
          @orders  = Order.all(:user_id => users.aggregate(:id))
        end
      end

      if params[:teacher_key].present?
        if params[:teacher_key].to_i > 0
          teachers = @school.teachers.all(:mobile.like => "%#{params[:teacher_key]}%")
        else
          teachers = @school.teachers.all(:name.like => "%#{params[:teacher_key]}%")
        end
        if teachers.present?
          @orders  = Order.all(:teacher_id => teachers.aggregate(:id))
        end
      end

      if params[:exam_type].present?
        @orders  = @orders.all(:exam_type => params[:exam_type])
      end

      if params[:field].present?
        @orders  = @orders.all(:train_field_id=> params[:field])
      end

      if params[:progress].present?
        @orders  = @orders.all(:progress=> params[:progress])
      end

      if params[:start_time].present? && params[:end_time].present?
        @orders  = @orders.all(:book_time.gte => params[:start_time], :book_time.lte => params[:end_time])
      end

      @total  = @orders.count
      @orders = @orders.all(:order => :book_time.desc).paginate(:per_page => 20, :page => params[:page])
    end
    render 'orders'
  end

  put :orders, :map => '/v1/orders/:order_id/edit_time', :provides => [:json] do
    if params[:book_time].present?
      order = Order.get(params[:order_id])

      #/*预订的日期
      book_time_first = Time.parse(params[:book_time]).strftime('%Y-%m-%d %k:00')
      book_time_second = Time.parse(params[:book_time] + 1.hours).strftime('%Y-%m-%d %k:00') if params[:quantity] == 2

      tmp1 = []
      Order.all(:teacher_id => order.teacher_id, :status => Order::pay_or_done, :book_time => ((Date.today+1)..(Date.today+8.day))).each do |order|
        tmp1 << order.book_time.strftime('%Y-%m-%d %k:00')
        tmp1 << (order.book_time+1.hour).strftime('%Y-%m-%d %k:00') if order.quantity == 2
      end
      # 预订的日期 */

      #/*如果该时段被预约 返回failure
      if tmp1.include?(book_time_first)
        {:status => :failure, :msg => '第一个时段已被预约'}.to_json
      elsif  tmp1.include?(book_time_second)
        {:status => :failure, :msg => '第二个时段已被预约'}.to_json
      else
        order.book_time = params[:book_time]
        order.quantity  = params[:quantity]
        if order.save
          {:status => :failure, :msg => "订单(id:#{params[:order_id]})时间已经修改为#{params[:book_time]}"}.to_json
        else
          {:status => :failure, :msg => order.errors.first.first}.to_json
        end
      end
      #如果该时段被预约 返回failure */
    end
  end

  put :orders, :map => '/v1/orders/:order_id/cancel', :provides => [:json] do
    order = Order.get(params[:order_id])
    if order.present?
      if order.status == Order::STATUS_PAY || order.status == Order::STATUS_RECEIVE
        if order.update(:status => Order::STATUS_CANCEL)
          {:status => :success, :msg => "订单(id:#{params[:order_id]})已经取消"}.to_json
        end
      else
        {:status => :failure, :msg => "参数错误"}.to_json
      end
    else
      {:status => :failure, :msg => "订单不存在"}.to_json
    end
  end

end