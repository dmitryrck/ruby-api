module SinatraApi
  module ApplicationHelper
    def auth(auth = nil)
      return unless auth

      token = auth.split(":")[-1]

      !query_user_by_token(token).empty?
    end

    private

    def query_user_by_token(token)
      SinatraApi.
        db[:name].
        select(:id, :name, :md5sum).
        where(md5sum: token).
        limit(1).
        all
    end
  end
end
