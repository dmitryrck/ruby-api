module SinatraApi
  module NameApp
    def self.registered(app)
      app.get "/names" do
        page = params.fetch("page", 1).to_i

        names = Name.
          select(:id, :name, :md5sum).
          extension(:pagination).paginate(page, 10).
          order(Sequel.desc(:id)).
          all.map do |name|
            {
              id: name.id,
              name: name.name,
              md5sum: name.md5sum,
            }
          end

        json names
      end

      app.post "/names" do
        name = Name.new
        name.set_fields JSON.parse(request.body.read), Name::PERMITTED_PARAMS

        if name.valid? && name.save
          hash = {
            id: name.id,
            name: name.name,
            md5sum: name.md5sum,
          }

          json hash
        else
          status 422
          json name.errors
        end
      end

      app.put "/names/:id" do
        name = Name[params[:id]]

        halt 404 unless name

        name.set_fields JSON.parse(request.body.read), Name::PERMITTED_PARAMS

        if name.valid? && name.save
          hash = {
            id: name.id,
            name: name.name,
            md5sum: name.md5sum,
          }

          json hash
        else
          status 422
          json name.errors
        end
      end
    end
  end
end
