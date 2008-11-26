require 'test_helper'

class PagesControllerTest < ActionController::TestCase
	def test_authenticates_access_to_index
		get :index
		assert_response 401
	end
	
	def test_authenticates_access_to_destroy
		post :destroy, :id => "foo"
		assert_response 401
	end
end
