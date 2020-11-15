FROM ruby:2.7.2-slim

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
build-essential libpq-dev git-all default-libmysqlclient-dev

ENV INSTALL_PATH /iubank

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile ./

ENV BUNDLE_PATH /app-gems
# Copia nosso código para dentro do container
COPY . .

COPY ./start.sh /
RUN chmod +x /start.sh