class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[new create]

  def new
  end

  def create
    user = User.authenticate_by(
      email: params[:email].to_s.strip.downcase,
      password: params[:password]
    )

    if user
      reset_session
      session[:user_id] = user.id
      redirect_to root_path, notice: "Login realizado com sucesso"
    else
      flash.now[:alert] = "E-mail ou senha inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, notice: "Sessão encerrada"
  end
end
