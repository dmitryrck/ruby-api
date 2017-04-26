require "sinatra-api_helper"

RSpec.describe SinatraApi::TitleApp do
  before do
    SinatraApi.db[:name].insert(
      name: "John",
      md5sum: "82144da02633cfba4287729a3c609720"
    )
  end

  let!(:kind_id) { SinatraApi.db[:kind_type].insert(kind: "movie") }

  context "when use is authenticated" do
    before do
      header "Authorization", "Token token:82144da02633cfba4287729a3c609720"
    end

    context "GET /titles" do
      before do
        30.times do |number|
          SinatraApi.db[:title].insert(
            title: "Title##{number.succ}",
            kind_id: kind_id,
            production_year: 2017
          )
        end
      end

      it "should return correct content_type" do
        get "/titles"

        expect(last_response.content_type).to eq "application/json"
      end

      context "without a page params" do
        it "returns titles" do
          get "/titles"

          titles = JSON.parse(last_response.body).map { |json| json["title"] }

          30.downto(21).each do |number|
            expect(titles).to include("Title##{number}")
          end
        end
      end

      context "with a page params" do
        before { get "/titles?page=#{page}" }

        context "requesting first page" do
          let(:page) { 1 }

          it "returns titles" do
            titles = JSON.parse(last_response.body).map { |json| json["title"] }

            30.downto(21).each do |number|
              expect(titles).to include("Title##{number}")
            end
          end
        end

        context "requesting second page" do
          let(:page) { 2 }

          it "returns titles of the second page" do
            titles = JSON.parse(last_response.body).map { |json| json["title"] }

            20.downto(11).each do |number|
              expect(titles).to include("Title##{number}")
            end
          end
        end
      end
    end

    context "POST /titles" do
      context "with valid attributes" do
        let(:params) do
          { "title" => "Logan", "production_year" => 2017, "kind_id" => kind_id }
        end

        before do
          post "/titles", params.to_json
        end

        it "should be able to create" do
          body = JSON.parse(last_response.body)
          expect(body).to include("id")
          expect(body).to include("title" => "Logan")
          expect(body).to include("production_year" => 2017)
          expect(body).to include("kind")
        end

        it "should return correct content_type" do
          expect(last_response.content_type).to eq "application/json"
        end
      end

      context "with invalid attributes" do
        let(:params) do
          { "title" => "", "production_year" => 2017, "kind_id" => kind_id }
        end

        before do
          post "/titles", params.to_json
        end

        it "should return error message" do
          expect(last_response.content_type).to eq "application/json"

          body = JSON.parse(last_response.body)
          expect(body).to include("title" => ["can't be empty"])
        end

        it "should return correct http status" do
          expect(last_response.status).to eq 422
        end
      end
    end

    context "PUT /titles" do
      let!(:title_id) do
        SinatraApi.db[:title].insert(
          title: "Ghost in the Shell",
          kind_id: kind_id,
          production_year: 2017
        )
      end

      context "with a invalid id" do
        let(:params) do
          { "title" => "Ghost in the Shell", "production_year" => 2017, "kind_id" => kind_id }
        end

        before do
          put "/titles/1000", params.to_json
        end

        it "should return 404" do
          expect(last_response.status).to eq 404
        end

        it "should return correct content_type" do
          expect(last_response.content_type).to eq "application/json"
        end
      end

      context "with valid attributes" do
        let(:params) do
          { "title" => "Ghost in the Shell (SE)", "production_year" => 2018, "kind_id" => episode_id }
        end

        let!(:episode_id) { SinatraApi.db[:kind_type].insert(kind: "episode") }

        before do
          put "/titles/#{title_id}", params.to_json
        end

        it "should be able to update" do
          body = JSON.parse(last_response.body)

          expect(body).to include("id" => title_id)
          expect(body).to include("title" => "Ghost in the Shell (SE)")
          expect(body).to include("production_year" => 2018)
          expect(body["kind"]).to include("id" => episode_id)
        end

        it "should return correct content_type" do
          expect(last_response.content_type).to eq "application/json"
        end
      end

      context "with invalid attributes" do
        let(:params) do
          { "title" => "", "production_year" => 2017 }
        end

        before do
          put "/titles/#{title_id}", params.to_json
        end

        it "should return error message" do
          expect(last_response.content_type).to eq "application/json"

          body = JSON.parse(last_response.body)
          expect(body).to include("title" => ["can't be empty"])
        end

        it "should return correct http status" do
          expect(last_response.status).to eq 422
        end
      end
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
