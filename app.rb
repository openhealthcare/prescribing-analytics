#!/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'Mail'

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

get '/wasteful' do
  erb :wasteful
end

get '/future' do
  erb :future
end

get '/about' do
  erb :about
end

get '/contact' do
  erb :contact
end

post '/contact' do
  @submitted = true
  @error = nil

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

