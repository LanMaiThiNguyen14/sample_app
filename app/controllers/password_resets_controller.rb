class PasswordResetsController < ApplicationController
  before_action :find_get_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_reset.create.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_reset.create.danger"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("mail.passwd_reset.empty_er"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t("mail.passwd_reset.passw_reset")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]

    return if @user
    redirect_to root_path
    flash[:danger] = t(".error")
  end

  def valid_user
    return if @user&.activated?&.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = "Password reset has expired."
    redirect_to new_password_reset_url
  end
end
