module ActionAuth
  class RegistrationsController < ApplicationController
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        if ActionAuth.configuration.verify_email_on_sign_in
          send_email_verification
          redirect_to main_app.root_path, notice: "Welcome! You have signed up successfully. Please check your email to verify your account."
        else
          session_record = @user.action_auth_sessions.create!
          cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

          redirect_to main_app.root_path, notice: "Welcome! You have signed up successfully"
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
      def user_params
        params.permit(:email, :password, :password_confirmation)
      end

      def send_email_verification
        UserMailer.with(user: @user).email_verification.deliver_later
      end
  end
end
