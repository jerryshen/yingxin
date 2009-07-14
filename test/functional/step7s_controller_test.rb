require 'test_helper'

class Step7sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:step7s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create step7" do
    assert_difference('Step7.count') do
      post :create, :step7 => { }
    end

    assert_redirected_to step7_path(assigns(:step7))
  end

  test "should show step7" do
    get :show, :id => step7s(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => step7s(:one).to_param
    assert_response :success
  end

  test "should update step7" do
    put :update, :id => step7s(:one).to_param, :step7 => { }
    assert_redirected_to step7_path(assigns(:step7))
  end

  test "should destroy step7" do
    assert_difference('Step7.count', -1) do
      delete :destroy, :id => step7s(:one).to_param
    end

    assert_redirected_to step7s_path
  end
end
