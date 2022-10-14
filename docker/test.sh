#!/bin/sh

docker-compose \
  -f docker/docker-compose.yaml \
  run --rm api bundle exec rake test
