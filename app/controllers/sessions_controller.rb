class SessionsController < ApplicationController

  def new
    if signed_in?
      redirect_to current_user
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the users show page
      if user.active?
        if params[:remember_me]
          sign_in_remember_me user
        else
          sign_in user
        end
        redirect_back_or(user)
      else
        # redirect_to new_activation_path(user)
        redirect_to new_activation_path(email: user.email)
        
        # redirect_to root_url
        # flash[:error] = "Your account has not been actived. Check your email for an activation link."
      end
      # redirect_to user
    else
      # create an error message and re-render it in the signin form
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
