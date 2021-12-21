class ClientMailer < ApplicationMailer
    default from: 'notifications@example.com'

    def welcome_email
      @user = params[:user]
      mail(to: @user.email, subject: "#{@user.full_name}, Welcome to the MoonTrade trading app!")
    end

    def confirmation_email
        @user = params[:user]
        @url  = 'http://moontrade.com/sign_in'
        mail(to: @user.email, subject: "#{@user.full_name}, An update on your registration status.")
      end
end
