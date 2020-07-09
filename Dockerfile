FROM ruby:2.5.8

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV APP_HOME /reserve_space

RUN mkdir ${APP_HOME}}
WORKDIR ${APP_HOME}

COPY Gemfile ${APP_HOME}/Gemfile
COPY Gemfile.lock ${APP_HOME}/Gemfile.lock

RUN bundle install

COPY . ${APP_HOME}
