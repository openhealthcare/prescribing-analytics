#!/usr/bin/env ruby
# encoding: utf-8

require 'sinatra'

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

get '/contact' do
  erb :contact
end

get '/about' do
  erb :about
end

