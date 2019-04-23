class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      flash.now[:success] = t ".success"
      login_with_remember user
    else
      flash[:danger] = t "controller.sessions.wrongmail_password"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
