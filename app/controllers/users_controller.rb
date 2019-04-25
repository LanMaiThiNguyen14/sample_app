class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t(".new.success_ac")
      redirect_to @user
    else
      flash[:danger] = t(".new.fail_ac")
      render :new
    end
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page],
                                            per_page: Settings.Post.num_post)
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".destroy.success"
      redirect_to users_url
    else
      flash[:error] = t ".destroy.unsuccess"
      redirect_to root_url
    end
  end

  private

  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    redirect_to root_path
    flash[:danger] = t ".error"
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
