require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:roman)
    @other_user = users(:tomas)
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when user not admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "shoud redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "shoud redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "shoud redirect edit when logged wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "shoud redirect update when logged wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "shoud redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { password:             'password',
                                            password_confirmation: 'password',
                                            admin: true }
    assert_not @other_user.reload.admin?
  end
end
