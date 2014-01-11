class DevelopmentMailInterceptor
  
  def self.delivering_email(message)
    message.subject = "@#{message.to} #{message.subject}"
    message.to = "krolly@gmail.com"
  end

end