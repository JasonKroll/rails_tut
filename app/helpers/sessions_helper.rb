module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def sign_in_remember_me(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end
  
  def valid_password_reset(user)
    @user.password_reset_sent_at > 2.hours.ago
  end

  def clear_password_reset(user)
    @user.update_attribute(:password_reset_token, nil)
    @user.update_attribute(:password_reset_sent_at, nil)
  end

  def redirect_back_or(default)
    # redirect_to default
    if session[:return_to] == signin_path
      redirect_to(default)
    else
      redirect_to(session[:return_to] || default)
    end
    delete_location
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def delete_location
    session.delete(:return_to)
  end

  # This has been moved from the user controller as we need it in the microposts controller as well
  def signed_in_user
    if signed_in?
      delete_location
    else
      store_location
      redirect_to signin_url, notice: "Please signin."
    end
  end
end
