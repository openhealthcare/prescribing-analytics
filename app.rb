#!/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'mail'

use Rack::Auth::Basic do |username, password|
  if ENV['AUTH_USER']
    username == ENV['AUTH_USER'] && password == ENV['AUTH_PASSWORD']
  else
    username == 'ohc' && password == 'ohc'
  end
end

if ENV['SENDGRID_USERNAME']
  Mail.defaults do
    delivery_method :smtp, {
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => 'plain',
      :enable_starttls_auto => true
    }
  end
else
  Mail.defaults do
    delivery_method :smtp, {
      :address => 'localhost',
      :port => 1025,
      :domain => 'localhost',
      :authentication => 'plain',
    }
  end
end

before do
  content_type :html, 'charset' => 'utf-8'
end

get '/' do
  erb :index
end


get '/analysis' do
  erb :analysis
end

get '/primer' do
  erb :primer
end

get '/faq' do
  erb :faq
end

get '/methodology' do
  erb :methodology
end

get '/about' do
  erb :about
end

get '/contact' do
  erb :contact
end

get '/google1d295fe6d703418a.html' do
  erb :google1d295fe6d703418a, :layout => false
end

post '/contact' do
  @submitted = true
  @error = nil

  # Get post data and try and send a mail, if we fail we
  # should warn the user.  Make sure email address is validated
  # as an email address.

  mail = Mail.deliver do
      to "ross@servercode.co.uk"
      from "ross@servercode.co.uk"
      subject 'Prescribing Analytics contact'
      text_part do
          body ""
      end
  end

  erb :contact
end

