require 'json'
require 'rest-client'

Tekala::TestForShop.controllers :test_for_shop  do

	get :index, :map => '/' do
		$arr ||= []

		render 'index'
	end

	post :login, :map => '/login' do
		arr =  JSON.parse(RestClient.post('t.tekala.cn/shop/v1/login',
						:phone => '13094442070',
						:password => '123456'
                                                 	  ))

		if arr['status'] == 'success'
			$arr << 1
		end

		redirect_to '/test_for_shop/get_index_data'
	end

	get :get_index_data, :map => '/get_index_data' do
		a = Student.user_num + Consultant.user_num.to_f
		b = Student.user_num
		c = ( a == 0 ? 1.0 : b / a )
		
		if a && b && c
			$arr << 2
		end

		redirect_to '/test_for_shop/add_consultants'
	end

	get :add_consultants, :map => '/add_consultants' do
		consultant  = Consultant.create(:name => '周杰伦', :sex => 1, :mobile => '13094442075', :age => 38, :shop_id => Shop.first.id)
		if consultant.save
			$arr << 3
		end

		redirect_to '/test_for_shop/consultants'
	end

	get :get_consultants, :map => '/consultants' do
		@shop = Shop.first
		@consultants = @shop.consultants

		if @consultants
			$arr << 4
		end

		redirect_to '/test_for_shop/add_students'
	end

	get :add_students, :map => 'add_students' do
		consultant = Consultant.first(:name => '周杰伦')
		student = Student.create(:name => consultant.name, :sex => consultant.sex, :age => consultant.age, :mobile => consultant.mobile, :shop_id => Shop.first.id)
		if student.save
			$arr << 5
		end

		redirect_to '/test_for_shop/students'
	end

	get :students, :map => '/students' do
		@shop = Shop.first
		@students = @shop.students

		if @students
			$arr << 6
		end

		redirect_to '/test_for_shop/delete_consultants'
	end

	get :delete_consultants, :map => '/delete_consultants' do
		consultant = Consultant.new
		consultant.name = '周杰伦'

		if consultant.save
			consultant = Consultant.first(:name => '周杰伦')
			if consultant.destroy
				$arr << 7
			end

			redirect_to '/test_for_shop/delete_students'
		else
			redirect_to '/test_for_shop'
		end
	end

	get :delete_students, :map => '/delete_students' do
		student = Student.first(:name => '周杰伦')
		if student.destroy
			$arr << 8
		end

		redirect_to '/test_for_shop/logout'
	end

	get :logout, :map => '/logout' do
		arr =  JSON.parse(RestClient::Request.execute(method: :post, url: 'http://t.tekala.cn/shop/v1/logout'))

		if arr['status'] == 'success'
			$arr << 9
		end

		redirect_to '/test_for_shop'
	end

	post :clear_test, :map => '/clear_test' do
		$arr = []

		redirect_to '/test_for_shop'
	end

end