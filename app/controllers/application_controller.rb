class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :restrict_access

  private

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      token = token.split(":")[-1]

      if name = Name.where(md5sum: token).limit(1)[0]
        name
      end
    end
  end
end
