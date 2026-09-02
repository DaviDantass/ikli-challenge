require "csv"

class SalesFileValidator
  MAX_FILE_SIZE = 5.megabytes
  MAX_ROWS = 10_000
  HEADERS = [
    "purchaser name", "item description", "item price",
    "purchase count", "merchant address", "merchant name"
  ].freeze

  class InvalidFileError < StandardError; end

  def initialize(file)
    @file = file
  end

  def validate!
    raise InvalidFileError, "O arquivo excede 5 MB" if File.size(@file.path) > MAX_FILE_SIZE

    content = File.binread(@file.path).force_encoding(Encoding::UTF_8)
    raise InvalidFileError, "O arquivo deve estar em UTF-8" unless content.valid_encoding?

    rows = CSV.parse(content, headers: true, col_sep: "\t")
    raise InvalidFileError, "Cabeçalho do arquivo é inválido" unless rows.headers.compact == HEADERS
    raise InvalidFileError, "O arquivo não possui vendas" if rows.empty?
    raise InvalidFileError, "O arquivo excede 10.000 vendas" if rows.size > MAX_ROWS

    rows.each_with_index { |row, index| validate_row!(row, index + 2) }
    rows
  rescue CSV::MalformedCSVError => error
    raise InvalidFileError, "Arquivo malformado: #{error.message}"
  end

  private

  def validate_row!(row, line)
    raise InvalidFileError, "Linha #{line}: quantidade de colunas inválida" unless row.fields.size == HEADERS.size
    raise InvalidFileError, "Linha #{line}: existem campos vazios" if row.fields.any? { |value| value.to_s.strip.empty? }

    price = BigDecimal(row["item price"], exception: false)
    raise InvalidFileError, "Linha #{line}: preço inválido" unless price&.>= 0

    quantity = row["purchase count"]
    raise InvalidFileError, "Linha #{line}: quantidade inválida" unless quantity.match?(/\A[1-9]\d*\z/)
  end
end
