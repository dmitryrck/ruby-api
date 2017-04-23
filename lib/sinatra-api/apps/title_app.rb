module SinatraApi
  module TitleApp
    def self.registered(app)
      app.get "/titles" do
        page = params.fetch("page", 1).to_i

        titles = Title.
          select(:id, :title, :production_year, :kind_id).
          order(Sequel.desc(:id)).
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

      app.post "/titles" do
        title = Title.new
        title.set_fields JSON.parse(request.body.read), Title::PERMITTED_PARAMS

        if title.valid? && title.save
          hash = {
            id: title.id,
            title: title.title,
            production_year: title.production_year,
            kind: title.kind_type.values
          }

          json hash
        else
          status 422
          json title.errors
        end
      end

      app.put "/titles/:id" do
        title = Title[params[:id]]

        halt 404 unless title

        title.set_fields JSON.parse(request.body.read), Title::PERMITTED_PARAMS

        if title.valid? && title.save
          hash = {
            id: title.id,
            title: title.title,
            production_year: title.production_year,
            kind: title.kind_type.values
          }

          json hash
        else
          status 422
          json title.errors
        end
      end
    end
  end
end
