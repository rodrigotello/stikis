require 'test_helper'

class StikisControllerTest < ActionController::TestCase
  setup do
    @stiki = stikis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stikis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stiki" do
    assert_difference('Stiki.count') do
      post :create, stiki: { area: @stiki.area, board_id: @stiki.board_id, color: @stiki.color, content: @stiki.content, positionx: @stiki.positionx, positiony: @stiki.positiony, user_id: @stiki.user_id }
    end

    assert_redirected_to stiki_path(assigns(:stiki))
  end

  test "should show stiki" do
    get :show, id: @stiki
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stiki
    assert_response :success
  end

  test "should update stiki" do
    put :update, id: @stiki, stiki: { area: @stiki.area, board_id: @stiki.board_id, color: @stiki.color, content: @stiki.content, positionx: @stiki.positionx, positiony: @stiki.positiony, user_id: @stiki.user_id }
    assert_redirected_to stiki_path(assigns(:stiki))
  end

  test "should destroy stiki" do
    assert_difference('Stiki.count', -1) do
      delete :destroy, id: @stiki
    end

    assert_redirected_to stikis_path
  end
end
