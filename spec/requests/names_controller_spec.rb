require "rails_helper"

RSpec.describe NamesController do
  context "when user is not authenticated" do
    let(:headers) do
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
    end

    it "should return prohibited" do
      get "/names", headers: headers
      expect(response.status).to be 401
    end
  end

  context "when user is authenticated" do
    let!(:john) { create(:john) }

    let(:headers) do
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Authorization" => "Token token:#{john.md5sum}"
      }
    end

    describe "GET index" do
      it "assigns @names" do
        get "/names", headers: headers
        expect(assigns(:names)).to eq([john])
      end

      it "respond with names" do
        get "/names", headers: headers

        content = JSON.parse(response.body)[0]

        expect(content).to include("id")
        expect(content).to include("name" => "John")
        expect(content).to include("md5sum")
      end
    end

    describe "POST create" do
      context "with valid params" do
        let(:params) do
          build(:jane).attributes.reject { |_, value| value.blank? }
        end

        it "should be able to create" do
          expect {
            post "/names", params: params.to_json, headers: headers
          }.to change(Name, :count).by(1)
        end

        it "should return the created object" do
          post "/names", params: params.to_json, headers: headers

          content = JSON.parse(response.body)

          expect(content).to include("id")
          expect(content).to include("name" => "Jane")
          expect(content).to include("md5sum")
        end
      end

      context "with invalid params" do
        it "should not be able to create" do
          expect {
            post "/names", params: {}.to_json, headers: headers
          }.not_to change(Name, :count)
        end

        it "should return error messages" do
          post "/names", params: {}.to_json, headers: headers

          expect(JSON.parse(response.body)).to include("name" => ["can't be blank"])
        end

        it "should return correct http status" do
          post "/names", params: {}.to_json, headers: headers

          expect(response.status).to eq 422
        end
      end
    end

    describe "PUT update" do
      let!(:jane) { create(:jane) }

      context "with valid params" do
        let(:params) do
          { "name" => "Jane Doe" }
        end

        it "should be able to update" do
          expect {
            put "/names/#{jane.id}", params: params.merge(id: jane.id).to_json, headers: headers
          }.not_to change(Name, :count)
        end

        it "should return the updated object" do
          put "/names/#{jane.id}", params: params.merge(id: jane.id).to_json, headers: headers

          content = JSON.parse(response.body)

          expect(content).to include("id" => jane.id)
          expect(content).to include("name" => "Jane Doe")
          expect(content).to include("md5sum")
        end
      end

      context "with invalid params" do
        it "should not be able to update" do
          expect {
            put "/names/#{jane.id}", params: { name: "" }.to_json, headers: headers
          }.not_to change(Name, :count)
        end

        it "should return error messages" do
          put "/names/#{jane.id}", params: { name: "" }.to_json, headers: headers

          expect(JSON.parse(response.body)).to include("name" => ["can't be blank"])
        end

        it "should return correct http status" do
          put "/names/#{jane.id}", params: { name: "" }.to_json, headers: headers

          expect(response.status).to eq 422
        end
      end
    end
  end
end
