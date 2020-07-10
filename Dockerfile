FROM ruby:2.5.8

RUN apt-get update -qq  \
  && apt-get install -y \
  build-essential       \
  libpq-dev             \
  nodejs                \
  fonts-liberation      \
  libappindicator3-1    \
  libasound2            \
  libatk-bridge2.0-0    \
  libatspi2.0-0         \
  libgtk-3-0            \
  libnspr4              \
  libnss3               \
  libx11-xcb1           \
  libxss1               \
  libxtst6              \
  xdg-utils             \
  libgbm1
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb
RUN curl -O https://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip

ENV APP_HOME /reserve_space

RUN mkdir ${APP_HOME}}
WORKDIR ${APP_HOME}

COPY Gemfile ${APP_HOME}/Gemfile
COPY Gemfile.lock ${APP_HOME}/Gemfile.lock

RUN bundle install

COPY . ${APP_HOME}
