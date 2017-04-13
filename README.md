# My App

## Running

Setup:

    % docker-compose run --rm -u root web bash -c "mkdir -p /bundle/vendor && chown ruby /bundle/vendor"
    % docker-compose run --rm web bundle install
    % docker-compose run --rm web bundle exec rake db:setup

See `setup`.

Run:

    % docker-compose up web

And go to [localhost:3000](http://localhost:3000).
