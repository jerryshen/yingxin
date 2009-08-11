require 'test_helper'

class GreenPathsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:green_paths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create green_path" do
    assert_difference('GreenPath.count') do
      post :create, :green_path => { }
    end

    assert_redirected_to green_path_path(assigns(:green_path))
  end

  test "should show green_path" do
    get :show, :id => green_paths(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => green_paths(:one).to_param
    assert_response :success
  end

  test "should update green_path" do
    put :update, :id => green_paths(:one).to_param, :green_path => { }
    assert_redirected_to green_path_path(assigns(:green_path))
  end

  test "should destroy green_path" do
    assert_difference('GreenPath.count', -1) do
      delete :destroy, :id => green_paths(:one).to_param
    end

    assert_redirected_to green_paths_path
  end
end
