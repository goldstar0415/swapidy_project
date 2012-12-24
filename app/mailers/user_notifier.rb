class UserNotifier < ActionMailer::Base
  default :from => "\"#{SITE_NAME}\"<system@#{ROOT_URI}>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.authentication_notifier.user_activation.subject
  #
  def signup_greeting(user)
    @user = user
    mail to: user.email
  end

end