FROM ruby:2.7.1-alpine

RUN apk --no-cache add yarn nodejs build-base postgresql-dev

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN gem install bundler:2.1.2
COPY Gemfile Gemfile.lock $APP_HOME/
RUN bundle config set without 'development test' && bundle install

COPY package.json package-lock.json $APP_HOME/
RUN yarn install --check-files

COPY . $APP_HOME
CMD ["rails","server","-b","0.0.0.0"]