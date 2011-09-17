source 'http://rubygems.org'

gem 'rails', '3.0.9'

gem 'pg'
gem 'twitter_oauth',     '~> 0.4.3'
gem 'authorization-san', '~> 2.0.1', :require => 'authorization'
gem 'peiji-san',         '~> 1.0.0', :require => 'peiji_san'

# These are the versions recommended by Heroku
gem 'thinking-sphinx',   :git => 'git://github.com/freelancing-god/thinking-sphinx.git', :branch => 'rails3'
gem 'flying-sphinx',     :git => 'git://github.com/flying-sphinx/flying-sphinx.git'

gem 'newrelic_rpm'

gem 'ri_cal' # for parsing iCal

group :production do
  gem 'thin'
end

group :test do
  gem 'test-spec',    :require => 'test/spec'
  gem 'on-test-spec', :require => 'test/spec/rails'
  gem 'mocha',        :require => 'mocha'
end
