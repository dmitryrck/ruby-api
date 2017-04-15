require "rubygems"
require "bundler/setup"

require "sinatra"
require "psych"

require "sequel"
require "json"
require "sinatra/json"

Pathname.glob(Pathname.pwd.join('lib/sinatra-api/helpers/**/*.rb')).each do |entry|
  require entry
end

Pathname.glob(Pathname.pwd.join('lib/sinatra-api/apps/**/*.rb')).each do |entry|
  require entry
end

module SinatraApi
  class << self
    def db
      @@db
    end

    def db=(datebase)
      @@db = datebase
    end
  end

  class Application < ::Sinatra::Application
    configure do
      set :max_age, 1800
    end

    before do
      unless auth(env['HTTP_AUTHORIZATION'])
        halt 403, {"Content-Type" => "application/json"}, '{"error":403,"message":"Forbidden"}'
      end
    end

    helpers do
      include SinatraApi::ApplicationHelper
    end

    register SinatraApi::TitleApp
  end
end
