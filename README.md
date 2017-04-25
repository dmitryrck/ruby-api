# Ruby APIs

Sample APIs written in Ruby on Rails and Sinatra using IMDB database.

## Database

This project uses [IMDB database](http://www.imdb.com/interfaces). It does not
import from list files.

To import IMDB database we recommend [IMDbPy](http://imdbpy.sourceforge.net/).

*Warning*: This software and the authors have no rights to give you any
permission to use IMDB data.

## Usage

In order not to change the schema of the database the auth is managed by the
table `name` using just `md5sum` to match a user.

This way if you are importing the list files from IMDB you already have 6064219
users.

Get your user, for example:

    postgres@pgsrv:/$ psql imdb
    psql (9.6.2)
    Type "help" for help.

    imdb=# select id,md5sum from name limit 1;
     id  |              md5sum
    -----+----------------------------------
     719 | cf45e7b42fbc800c61462988ad1156d2
    (1 row)

    imdb=#

And the next requests:

    %  curl -i -H "Authorization: Token token:cf45e7b42fbc800c61462988ad1156d2" "http://localhost:3000/titles?page=100"
    HTTP/1.1 200 OK
    Connection: keep-alive
    X-Powered-By: Kemal
    Content-Type: text/html
    Content-Length: 839

    [{"id":4218231,"title":"Tony Robinson and...","kind":{"name":"tv series","id":2}},{"id":4218230,"title":"Wonders of the Universe","kind":{"name":"tv series","id":2}},{"id":4218229,"title":"(1955-11-01)","kind":{"name":"episode","id":7}},{"id":4218228,"title":"(1954-11-01)","kind":{"name":"episode","id":7}},{"id":4218227,"title":"Yagyu bugeicho - Ninjitsu","kind":{"name":"movie","id":1}},{"id":4218226,"title":"Why Dunblane?","kind":{"name":"episode","id":7}},{"id":4218225,"title":"The Siege of Kontum","kind":{"name":"episode","id":7}},{"id":4218224,"title":"The Quiet Mutiny","kind":{"name":"episode","id":7}},{"id":4218223,"title":"The Man Who Stole Uganda","kind":{"name":"episode","id":7}},{"id":4218222,"title":"The Life and Death of Steve Biko","kind":{"name":"episode","id":7}}]

If you don't provide your token:

    %  curl -i "http://localhost:3000/titles?page=100"
    HTTP/1.1 403 Forbidden
    Connection: keep-alive
    X-Powered-By: Kemal
    Content-Type: text/html
    Content-Length: 35

    {"error":403,"message":"Forbidden"}

`POST create`:

    curl -i --data '{"title":"Ghost","kind_id":1,"production_year":2007}' -H "Content-Type: application/json" -H "Authorization: Token token:cf45e7b42fbc800c61462988ad1156d2" "http://localhost:3000/titles"
    HTTP/1.1 200 OK
    Connection: keep-alive
    X-Powered-By: Kemal
    Content-Type: application/json
    Content-Length: 60

    {"title":"Ghost","kind_id":1,"production_year":2007,"id":93}


## List of endpoints

* `GET /current_user`;
* `GET /titles`, params: `page` (optional);
* `POST /titles`, content type: "application/json, params: `title` (required),
`kind_id` (required), `production_year` (required);
* `PUT /titles/:id`, content type: "application/json, params: `id` (required),
`title` (required), `kind_id` (required), `production_year` (required);

## Development (with docker)

1. [Install docker and docker-compose](https://blog.codeminer42.com/how-to-install-docker-and-docker-compose-8b0ec5ef2ec3).
2. Build and pull dependencies using docker-compose

    % docker-compose pull && docker-compose build

3. Install Ruby dependencies

    % docker-compose run --rm rails-web bundle install

### Ruby on Rails

Setup your database:

    % docker-compose run --rm rails-web bundle exec rake db:setup

Start your app:

    % docker-compose start rails-web

### Sinatra

You need IMDB database imported to run it (or you can use the same database of
Rails version).

Start your app:

    % docker-compose start sinatra-web

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [dmitryrck](https://github.com/dmitryrck) Dmitry Rocha - creator, maintainer
