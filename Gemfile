source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use sqlite3 as the database for Active Record

#gem 'pg', '~> 0.18.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', '~> 0.10.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'
gem 'activeadmin', github: 'gregbell/active_admin'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  #gem 'sqlite3'
  gem 'pg', '0.18.4'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'roo', '~> 2.4.0'
gem 'certified', '~> 1.0'
gem 'devise', '~> 4.0', '>= 4.0.3'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'activerecord-import', '~> 0.4.0'
gem 'google_drive'
gem 'google-api-client', '0.9'
gem "iconv", "~> 1.0.3"
group :production do
  gem 'pg', '0.18.4'
end

gem 'figaro'
group :development do
    gem 'capistrano',         require: false
    gem 'capistrano-rvm',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
end
#gem 'net-ssh', '~> 2.7.0'
gem 'sshkit', github: 'capistrano/sshkit'
gem 'puma'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

gem 'capistrano-sidekiq' , group: :development
gem 'sidetiq', '~> 0.7.0'

#gem 'gdata_19', '1.1.5'