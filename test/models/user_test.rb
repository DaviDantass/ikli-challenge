require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "normalizes attributes and authenticates with the password" do
    user = User.create!(
      name: "  Test User  ",
      email: "  USER@Example.COM ",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_equal "Test User", user.name
    assert_equal "user@example.com", user.email
    assert user.authenticate("password123")
    assert_not user.authenticate("wrong-password")
  end

  test "rejects invalid email, short password, and duplicate email" do
    invalid = User.new(name: "Test", email: "invalid", password: "short")

    assert_not invalid.valid?
    assert invalid.errors.of_kind?(:email, :invalid)
    assert invalid.errors.of_kind?(:password, :too_short)

    User.create!(
      name: "One",
      email: "user@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    duplicate = User.new(name: "Two", email: "USER@example.com", password: "password123")

    assert_not duplicate.valid?
    assert duplicate.errors.of_kind?(:email, :taken)
  end
end
