class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mail.active_subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mail.reset_subject")
  end
end
