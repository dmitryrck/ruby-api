require "sinatra-api_helper"

RSpec.describe SinatraApi::TitleApp, type: :feature do
  before do
    kind = SinatraApi.db[:kind_type].insert(kind: "movie")

    SinatraApi.db[:title].insert(
      title: "Ghost in the Shell",
      kind_id: kind,
      production_year: 2017
    )

    SinatraApi.db[:name].insert(
      name: "John",
      md5sum: "82144da02633cfba4287729a3c609720"
    )
  end

  context "when use is authenticated" do
    it "returns titles" do
      header "Authorization", "Token token:82144da02633cfba4287729a3c609720"
      get "/titles"

      expect(last_response.content_type).to eq "application/json"
      expect(last_response.body).to eq %([{"id":1,"title":"Ghost in the Shell","production_year":2017,"kind":{"id":1,"kind":"movie"}}])
    end
  end

  context "when use is not authenticated" do
    it "returns forbidden notice" do
      get "/titles"

      expect(last_response.content_type).to eq "application/json"
      expect(last_response.status).to eq 403
      expect(last_response.body).to eq %({"error":403,"message":"Forbidden"})
    end
  end
end
