require "rails_helper"

RSpec.describe TitlesController do
  describe "GET index" do
    let!(:title) { create(:ghost_in_the_shell) }

    it "assigns @titles" do
      get :index
      expect(assigns(:titles)).to eq([title])
    end

    it "respond with titles" do
      get :index
      expect(JSON.parse(response.body)[0]).to include("title" => "Ghost in the Shell")
    end
  end

  describe "POST create" do
    context "with valid params" do
      let(:params) do
        build(:logan).attributes.reject { |_, value| value.blank? }
      end

      it "should be able to create" do
        expect { post :create, params: params }.to change(Title, :count).by(1)
      end

      it "should return the created object" do
        post :create, params: params

        expect(JSON.parse(response.body)).to include("title" => "Logan")
        expect(JSON.parse(response.body)).to include("id")
      end
    end

    context "with invalid params" do
      it "should not be able to create" do
        expect { post :create, params: {} }.not_to change(Title, :count)
      end

      it "should return error messages" do
        post :create, params: {}

        expect(JSON.parse(response.body)).to include("title" => ["can't be blank"])
      end

      it "should return correct http status" do
        post :create, params: {}

        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT update" do
    let!(:ghost_in_the_shell) { create(:ghost_in_the_shell) }

    context "with valid params" do
      let(:params) do
        build(:logan).attributes.reject { |_, value| value.blank? }
      end

      it "should be able to update" do
        expect {
          put :update, params: params.merge(id: ghost_in_the_shell.id)
        }.not_to change(Title, :count)
      end

      it "should return the updated object" do
        put :update, params: params.merge(id: ghost_in_the_shell.id)

        expect(JSON.parse(response.body)).to include("title" => "Logan")
        expect(JSON.parse(response.body)).to include("id" => ghost_in_the_shell.id)
      end
    end

    context "with invalid params" do
      it "should not be able to update" do
        expect { put :create, params: {} }.not_to change(Title, :count)
      end

      it "should return error messages" do
        put :update, params: { id: ghost_in_the_shell.id, title: "" }

        expect(JSON.parse(response.body)).to include("title" => ["can't be blank"])
      end

      it "should return correct http status" do
        put :update, params: { id: ghost_in_the_shell.id, title: "" }

        expect(response.status).to eq 422
      end
    end
  end
end
