class ApplicationController < ActionController::API
  include ::ActionController::Cookies
  before_action :create_identity

  def create_identity
    if cookies.signed[:user_id].blank?
      cookies.signed[:user_id] = SecureRandom.uuid
    end
  end
end
