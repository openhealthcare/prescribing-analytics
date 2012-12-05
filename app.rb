#!/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'
require 'pony'
require 'json'
require 'erb'

unless %w[bosch rasputin].member? Socket.gethostname or ENV['SKIP_AUTH']
  use Rack::Auth::Basic do |username, password|
    if ENV['AUTH_USER']
      username == ENV['AUTH_USER'] && password == ENV['AUTH_PASSWORD']
    else
      username == 'ohc' && password == 'ohc'
    end
  end
end

if ENV['SENDGRID_USERNAME']
  set :static_cache_control, [:public, {:max_age => 300}]
  Pony.options = {
      :via => :smtp,
      :via_options => {
          :host => 'smtp.sendgrid.net',
          :port =>587,
          :user_name => ENV['SENDGRID_USERNAME'],
          :password => ENV['SENDGRID_PASSWORD'],
          :authentication => :plain,
          :domain => 'heroku.com',
        }
  }
else
  Pony.options = {
      :via => :smtp,
      :via_options => {
          :host => 'localhost',
          :port => 1025,
          :authentication => :plain,
          :domain => 'heroku.com',
        }
  }
end


get '/' do
  erb :index
end

get '/ccg' do
  erb :index
end

get '/pct' do
  erb :pct
end

# get '/practice' do
#   erb :practice
# end

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
  @errors = []
  @error = nil

  # Get post data and try and send a mail, if we fail we
  # should warn the user.  Make sure email address is validated
  # as an email address.
  if params[:name] == ""
    @errors << "Please specify your name."
  end

  if params[:email] == ""
    @errors << "Please specify your email"
  else
    if (params[:email] =~ /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i).nil?
      @errors << "That email address doesn't seem valid, please try again"
    end
  end

  if not params[:iam] or params[:iam] == ""
    @errors << "Please specify your role"
  end

  @name = params[:name]
  @email = params[:email]
  @iam = params[:iam]
  @comment = params[:comment]

  if @errors.length == 0
    begin
      Pony.mail :to => "info@prescribinganalytics.com",
              :from => "info@prescribinganalytics.com",
              :subject => "Prescribing Analytics Contact Form",
              :body => erb(:email, :layout=>false)
      @submitted = true
    rescue
      @submitted = false
      @error = "There was an error delivering your email, please email info@prescribinganalytics.com directly"
    end
  else
    @submitted = false
    @error = @errors.join("<br/>")
  end

  erb :contact
end

