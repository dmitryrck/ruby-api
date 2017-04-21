module SinatraApi
  module NameApp
    def self.registered(app)
      app.get "/names" do
        page = params.fetch("page", 1).to_i

        names = Name.
          select(:id, :name, :md5sum).
          extension(:pagination).paginate(page, 10).
          all.map do |name|
            {
              id: name.id,
              name: name.name,
              md5sum: name.md5sum,
            }
          end

        json names
      end
    end
  end
end
