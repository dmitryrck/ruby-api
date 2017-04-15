module SinatraApi
  module TitleApp
    def self.registered(app)
      app.get "/titles" do
        page = params.fetch("page", 1).to_i

        titles = Title.
          select(:id, :title, :production_year, :kind_id).
          extension(:pagination).paginate(page, 10).
          all.map(&:values)

        json titles
      end
    end
  end
end
