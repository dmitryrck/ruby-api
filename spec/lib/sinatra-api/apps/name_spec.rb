require "sinatra-api_helper"

RSpec.describe SinatraApi::NameApp, type: :feature do
  before do
    SinatraApi.db[:name].insert(
      name: "John",
      md5sum: "82144da02633cfba4287729a3c609720"
    )
  end

  context "when use is authenticated" do
    it "returns names" do
      header "Authorization", "Token token:82144da02633cfba4287729a3c609720"
      get "/names"

      expect(last_response.content_type).to eq "application/json"

      body = JSON.parse(last_response.body)[0]
      expect(body).to include("id")
      expect(body).to include("name" => "John")
      expect(body).to include("md5sum")
    end
  end

  context "when use is not authenticated" do
    it "returns forbidden notice" do
      get "/names"

      expect(last_response.content_type).to eq "application/json"
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq %({"error":403,"message":"Forbidden"})
    end
  end
end
