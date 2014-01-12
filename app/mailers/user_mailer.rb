class UserMailer < ActionMailer::Base
  default from: "noreply.kconcepts@gmail.com"

  def registration_confirmation(user)
    @user = user
    # can add attachment
    # attachments["asdfasd.png"] = File.read("#{Rails.root}/public/images/asdfasd.png")
    # might want to check if public/images is the correct location now or is it assets?
    mail(to: user.email, subject: "Your Registered on Garraway Twits")
  end
  
  def password_reset(user)
    @user = user
    mail(to: user.email, subject: "Password Reset")
  end
end
