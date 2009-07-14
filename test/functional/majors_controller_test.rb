require 'test_helper'

class MajorsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:majors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create major" do
    assert_difference('Major.count') do
      post :create, :major => { }
    end

    assert_redirected_to major_path(assigns(:major))
  end

  test "should show major" do
    get :show, :id => majors(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => majors(:one).to_param
    assert_response :success
  end

  test "should update major" do
    put :update, :id => majors(:one).to_param, :major => { }
    assert_redirected_to major_path(assigns(:major))
  end

  test "should destroy major" do
    assert_difference('Major.count', -1) do
      delete :destroy, :id => majors(:one).to_param
    end

    assert_redirected_to majors_path
  end
end
