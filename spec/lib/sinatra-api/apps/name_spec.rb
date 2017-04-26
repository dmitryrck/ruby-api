require "sinatra-api_helper"

RSpec.describe SinatraApi::NameApp do
  let!(:john_id) do
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

    context "GET /names" do
      before do
        30.times do |number|
          SinatraApi.db[:name].insert(
            name: "Name##{number.succ}",
            md5sum: SecureRandom.hex
          )
        end
      end

      it "should return correct content_type" do
        get "/names"

        expect(last_response.content_type).to eq "application/json"
      end

      context "without page params" do
        before { get "/names" }

        it "returns names" do
          names = JSON.parse(last_response.body).map { |json| json["name"] }

          30.downto(21).each do |number|
            expect(names).to include("Name##{number}")
          end
        end
      end

      context "with a page params" do
        before { get "/names?page=#{page}" }

        context "and request first page" do
          let(:page) { 1 }

          it "returns names" do
            names = JSON.parse(last_response.body).map { |json| json["name"] }

            30.downto(21).each do |number|
              expect(names).to include("Name##{number}")
            end
          end
        end

        context "and request second page" do
          let(:page) { 2 }

          it "returns names" do
            names = JSON.parse(last_response.body).map { |json| json["name"] }

            20.downto(11).each do |number|
              expect(names).to include("Name##{number}")
            end
          end
        end
      end
    end

    context "POST /names" do
      context "with valid attributes" do
        let(:params) do
          { "name" => "Jane", "md5sum" => "abc" }
        end

        before do
          post "/names", params.to_json
        end

        it "should be able to create" do
          body = JSON.parse(last_response.body)
          expect(body).to include("id")
          expect(body).to include("name" => "Jane")
          expect(body).to include("md5sum" => "abc")
        end

        it "should return correct content_type" do
          expect(last_response.content_type).to eq "application/json"
        end
      end

      context "with invalid attributes" do
        let(:params) do
          { "name" => "", "md5sum" => "abcd" }
        end

        before do
          post "/names", params.to_json
        end

        it "should return error message" do
          expect(last_response.content_type).to eq "application/json"

          body = JSON.parse(last_response.body)
          expect(body).to include("name" => ["can't be empty"])
        end

        it "should return correct http status" do
          expect(last_response.status).to eq 422
        end
      end
    end

    context "PUT /names" do
      let!(:name_id) do
        SinatraApi.db[:name].insert(
          name: "Jane",
          md5sum: "abc"
        )
      end

      context "with a invalid id" do
        let(:params) do
          { "name" => "Jane Doe", "md5sum" => "abcd" }
        end

        before do
          put "/names/1000", params.to_json
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
          { "name" => "Jane Doe", "md5sum" => "abcd" }
        end

        before do
          put "/names/#{name_id}", params.to_json
        end

        it "should be able to update" do
          body = JSON.parse(last_response.body)

          expect(body).to include("id" => name_id)
          expect(body).to include("name" => "Jane Doe")
          expect(body).to include("md5sum" => "abcd")
        end

        it "should return correct content_type" do
          expect(last_response.content_type).to eq "application/json"
        end
      end

      context "with invalid attributes" do
        let(:params) do
          { "name" => "", "md5sum" => "ab" }
        end

        before do
          put "/names/#{name_id}", params.to_json
        end

        it "should return error message" do
          expect(last_response.content_type).to eq "application/json"

          body = JSON.parse(last_response.body)
          expect(body).to include("name" => ["can't be empty"])
        end

        it "should return correct http status" do
          expect(last_response.status).to eq 422
        end
      end
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
