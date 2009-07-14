require 'test_helper'

class FeeStdsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fee_stds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fee_std" do
    assert_difference('FeeStd.count') do
      post :create, :fee_std => { }
    end

    assert_redirected_to fee_std_path(assigns(:fee_std))
  end

  test "should show fee_std" do
    get :show, :id => fee_stds(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => fee_stds(:one).to_param
    assert_response :success
  end

  test "should update fee_std" do
    put :update, :id => fee_stds(:one).to_param, :fee_std => { }
    assert_redirected_to fee_std_path(assigns(:fee_std))
  end

  test "should destroy fee_std" do
    assert_difference('FeeStd.count', -1) do
      delete :destroy, :id => fee_stds(:one).to_param
    end

    assert_redirected_to fee_stds_path
  end
end
