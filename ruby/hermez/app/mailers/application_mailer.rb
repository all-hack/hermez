class ApplicationMailer < ActionMailer::Base
  default from: "hermez@42.us.org"

  def mail_received(list, emails)    
    mail(to: ENV['MAIL_42_U'],
         bcc: emails,
         body: "Good news,

You have mail in the bocal!

You are not alone however. Due to the volume of mail that goes through the bocal you will have 7 days to arrange for it to be picked up before it is removed.

Thank you,
Hermez",
         content_type: "text/html",
         subject: "You've got mail!")
    
  end    






end
