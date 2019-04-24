class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate(params[:session][:password])
      login_with_remember user
      redirect_back_or user
      flash.now[:success] = t "sessions.success"
    else
      render :new
      flash.now[:danger] = t "sessions.error"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_with_remember user
    log_in user
    remember_me = params[:session][:remember_me]
    remember_me == Settings.checkbox ? remember(user) : forget(user)
  end
end
