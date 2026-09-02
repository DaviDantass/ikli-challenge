require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "creates an account and signs the user in" do
    assert_difference -> { User.count } => 1 do
      post registration_path, params: {
        user: {
          name: "New User",
          email: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select ".session-bar", text: /New User/
  end

  test "rejects invalid registration data" do
    assert_no_difference -> { User.count } do
      post registration_path, params: {
        user: { name: "", email: "invalid", password: "short" }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".error"
  end
end
