ENV["RACK_ENV"] ||= "development"

require "pathname"
require Pathname.pwd.join("lib/sinatra-api/application.rb").to_s

SinatraApi.db = Sequel.connect(Psych.load(ERB.new(IO.read(Pathname.pwd.join("config/database.yml"))).result)[ENV['RACK_ENV']])

use Rack::ContentLength
run SinatraApi::Application.new
