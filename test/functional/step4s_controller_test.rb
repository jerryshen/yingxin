require 'test_helper'

class Step4sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:step4s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create step4" do
    assert_difference('Step4.count') do
      post :create, :step4 => { }
    end

    assert_redirected_to step4_path(assigns(:step4))
  end

  test "should show step4" do
    get :show, :id => step4s(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => step4s(:one).to_param
    assert_response :success
  end

  test "should update step4" do
    put :update, :id => step4s(:one).to_param, :step4 => { }
    assert_redirected_to step4_path(assigns(:step4))
  end

  test "should destroy step4" do
    assert_difference('Step4.count', -1) do
      delete :destroy, :id => step4s(:one).to_param
    end

    assert_redirected_to step4s_path
  end
end
