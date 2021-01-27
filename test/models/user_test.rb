require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example name", email: "example@email.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  test "shoud be valid" do
    assert @user.valid?
  end

  test "name shoud be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email shoud be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name shoud not be to long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email shoud not be to long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation shoud be accept valid addresses" do
    valid_adresses = %w[user@example.com USER@foo.COM A_US_ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_adresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} shoud be valid"
    end
  end
  
  test "email validation shoud reject invalid addresses" do
    invalid_adresses = %w[user@example,com user_at_foo.org user.name@example.
                        foo@baz_bar.com foo@baz+bar.com]
    invalid_adresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} shoud be invalid"
    end
  end

  test "email shoud be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password shoud a have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
