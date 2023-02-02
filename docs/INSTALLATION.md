## Install

1. Set up environment
Copy sample.env
```shell
cp sample.env .env
```

Fill in Google SSO configuration
```shell
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
```

2. Start containers
```shell
docker-compose up --detach
```

3. Run application
```shell
docker-compose run --rm --service-ports --name pix360 app
```

4. Install gems and packages

This happens inside Pix 360 container, as in the prompt below
```shell
> root@f08b0677ddf7:/code#
```

Launch install (this will take a few minutes)
````shell
bundle install && yarn install
````

5. Set up database
````shell
rails db:reset && rails db:migrate
````

You get
```
Dropped database 'pix360'
Created database 'pix360'
```

6. Run server

In development mode
````shell
rails server --port $PORT --binding 0.0.0.0
````

In production mode
````shell
export SECRET_KEY_BASE=foo
export RAILS_LOG_TO_STDOUT=true
export RAILS_SERVE_STATIC_FILES=true
bundle exec rails assets:precompile
bundle exec rails server --port $PORT --binding 0.0.0.0 --environment production
````

7. Connect
Visit http://0.0.0.0:3000 in your browser.
You should get a connexion prompt.

Check your container logs, you should get
```postgres-sql

* Puma version: 5.6.4 (ruby 3.0.5-p211) ("Birdie's Version")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 1163
* Listening on http://0.0.0.0:3000
  Use Ctrl-C to stop
  Started GET "/" for 192.168.16.1 at 2023-02-01 16:38:46 +0000
  Cannot render console from 192.168.16.1! Allowed networks: 127.0.0.0/127.255.255.255, ::1
  ActiveRecord::SchemaMigration Pluck (2.6ms)  SELECT "schema_migrations"."version" FROM "schema_migrations" ORDER BY "schema_migrations"."version" ASC
  Started GET "/feedbacks" for 192.168.16.1 at 2023-02-01 16:38:46 +0000
  Cannot render console from 192.168.16.1! Allowed networks: 127.0.0.0/127.255.255.255, ::1
  Processing by FeedbacksController#index as HTML
  Completed 401 Unauthorized in 11ms (ActiveRecord: 0.0ms | Allocations: 3282)


Started GET "/users/sign_in" for 192.168.16.1 at 2023-02-01 16:38:46 +0000

```

## Docker usage :

- To run one container :

```shell
docker compose run --rm --service-ports --name pix360 app
```

- To run in multiple terminal windows:
```shell
docker exec -it pix360 /bin/bash
```

## Development

- Run lint :

```shell
bundle exec rubocop -a
```
