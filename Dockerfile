FROM bitwalker/alpine-elixir:1.9.2

ENV REFRESHED_AT=2019-11-01
MAINTAINER Johannes Hellmut Troeger <jht@gehtalles.at>

RUN mkdir -p app/data

VOLUME ["/data"]
WORKDIR app

COPY . .
RUN mix do deps.get, escript.build

ENTRYPOINT ["/bin/sh", "-c", "./tupile -d /data"]
