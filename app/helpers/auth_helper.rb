module AuthHelper

  def check_email_presence_and_uniqueness
    email = params[:auth][:email]
    if email.blank?
      render json: { error: 'Email is required' }, status: :unprocessable_entity
    elsif !email.match?(URI::MailTo::EMAIL_REGEXP)
      render json: { error: 'Email must be a valid email address' }, status: :unprocessable_entity
    elsif Profile.exists?(email: email)
      render json: { error: 'Email has already been taken' }, status: :unprocessable_entity
    end
  end

  def validate_phone_number
    phone_number = params[:auth][:phone_number]
    return if phone_number.blank?

    if phone_number.length > 13
      render json: { error: 'Phone number must be a maximum of 13 characters' }, status: :unprocessable_entity
    elsif !phone_number.match?(/\A\+?[0-9]+\z/)
      render json: { error: 'Phone number must contain only numbers and one plus sign at the beginning' }, status: :unprocessable_entity
    end
  end
end
