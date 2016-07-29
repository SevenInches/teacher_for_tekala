require 'json'
require 'rest-client'

Tekala::TestForSchool.controllers :test_for_school  do

	get :index, :map => '/' do
	    $arr ||= []

	    render 'index'
	end

	post :get_the_amount_of_students_of_this_month, :map => '/get_the_amount_of_students_of_this_month' do
		arr =  JSON.parse(RestClient.post('http://t.tekala.cn/school/v1/login',
						:demo => '就是这个feel倍爽'
                                                 	  ))

		if arr["data"]['user_num'] && arr["data"]['signup_amount'] && arr['status'] == 'success'
			$arr << 1
		end

		redirect_to '/test_for_school/get_the_teachers'
	end

	get :get_the_teachers, :map => '/get_the_teachers' do
		@school = School.first
		@teachers = @school.teachers.all(:open => 1)
      		@total = @teachers.count

      		if @teachers && @total
      			$arr << 2
      		end

		redirect_to '/test_for_school/get_the_students'
	end

	get :get_the_students, :map => '/get_the_students' do
		@school = School.first
		@users = @school.users
      		@total = @users.count

      		if @users && @total
      			$arr << 3
      		end

		redirect_to '/test_for_school/logout'
	end

	get :logout, :map => '/logout' do
		arr = JSON.parse(RestClient.post('t.tekala.cn/school/v1/logout', :haha => '123'))

		if arr['status'] == 'success'
			$arr << 4
		end

		redirect_to '/test_for_school'
	end

	post :clear_test, :map => '/clear_test' do
		$arr = []

		redirect_to '/test_for_school'
	end

end