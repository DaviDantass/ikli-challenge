module AuthenticationTestHelper
  DEFAULT_PASSWORD = "password123"

  def create_user(email: "user@example.com")
    User.create!(
      name: "Test User",
      email: email,
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  def sign_in_as(user, password: DEFAULT_PASSWORD)
    post session_path, params: { email: user.email, password: password }
  end
end
