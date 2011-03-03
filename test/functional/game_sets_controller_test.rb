require 'test_helper'

class GameSetsControllerTest < ActionController::TestCase
  setup do
    @game_set = game_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_set" do
    assert_difference('GameSet.count') do
      post :create, :game_set => @game_set.attributes
    end

    assert_redirected_to game_set_path(assigns(:game_set))
  end

  test "should show game_set" do
    get :show, :id => @game_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @game_set.to_param
    assert_response :success
  end

  test "should update game_set" do
    put :update, :id => @game_set.to_param, :game_set => @game_set.attributes
    assert_redirected_to game_set_path(assigns(:game_set))
  end

  test "should destroy game_set" do
    assert_difference('GameSet.count', -1) do
      delete :destroy, :id => @game_set.to_param
    end

    assert_redirected_to game_sets_path
  end
end
