module SinatraApi
  module TitleApp
    def self.registered(app)
      app.get "/titles" do
        titles = SinatraApi
          .db[:title]
          .select(:id, :title, :production_year, :kind_id)
          .limit(10)
          .all

        json titles
      end
    end
  end
end
