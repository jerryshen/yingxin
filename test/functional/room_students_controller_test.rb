require 'test_helper'

class RoomStudentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:room_students)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room_student" do
    assert_difference('RoomStudent.count') do
      post :create, :room_student => { }
    end

    assert_redirected_to room_student_path(assigns(:room_student))
  end

  test "should show room_student" do
    get :show, :id => room_students(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => room_students(:one).to_param
    assert_response :success
  end

  test "should update room_student" do
    put :update, :id => room_students(:one).to_param, :room_student => { }
    assert_redirected_to room_student_path(assigns(:room_student))
  end

  test "should destroy room_student" do
    assert_difference('RoomStudent.count', -1) do
      delete :destroy, :id => room_students(:one).to_param
    end

    assert_redirected_to room_students_path
  end
end
