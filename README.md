# Decide

[![CircleCI](https://circleci.com/gh/exploradoresdemadrid/decide.svg?style=svg)](https://circleci.com/gh/exploradoresdemadrid/decide)

## Instructions for development

The recommended steps to setup the environment locally are described in this section.

### Installation

1. Install rvm following the instructions from the [RVM installation guide](https://rvm.io/rvm/install).
1. Install the ruby version specified in [.ruby-version](https://github.com/exploradoresdemadrid/decide/blob/master/.ruby-version) file. For example, `rvm install ruby-2.7.1`.
1. Install bundler gem: `gem install bundler`.
1. Install the dependencies of the project: `bundle install`.
1. Create your database with some sample data: `rake db:reset`. A Postgres server needs to be running so that Rails can connect to it.
1. Start your local server: `rails server`.
1. Navigate to http://localhost:3000/users/sign_in and sign in with the development accounts (local environment only) and the password `12345768`. Never create these accounts in a production environment.
    - `superadmin_edm@example.com`
    - `admin_edm@example.com`
    - `superadmin_sample@example.com`
    - `admin_sample@example.com`

### Testing

As part of the development process, you can (should) run the RSpec test suite locally to verify the application is working properly: `bundle exec rspec`. Writing end-to-end tests is also encouraged. To execute the Cypress test suite locally,

1. Follow the steps to install the application, described in the section above. Please, make sure the application is available at http://localhost:3000.
1. Install Javascript dependencies with `npm install`.
1. Run  `npm run cy:run`.

## Documentation

You can find some user-documentation in [its Github page](https://exploradoresdemadrid.github.io/decide/) (Spanish only!).
