# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'erb'

get '/memos' do
  @memos_hash = open_file
  erb :index
end

post '/memos' do
  json = open_file
  index = SecureRandom.uuid
  json[index] = {
    'title' => params['title'],
    'content' => params['content']
  }
  write_into_file(json)
  redirect to('/memos')
end

get '/memos/new' do
  erb :create_memo
end

get '/memos/:memo_id/edit' do
  json = open_file
  @title = json[params['memo_id']]['title']
  json[params['memo_id']]['content']
  @content = json[params['memo_id']]['content']
  erb :edit_memo
end

delete '/memos/:memo_id' do
  json = open_file
  json.delete(params['memo_id'])
  write_into_file(json)
  redirect to('/memos')
end

get '/memos/:memo_id' do
  json = open_file
  @title = json[params['memo_id']]['title']
  @content = json[params['memo_id']]['content']
  erb :show_memo
end

patch '/memos/:memo_id' do
  json = open_file
  json[params['memo_id']]['title'] = params['title']
  json[params['memo_id']]['content'] = params['content']
  write_into_file(json)
  redirect to('/memos')
end

not_found do
  "404 Not Found : #{env['sinatra.error'].message}"
end

def open_file
  File.open('./data.json', 'r') { |f| JSON.parse(f.read) }
end

def write_into_file(json)
  File.open('./data.json', 'w') { |f| JSON.dump(json, f) }
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
