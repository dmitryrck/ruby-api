module SinatraApi
  module TitleApp
    def self.registered(app)
      app.get "/titles" do
        page = params.fetch("page", 1).to_i

        titles = Title.
          select(:id, :title, :production_year, :kind_id).
          extension(:pagination).paginate(page, 10).
          all.map do |title|
            {
              id: title.id,
              title: title.title,
              production_year: title.production_year,
              kind: title.kind_type.values
            }
          end

        json titles
      end
    end
  end
end
