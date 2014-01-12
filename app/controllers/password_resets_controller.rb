class PasswordResetsController < ApplicationController
  def new
  end
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_url, notice: "Email sent with password reset instructions."  
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
    # sign_in @user
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    unless @user.nil?
       if !params[:user][:password].blank?
        if @user.password_reset_sent_at < 2.hours.ago
          redirect_to new_reset_password_path, alert: "Password reset has expired."
        elsif @user.update_attributes(params.permit![:user])
          redirect_to root_url, alert: "Password has been reset!"
        else
          render :edit
        end
      else
        @user.errors[:password] = 'Cannot be blank and must match the password verification.'
        render :edit
      end
    else
      redirect_to root_url, alert: "You did not request a password reset. Please sign in."
    end
  end
end
