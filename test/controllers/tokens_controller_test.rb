require 'test_helper'

class TokensControllerTest < ActionController::TestCase
  setup do
    @token = tokens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tokens)
  end

  test "should create token" do
    assert_difference('Token.count') do
      post :create, token: { authentication_token: @token.authentication_token, client_id: @token.client_id, user_id: @token.user_id }
    end

    assert_response 201
  end

  test "should show token" do
    get :show, id: @token
    assert_response :success
  end

  test "should update token" do
    put :update, id: @token, token: { authentication_token: @token.authentication_token, client_id: @token.client_id, user_id: @token.user_id }
    assert_response 204
  end

  test "should destroy token" do
    assert_difference('Token.count', -1) do
      delete :destroy, id: @token
    end

    assert_response 204
  end
end
