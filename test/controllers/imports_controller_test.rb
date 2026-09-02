require "test_helper"

class ImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(create_user)
  end

  test "shows the upload form" do
    get root_path

    assert_response :success
    assert_select "input[type=file]"
  end

  test "uploads sales and displays gross income" do
    file = fixture_file_upload("example_input.tab", "text/tab-separated-values")

    assert_difference -> { Purchase.count } => 4 do
      post imports_path, params: { file: file }
    end

    assert_response :success
    assert_select ".success strong", text: "R$ 95,00"
  end

  test "rejects a missing file" do
    post imports_path

    assert_response :unprocessable_entity
    assert_select "p", text: "Selecione um arquivo"
  end

  test "rejects a file with invalid headers" do
    file = fixture_file_upload("invalid_input.tab", "text/tab-separated-values")

    assert_no_difference -> { Purchase.count } do
      post imports_path, params: { file: file }
    end

    assert_response :unprocessable_entity
    assert_select "p", text: "Cabeçalho do arquivo é inválido"
  end
end
