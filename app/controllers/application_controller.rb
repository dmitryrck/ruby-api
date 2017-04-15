class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :restrict_access

  private

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      token = token.split(":")[-1]

      Name.where(md5sum: token).any?
    end
  end
end
