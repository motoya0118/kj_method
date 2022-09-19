require "test_helper"

class ThemasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @thema = themas(:one)
  end

  test "should get index" do
    get themas_url
    assert_response :success
  end

  test "should get new" do
    get new_thema_url
    assert_response :success
  end

  test "should create thema" do
    assert_difference('Thema.count') do
      post themas_url, params: { thema: { lock: @thema.lock, name: @thema.name, purpose: @thema.purpose } }
    end

    assert_redirected_to thema_url(Thema.last)
  end

  test "should show thema" do
    get thema_url(@thema)
    assert_response :success
  end

  test "should get edit" do
    get edit_thema_url(@thema)
    assert_response :success
  end

  test "should update thema" do
    patch thema_url(@thema), params: { thema: { lock: @thema.lock, name: @thema.name, purpose: @thema.purpose } }
    assert_redirected_to thema_url(@thema)
  end

  test "should destroy thema" do
    assert_difference('Thema.count', -1) do
      delete thema_url(@thema)
    end

    assert_redirected_to themas_url
  end
end
