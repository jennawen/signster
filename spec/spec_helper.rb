
require 'capybara/rspec'
require_relative '../app'
require 'shoulda-matchers'
require 'rack/test'

Capybara.app = Sinatra::Application

