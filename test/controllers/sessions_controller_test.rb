require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user
  end

  test "signs in with valid credentials" do
    sign_in_as(@user)

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select ".session-bar", text: /Test User/
  end

  test "rejects invalid credentials without revealing the failing field" do
    sign_in_as(@user, password: "wrong-password")

    assert_response :unprocessable_entity
    assert_select ".error", text: "E-mail ou senha inválidos"
  end

  test "signs out and protects the upload page" do
    sign_in_as(@user)
    delete session_path

    assert_redirected_to new_session_path

    get root_path
    assert_redirected_to new_session_path
  end
end
