require 'test_helper'

class ProcesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proce" do
    assert_difference('Proce.count') do
      post :create, :proce => { }
    end

    assert_redirected_to proce_path(assigns(:proce))
  end

  test "should show proce" do
    get :show, :id => proces(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => proces(:one).to_param
    assert_response :success
  end

  test "should update proce" do
    put :update, :id => proces(:one).to_param, :proce => { }
    assert_redirected_to proce_path(assigns(:proce))
  end

  test "should destroy proce" do
    assert_difference('Proce.count', -1) do
      delete :destroy, :id => proces(:one).to_param
    end

    assert_redirected_to proces_path
  end
end
