require 'test_helper'

class ConnectsControllerTest < ActionController::TestCase
  setup do
    @connect = connects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:connects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create connect" do
    assert_difference('Connect.count') do
      post :create, connect: {  }
    end

    assert_redirected_to connect_path(assigns(:connect))
  end

  test "should show connect" do
    get :show, id: @connect
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @connect
    assert_response :success
  end

  test "should update connect" do
    patch :update, id: @connect, connect: {  }
    assert_redirected_to connect_path(assigns(:connect))
  end

  test "should destroy connect" do
    assert_difference('Connect.count', -1) do
      delete :destroy, id: @connect
    end

    assert_redirected_to connects_path
  end
end
