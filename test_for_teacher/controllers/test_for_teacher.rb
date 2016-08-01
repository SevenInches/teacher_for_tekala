require 'json'
require 'rest-client'

Tekala::TestForTeacher.controllers :test_for_teacher  do

	get :index, :map => '/' do
		$arr ||= []

		render 'index'
	end

	post :login, :map => '/login' do
		arr =  JSON.parse(RestClient.post('t.tekala.cn/v1/login',
						:mobile => '13094442075',
						:password => '123456'
                                                 	  ))

		if arr['status'] == 'success'
			$arr << 1
		end

		redirect_to '/test_for_teacher/get_the_scheduling'
	end

	get :get_the_scheduling, :map => '/get_the_scheduling' do
		@teacher = Teacher.first(:mobile => '13094442075')
		if @teacher
			@orders = Order.all(:teacher_id => @teacher.id, :status.gt => 1, :order => :id.desc, :type => 1, :order_confirm => OrderConfirm.all(:status => 1))

			if @orders
				$arr << 2
			end

			redirect_to '/test_for_teacher/get_the_waiting_orders'
		else
			@teacher = Teacher.new
			@teacher.name = '第二帅'
			@teacher.mobile = '13094442075'
			@teacher.password = '123456'
			@teacher.save

			redirect_to '/test_for_teacher/get_the_scheduling'
		end
	end

	get :get_the_waiting_orders, :map => '/get_the_waiting_orders' do
		@teacher = Teacher.first(:mobile => '13094442075')
		@orders = Order.all(:teacher_id => @teacher.id, :status => 4, :order => :book_time.desc, :type => Order::NORMALTYPE)
		if @orders
			$arr << 3
		end

		redirect_to '/test_for_teacher/get_the_accpeting_orders'
	end

	get :get_the_accpeting_orders, :map => '/get_the_accpeting_orders' do
		@teacher = Teacher.first(:mobile => '13094442075')
		@orders = Order.all(:teacher_id => @teacher.id, :order => :book_time.asc, :status => 4, :book_time.gt => Time.now)

		if @orders
			$arr << 4
		end

		redirect_to '/test_for_teacher/get_the_finish_orders'
	end

	get :get_the_finish_orders, :map => '/get_the_finish_orders' do
		@teacher = Teacher.first(:mobile => '13094442075')
		@teacher.check_order
		@orders = @teacher.done_or_cancel_orders.all(:order => :book_time.desc)

		if @orders
			$arr << 5
		end

		redirect_to '/test_for_teacher/get_the_info'
	end

	get :get_the_info, :map => '/get_the_info' do
		 @teacher = Teacher.first(:mobile => '13094442075')

		 if @teacher
		 	$arr << 6
		 end

		redirect_to '/test_for_teacher/edit_info'
	end

	get :edit_info, :map => '/edit_info' do
		@teacher = Teacher.first(:mobile => '13094442075')
		@teacher.tech_type = 3

		if @teacher.save
			$arr << 7
		end

		redirect_to '/test_for_teacher/get_the_comment'
	end

	get :get_the_comment, :map => '/get_the_comment' do
		@teacher = Teacher.first(:mobile => '13094442075')
		@comments   = TeacherComment.all(:teacher_id => @teacher.id, :order => :created_at.desc)

		if @comments
			$arr << 8
		end

		redirect_to '/test_for_teacher/get_questions'
	end

	get :get_questions, :map => '/get_questions' do
		@questions = Question.all(:order=>:weight.asc, :show => true)

		if @questions
			$arr << 9
		end

		redirect_to '/test_for_teacher/reset_password'
	end

	get :reset_password, :map => '/reset_password' do
		@teacher = Teacher.first(:mobile => '13094442075')
		@teacher.password = '12345'
		if @teacher.save
			$arr << 10
			@teacher.password = '123456'
			@teacher.save
		end

		redirect_to '/test_for_teacher/logout'
	end

	get :logout, :map => '/logout' do
		arr =  JSON.parse(RestClient.get('t.tekala.cn/v1/logout'))

		if arr['status'] == 'success'
			$arr << 11
		end

		redirect_to '/test_for_teacher'
	end

	post :clear_test, :map => '/clear_test' do
		$arr = []

		redirect_to '/test_for_teacher'
	end

end