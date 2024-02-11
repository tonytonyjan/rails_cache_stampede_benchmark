FROM ruby:3.3.0-alpine3.19 as builder
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN apk add --no-cache musl-dev gcc make
RUN bundle

FROM ruby:3.3.0-alpine3.19
WORKDIR /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
RUN apk add --no-cache font-noto gnuplot
COPY . /app
