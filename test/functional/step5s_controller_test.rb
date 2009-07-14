require 'test_helper'

class Step5sControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:step5s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create step5" do
    assert_difference('Step5.count') do
      post :create, :step5 => { }
    end

    assert_redirected_to step5_path(assigns(:step5))
  end

  test "should show step5" do
    get :show, :id => step5s(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => step5s(:one).to_param
    assert_response :success
  end

  test "should update step5" do
    put :update, :id => step5s(:one).to_param, :step5 => { }
    assert_redirected_to step5_path(assigns(:step5))
  end

  test "should destroy step5" do
    assert_difference('Step5.count', -1) do
      delete :destroy, :id => step5s(:one).to_param
    end

    assert_redirected_to step5s_path
  end
end
