class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  IDENTITY_KEY = "user-id"

  before_action :read_identity
  after_action :write_identity

  def current_user_id
    @user_id
  end

  private
  def read_identity
    if !cookies[IDENTITY_KEY].blank?
      @user_id = crypto.decrypt_and_verify(cookies[IDENTITY_KEY])
    elsif !request.headers[IDENTITY_KEY].blank?
      @user_id = crypto.decrypt_and_verify(request.headers[IDENTITY_KEY])
    else
      @user_id = SecureRandom.uuid
    end

    @user_id
  end

  def write_identity
    encrypt_user_id = crypto.encrypt_and_sign(@user_id)

    response.set_cookie(IDENTITY_KEY, {
      value: encrypt_user_id,
      path: "/",
      secure: ENV["SECURE_COOKIES"],
      same_site: ENV["SECURE_COOKIES"] ? :none : :Lax
    })
    response.set_header(IDENTITY_KEY, encrypt_user_id)
  end

  def crypto
    secret_key_base = Rails.application.secrets.secret_key_base || ENV["SECRET_KEY_BASE"]
    ActiveSupport::MessageEncryptor.new(secret_key_base[0..31])
  end

end
