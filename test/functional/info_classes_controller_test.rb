require 'test_helper'

class InfoClassesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:info_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create info_class" do
    assert_difference('InfoClass.count') do
      post :create, :info_class => { }
    end

    assert_redirected_to info_class_path(assigns(:info_class))
  end

  test "should show info_class" do
    get :show, :id => info_classes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => info_classes(:one).to_param
    assert_response :success
  end

  test "should update info_class" do
    put :update, :id => info_classes(:one).to_param, :info_class => { }
    assert_redirected_to info_class_path(assigns(:info_class))
  end

  test "should destroy info_class" do
    assert_difference('InfoClass.count', -1) do
      delete :destroy, :id => info_classes(:one).to_param
    end

    assert_redirected_to info_classes_path
  end
end
