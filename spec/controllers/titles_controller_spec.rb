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
end
