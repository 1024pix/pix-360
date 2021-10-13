# PIX 360

# Installation

1. Copy sample.env

```shell
cp sample.env .env
```

2. Run docker-compose :
```shell
docker-compose up -d
```

3. Run pix 360 app :
```shell
docker compose run --rm --service-ports --name pix360 app
```

Inside Pix 360 container: 
4. Install gems and packages :
````shell
bundle install && yarn install
````

5. Prepare database :
````shell
rails db:reset && rails db:migrate
````

6. Run server : 
````shell
rails server -p $PORT -b 0.0.0.0
````

# Docker usage : 

- To run one container :

```shell
docker compose run --rm --service-ports --name pix360 app
```

- To run in multiple terminal windows:
```shell
docker exec -it pix360 /bin/bash
```

# Development 

- Run lint :

```shell
bundle exec rubocop -a
```