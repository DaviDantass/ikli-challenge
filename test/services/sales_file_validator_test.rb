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

  test "rejects files larger than five megabytes" do
    Tempfile.create([ "sales", ".tab" ]) do |file|
      file.truncate(SalesFileValidator::MAX_FILE_SIZE + 1)

      error = assert_raises(SalesFileValidator::InvalidFileError) do
        SalesFileValidator.new(file).validate!
      end
      assert_match(/excede 5 MB/, error.message)
    end
  end

  test "rejects invalid UTF-8" do
    error = validate_raw_content("\xFF".b)
    assert_match(/UTF-8/, error.message)
  end

  test "rejects rows with extra columns" do
    error = validate_content("John\tProduct\t10.00\t1\tStreet\tStore\tExtra")
    assert_match(/colunas inválida/, error.message)
  end

  test "rejects more than ten thousand sales" do
    row = "John\tProduct\t10.00\t1\tStreet\tStore\n"
    content = "#{SalesFileValidator::HEADERS.join("\t")}\n#{row * (SalesFileValidator::MAX_ROWS + 1)}"

    error = validate_raw_content(content)
    assert_match(/10.000 vendas/, error.message)
  end

  private

  def validate_content(row)
    validate_raw_content("#{SalesFileValidator::HEADERS.join("\t")}\n#{row}\n")
  end

  def validate_raw_content(content)
    Tempfile.create([ "sales", ".tab" ]) do |file|
      file.binmode
      file.write(content)
      file.flush
      SalesFileValidator.new(file).validate!
    end
  rescue SalesFileValidator::InvalidFileError => error
    error
  end
end
