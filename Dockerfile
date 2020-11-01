FROM ruby:2.7.1

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential nodejs yarn

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