require 'development_mail_interceptor' #add this line
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

