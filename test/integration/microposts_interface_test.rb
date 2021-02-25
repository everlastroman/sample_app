require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:roman)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Недопустимая информация в форме
    post microposts_path, micropost: { content: "" }
    assert_select 'div#error_explanation'
    # Допустимая информация в форме
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/index.jpeg', 'image/jpeg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content, picture: picture }
    end
    assert assigns(:micropost).picture?
    follow_redirect!
    assert_match content, response.body
    # Удаление сообщения.
    assert_select 'a', 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Переход в профиль другого пользователя.
    get user_path(users(:lana))
    assert_select 'a', { text: 'delete', count: 0 }
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # У пользователя нет сообщений
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end
