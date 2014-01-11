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

  def redirect_back_or(default)
    # redirect_to default
    unless session[:return_to] == signin_path
      redirect_to(session[:return_to] || default)
    else
      redirect_to(default)
    end
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def delete_location
    session[:return_to].delete
  end

  # This has been moved from the user controller as we need it in the microposts controller as well
  def signed_in_user
    store_location
    redirect_to signin_url, notice: "Please signin." unless signed_in?
  end
end
