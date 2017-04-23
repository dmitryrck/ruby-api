require "rubygems"
require "bundler/setup"

require "sinatra"
require "psych"

require "sequel"
require "json"
require "sinatra/json"

%i[helpers apps].each do |basedir|
  Pathname.glob(Pathname.pwd.join("lib/sinatra-api/#{basedir}/**/*.rb")).each do |entry|
    require entry
  end
end

autoload :KindType, "./lib/sinatra-api/models/kind_type"
autoload :Title,    "./lib/sinatra-api/models/title"
autoload :Name,     "./lib/sinatra-api/models/name"

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
        halt 403
      end
    end

    helpers do
      include SinatraApi::ApplicationHelper
    end

    register SinatraApi::TitleApp
    register SinatraApi::NameApp

    error 403 do
      json({ "error" => 403, "message" => "Forbidden" })
    end

    error 404 do
      json({ "error" => 404, "message" => "Not Found" })
    end
  end
end
