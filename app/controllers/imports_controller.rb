class ImportsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    file = params[:file]

    if file.blank?
      flash.now[:alert] = "Selecione um arquivo"
      return render :new, status: :unprocessable_entity
    end

    unless %w[.tab .tsv].include?(File.extname(file.original_filename).downcase)
      flash.now[:alert] = "Envie um arquivo .tab ou .tsv"
      return render :new, status: :unprocessable_entity
    end

    @total = SalesImporter.new(file).call
    render :new
  rescue SalesFileValidator::InvalidFileError => error
    flash.now[:alert] = error.message
    render :new, status: :unprocessable_entity
  end
end
