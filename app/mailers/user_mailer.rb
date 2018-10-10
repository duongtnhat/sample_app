class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: Settings.mail.subject
  end
end
