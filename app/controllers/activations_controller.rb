class ActivationsController < ApplicationController

  def new
    @user = User.find_by(email: params[:email])
    # @user = User.find_by_email(params[:email])
    # user = User.find_by_email(params[:email])
    # user.send_account_activation if user
    # redirect_to root_url, notice: "An email has been sent to you with an authorization link. Please check you email."  
  end

  def create
    # user = User.find_by_email(params[:email])
    user = User.find_by_email(params[:email])
    if user
      user.send_account_activation
      redirect_to root_url, notice: "An email has been sent to email address #{params[:email]} with an authorization link."  
    else
      redirect_to root_url, notice: "Can't find user.#{params[:email]}"
    end

  end

  def edit
    @user = User.find_by_activation_token!(params[:id])
    # sign_in @user
  end

  def update
    @user = User.find_by_activation_token!(params[:id])
    unless @user.nil?
      @user.update_attribute(:active, true)
      @user.update_attribute(:activation_token, nil)
      @user.send_registration_confirmation
      sign_in @user
      redirect_to @user   
    else
      redirect_to root_url, alert: "Can't find account."
    end
  end
end
