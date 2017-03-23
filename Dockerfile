FROM ruby:2.3.1

RUN echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y --force-yes \
  build-essential \
  nodejs \
  imagemagick \
  ntpdate \
  npm \
  pandoc \
  default-jre \
  postgresql-client && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

RUN apt-get clean

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install --without development test --jobs 20 --retry 5

ADD . ./
