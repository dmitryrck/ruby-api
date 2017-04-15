ENV["RACK_ENV"] = "test"

require "rubygems"
require "bundler/setup"

require "pathname"
require "nokogiri"
require "rack/test"

require "spec_helper"

ENV["DATABASE_URL"] = "sqlite:/"

require Pathname.pwd.join("lib/sinatra-api/application")

SinatraApi.db = Sequel.connect(ENV["DATABASE_URL"])

SinatraApi.db.create_table(:title) do
  primary_key :id
  String :title, null: false
  String :imdb_index
  Integer :kind_id, null: false
  Integer :production_year
  Integer :imdb_id
  String :phonetic_code
  Integer :episode_of_id
  Integer :season_nr
  Integer :episode_nr
  String :series_years
  String :md5sum
end

SinatraApi.db.create_table(:name) do
  primary_key :id
  String :name, null: false
  String :imdb_index
  Integer :imdb_id
  String :gender
  String :name_pcode_cf
  String :name_pcode_nf
  String :surname_pcode
  String :md5sum
end

SinatraApi.db.create_table(:kind_type) do
  primary_key :id
  String :kind, null: false
end

RSpec.configure do |config|
  include Rack::Test::Methods

  def app
    SinatraApi::Application.new
  end

  config.before(:each) do
    %i[title name kind_type].each do |model|
      SinatraApi.db.run("delete from #{model};")
    end
  end
end
