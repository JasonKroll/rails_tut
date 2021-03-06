class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :toggle_admin]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :toggle_admin]
  before_action :not_signed_in, only: [:create, :new]

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def new
     @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_account_activation
      redirect_to root_url, notice: "An email has been sent to you with an authorization link. Please check you email."  
      # UserMailer.registration_confirmation(@user).deliver
      # sign_in @user
      # flash[:success] = "Welcome to Rails Tut!"
      # redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def toggle_admin
    @user = User.find(params[:id])
    unless current_user?(@user)
      if @user.admin?
        @user.update_attributes(admin: false)
      else
        @user.update_attributes(admin: true)
      end
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # This has been moved to the sessions helper as we need it in the microposts controller as well
    # def signed_in_user
    #     redirect_to signin_url, notice: "Please signin." unless signed_in?
    # end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def current_user?(user)
      current_user == user
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def not_signed_in
      if signed_in?
        redirect_to(root_url)
        flash[:alert] = "You're already signed in. Please sign out to create another account."
      end
    end
end
