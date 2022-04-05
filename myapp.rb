# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'erb'

get '/memos' do
  @hash = File.open('./data.json') { |f| JSON.parse(f.read) }
  erb :index
end

post '/memos' do
  json = File.open('./data.json', 'r') { |f| JSON.parse(f.read) }
  index = SecureRandom.uuid
  json[index] = {
    'title' => ERB::Util.html_escape(params['title']),
    'content' => ERB::Util.html_escape(params['content'])
  }
  File.open('./data.json', 'w') { |f| JSON.dump(json, f) }
  redirect to('/memos')
end

get '/memos/new' do
  erb :create_memo
end

get '/memos/:memo_id/edit' do
  json = File.open('./data.json', 'r') { |f| JSON.parse(f.read) }
  @title = json[params['memo_id']]['title']
  json[params['memo_id']]['content']
  @content = json[params['memo_id']]['content']
  erb :edit_memo
end

delete '/memos/:memo_id' do
  json = File.open('./data.json', 'r') { |f| JSON.parse(f.read) }
  json.delete(params['memo_id'])
  File.open('./data.json', 'w') { |f| JSON.dump(json, f) }
  redirect to('/memos')
end

get '/memos/:memo_id' do
  json = File.open('./data.json', 'r') { |f| JSON.parse(f.read) }
  @title = json[params['memo_id']]['title']
  @content = json[params['memo_id']]['content'].gsub(/\r\n/, '<br>')
  erb :show_memo
end

patch '/memos/:memo_id' do
  json = File.open('./data.json', 'r') { |f| JSON.parse(f.read) }
  json[params['memo_id']]['title'] = ERB::Util.html_escape(params['title'])
  json[params['memo_id']]['content'] = ERB::Util.html_escape(params['content'])
  File.open('./data.json', 'w') { |f| JSON.dump(json, f) }
  redirect to('/memos')
end

not_found do
  "404 Not Found : #{env['sinatra.error'].message}"
end
