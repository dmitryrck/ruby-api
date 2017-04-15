require "rails_helper"

RSpec.describe TitlesController do
  context "when user is not authenticated" do
    let(:headers) do
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
    end

    it "should return prohibited" do
      get "/titles", headers: headers
      expect(response.status).to be 401
    end
  end

  context "when user is authenticated" do
    let(:john) { create(:john) }

    let(:headers) do
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Authorization" => "Token token:#{john.md5sum}"
      }
    end

    describe "GET index" do
      let!(:title) { create(:ghost_in_the_shell) }

      it "assigns @titles" do
        get "/titles", headers: headers
        expect(assigns(:titles)).to eq([title])
      end

      it "respond with titles" do
        get "/titles", headers: headers

        content = JSON.parse(response.body)[0]

        expect(content).to include("id")
        expect(content).to include("title" => "Ghost in the Shell")
        expect(content).to include("production_year" => 2017)
        expect(content).to include("kind")
      end
    end

    describe "POST create" do
      context "with valid params" do
        let(:params) do
          build(:logan).attributes.reject { |_, value| value.blank? }
        end

        it "should be able to create" do
          expect {
            post "/titles", params: params.to_json, headers: headers
          }.to change(Title, :count).by(1)
        end

        it "should return the created object" do
          post "/titles", params: params.to_json, headers: headers

          content = JSON.parse(response.body)

          expect(content).to include("id")
          expect(content).to include("title" => "Logan")
          expect(content).to include("production_year" => 2017)
          expect(content).to include("kind")
        end
      end

      context "with invalid params" do
        it "should not be able to create" do
          expect {
            post "/titles", params: {}.to_json, headers: headers
          }.not_to change(Title, :count)
        end

        it "should return error messages" do
          post "/titles", params: {}.to_json, headers: headers

          expect(JSON.parse(response.body)).to include("title" => ["can't be blank"])
        end

        it "should return correct http status" do
          post "/titles", params: {}.to_json, headers: headers

          expect(response.status).to eq 422
        end
      end
    end

    describe "PUT update" do
      let!(:ghost) { create(:ghost_in_the_shell) }

      context "with valid params" do
        let(:params) do
          build(:logan).attributes.reject { |_, value| value.blank? }
        end

        it "should be able to update" do
          expect {
            put "/titles/#{ghost.id}", params: params.merge(id: ghost.id).to_json, headers: headers
          }.not_to change(Title, :count)
        end

        it "should return the updated object" do
          put "/titles/#{ghost.id}", params: params.merge(id: ghost.id).to_json, headers: headers

          content = JSON.parse(response.body)

          expect(content).to include("id" => ghost.id)
          expect(content).to include("title" => "Logan")
          expect(content).to include("production_year" => 2017)
          expect(content).to include("kind")
        end
      end

      context "with invalid params" do
        it "should not be able to update" do
          expect {
            put "/titles/#{ghost.id}", params: { title: "" }.to_json, headers: headers
          }.not_to change(Title, :count)
        end

        it "should return error messages" do
          put "/titles/#{ghost.id}", params: { title: "" }.to_json, headers: headers

          expect(JSON.parse(response.body)).to include("title" => ["can't be blank"])
        end

        it "should return correct http status" do
          put "/titles/#{ghost.id}", params: { title: "" }.to_json, headers: headers

          expect(response.status).to eq 422
        end
      end
    end
  end
end
