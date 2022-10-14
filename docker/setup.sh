#!/bin/sh

docker-compose \
  -f docker/docker-compose.yaml \
  start db

docker-compose \
  -f docker/docker-compose.yaml \
  run --rm api \
    bundle install

docker-compose \
  -f docker/docker-compose.yaml \
  run --rm api \
    bundle exec rake db:migrate


## FIXME: esto es para corregir un problema con shotgun y ruby 3
docker-compose \
  -f docker/docker-compose.yaml \
  run --rm api \
    sed -i 's/run app, options/run app, **options/' /usr/src/gems/gems/shotgun-0.9.2/bin/shotgun

    # docker/patch-shotgun.sh /usr/src/gems/bin/shotgun
