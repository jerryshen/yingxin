require 'test_helper'

class ClassStudentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:class_students)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create class_student" do
    assert_difference('ClassStudent.count') do
      post :create, :class_student => { }
    end

    assert_redirected_to class_student_path(assigns(:class_student))
  end

  test "should show class_student" do
    get :show, :id => class_students(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => class_students(:one).to_param
    assert_response :success
  end

  test "should update class_student" do
    put :update, :id => class_students(:one).to_param, :class_student => { }
    assert_redirected_to class_student_path(assigns(:class_student))
  end

  test "should destroy class_student" do
    assert_difference('ClassStudent.count', -1) do
      delete :destroy, :id => class_students(:one).to_param
    end

    assert_redirected_to class_students_path
  end
end
