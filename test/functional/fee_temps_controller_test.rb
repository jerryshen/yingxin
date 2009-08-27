require 'test_helper'

class FeeTempsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fee_temps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fee_temp" do
    assert_difference('FeeTemp.count') do
      post :create, :fee_temp => { }
    end

    assert_redirected_to fee_temp_path(assigns(:fee_temp))
  end

  test "should show fee_temp" do
    get :show, :id => fee_temps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => fee_temps(:one).to_param
    assert_response :success
  end

  test "should update fee_temp" do
    put :update, :id => fee_temps(:one).to_param, :fee_temp => { }
    assert_redirected_to fee_temp_path(assigns(:fee_temp))
  end

  test "should destroy fee_temp" do
    assert_difference('FeeTemp.count', -1) do
      delete :destroy, :id => fee_temps(:one).to_param
    end

    assert_redirected_to fee_temps_path
  end
end
