require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stat" do
    assert_difference('Stat.count') do
      post :create, :stat => { }
    end

    assert_redirected_to stat_path(assigns(:stat))
  end

  test "should show stat" do
    get :show, :id => stats(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => stats(:one).to_param
    assert_response :success
  end

  test "should update stat" do
    put :update, :id => stats(:one).to_param, :stat => { }
    assert_redirected_to stat_path(assigns(:stat))
  end

  test "should destroy stat" do
    assert_difference('Stat.count', -1) do
      delete :destroy, :id => stats(:one).to_param
    end

    assert_redirected_to stats_path
  end
end
