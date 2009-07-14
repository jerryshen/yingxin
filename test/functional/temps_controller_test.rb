require 'test_helper'

class TempsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:temps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create temp" do
    assert_difference('Temp.count') do
      post :create, :temp => { }
    end

    assert_redirected_to temp_path(assigns(:temp))
  end

  test "should show temp" do
    get :show, :id => temps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => temps(:one).to_param
    assert_response :success
  end

  test "should update temp" do
    put :update, :id => temps(:one).to_param, :temp => { }
    assert_redirected_to temp_path(assigns(:temp))
  end

  test "should destroy temp" do
    assert_difference('Temp.count', -1) do
      delete :destroy, :id => temps(:one).to_param
    end

    assert_redirected_to temps_path
  end
end
