source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.8', '>= 5.2.8.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby


# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

gem 'faker'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'chroma', '~> 0.2.0'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Use rubocop to enforce code style
  gem 'rubocop', '~> 1.64', '>= 1.64.1', require: false
  gem 'rubocop-performance', '~> 1.21', '>= 1.21.1', require: false
  gem 'rubocop-rails', '~> 2.25', require: false
  gem 'rubocop-rspec', '~> 3.0', '>= 3.0.1', require: false
  gem 'rubocop-rspec_rails', '~> 2.30', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.12'
  gem 'capybara-select-2', '~> 0.4.2'
  gem 'selenium-webdriver', '~> 3.141'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper', '~> 2.1'
  gem 'simplecov', require: false

  # API
  gem 'webmock', '~> 3.5', '>= 3.5.1'
  gem 'vcr', '~> 4.0'

  # Database
  # gem 'database_cleaner', '~> 1.7'
  gem 'rspec_junit_formatter', '~> 0.4.1'
end

gem 'mimemagic', github: 'mimemagicrb/mimemagic'

gem 'attr_json', '~> 0.6.0'
gem 'cancancan', '~> 2.3'
gem 'devise', '~> 4.9', '>= 4.9.0'
gem 'easy_table', '~> 0.0.10', git: 'https://github.com/LucasSousaR/easy_table'
gem 'flexirest', '~> 1.7', '>= 1.7.5'
gem 'haml', '~> 5.1', '>= 5.1.1'
gem 'kaminari', '~> 1.1', '>= 1.1.1'
gem 'net-http'
gem 'openssl'
gem 'paper_trail', '~> 10.3'
gem 'paranoia', '~> 2.4', '>= 2.4.1'
gem 'ransack', '~> 2.1'
gem 'rest-client', '>= 2.0.1'
gem 'sidekiq'
gem 'sidekiq-batch'
gem 'sidekiq-cron'
gem 'simple_form', '~> 4.1'
gem 'uri'
gem 'will_paginate', '~> 3.0.4'
gem 'render_async'
gem 'cpf_cnpj', '~> 0.5.0'
gem 'jquery-rails'
gem 'rails-ujs', '~> 0.1.0'
gem 'dotenv-rails', '~> 2.7', '>= 2.7.2', require: 'dotenv/rails-now'
gem 'bootstrap-filestyle-rails'
gem 'bootstrap-datepicker-rails'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'seed_dump'
gem "chartkick"
gem 'groupdate'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
