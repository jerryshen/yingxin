require 'test_helper'

class Step3sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:step3s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create step3" do
    assert_difference('Step3.count') do
      post :create, :step3 => { }
    end

    assert_redirected_to step3_path(assigns(:step3))
  end

  test "should show step3" do
    get :show, :id => step3s(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => step3s(:one).to_param
    assert_response :success
  end

  test "should update step3" do
    put :update, :id => step3s(:one).to_param, :step3 => { }
    assert_redirected_to step3_path(assigns(:step3))
  end

  test "should destroy step3" do
    assert_difference('Step3.count', -1) do
      delete :destroy, :id => step3s(:one).to_param
    end

    assert_redirected_to step3s_path
  end
end
