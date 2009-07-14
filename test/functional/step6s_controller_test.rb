require 'test_helper'

class Step6sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:step6s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create step6" do
    assert_difference('Step6.count') do
      post :create, :step6 => { }
    end

    assert_redirected_to step6_path(assigns(:step6))
  end

  test "should show step6" do
    get :show, :id => step6s(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => step6s(:one).to_param
    assert_response :success
  end

  test "should update step6" do
    put :update, :id => step6s(:one).to_param, :step6 => { }
    assert_redirected_to step6_path(assigns(:step6))
  end

  test "should destroy step6" do
    assert_difference('Step6.count', -1) do
      delete :destroy, :id => step6s(:one).to_param
    end

    assert_redirected_to step6s_path
  end
end
