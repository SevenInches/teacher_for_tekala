require 'json'
require 'rest-client'

Tekala::TestForShop.controllers :test_for_shop  do

	get :index, :map => '/' do
		$arr ||= []
		render 'index'
	end

	post :login, :map => '/login' do
		login_url = 't.tekala.cn/shop/v1/login'
		arr =  JSON.parse(RestClient.post(login_url, :phone => '13094442070', :password => '123456'))

		$arr << 'login' if arr['status'] == 'success'

		redirect_to '/test_for_shop/get_index_data'
	end

	get :get_index_data, :map => '/get_index_data' do
		a = Student.user_num + Consultant.user_num.to_f
		b = Student.user_num
		c = ( a == 0 ? 1.0 : b / a )
		
		$arr << 'get_index_data' if a && b && c

		redirect_to '/test_for_shop/add_consultants'
	end

	get :add_consultants, :map => '/add_consultants' do
		consultant  = Consultant.create(:name => '周杰伦', :sex => 1, :mobile => '13094442075', :age => 38, :shop_id => Shop.first.id)
		$arr << 'add_consultants' if consultant.save

		redirect_to '/test_for_shop/consultants'
	end

	get :get_consultants, :map => '/consultants' do
		@shop = Shop.first
		@consultants = @shop.consultants

		$arr << 'get_consultants' if @consultants

		redirect_to '/test_for_shop/add_students'
	end

	get :add_students, :map => 'add_students' do
		consultant = Consultant.first(:name => '周杰伦')
		student = Student.create(:name => consultant.name, :sex => consultant.sex, :age => consultant.age, :mobile => consultant.mobile, :shop_id => Shop.first.id)
		$arr << 'add_students' if student.save

		redirect_to '/test_for_shop/students'
	end

	get :students, :map => '/students' do
		@shop = Shop.first
		@students = @shop.students

		$arr << 'students' if @students

		redirect_to '/test_for_shop/delete_consultants'
	end

	get :delete_consultants, :map => '/delete_consultants' do
		consultant = Consultant.new
		consultant.name = '周杰伦'

		if consultant.save
			consultant = Consultant.first(:name => '周杰伦')
			$arr << 'delete_consultants' if consultant.destroy

			redirect_to '/test_for_shop/delete_students'
		else
			$arr << 'over'
			redirect_to '/test_for_shop'
		end
	end

	get :delete_students, :map => '/delete_students' do
		student = Student.first(:name => '周杰伦')
		$arr << 'delete_students' if student.destroy

		redirect_to '/test_for_shop/logout'
	end

	get :logout, :map => '/logout' do
		arr =  JSON.parse(RestClient::Request.execute(method: :post, url: 'http://t.tekala.cn/shop/v1/logout'))

		$arr << 'logout' if arr['status'] == 'success'

		$arr << 'over'

		redirect_to '/test_for_shop'
	end

	post :clear_test, :map => '/clear_test' do
		$arr = []
		redirect_to '/test_for_shop'
	end

end