require "test_helper"

class SalesFileValidatorTest < ActiveSupport::TestCase
  test "accepts a valid tab-separated file" do
    File.open(file_fixture("example_input.tab")) do |file|
      assert_equal 4, SalesFileValidator.new(file).validate!.size
    end
  end

  test "rejects empty fields" do
    error = validate_content("John\tProduct\t10.00\t1\t\tStore")
    assert_match(/campos vazios/, error.message)
  end

  test "rejects invalid price and quantity" do
    assert_match(/preço inválido/, validate_content("John\tProduct\tfree\t1\tStreet\tStore").message)
    assert_match(/quantidade inválida/, validate_content("John\tProduct\t10.00\t0\tStreet\tStore").message)
  end

  private

  def validate_content(row)
    Tempfile.create([ "sales", ".tab" ]) do |file|
      file.write("#{SalesFileValidator::HEADERS.join("\t")}\n#{row}\n")
      file.flush
      SalesFileValidator.new(file).validate!
    end
  rescue SalesFileValidator::InvalidFileError => error
    error
  end
end
