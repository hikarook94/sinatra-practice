# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'erb'
require 'pg'

CONN = PG.connect(dbname: 'memos')

get '/memos' do
  @memos_hash = db_select_all
  erb :index
end

post '/memos' do
  memo_id = SecureRandom.uuid.to_s
  sql = 'INSERT INTO memos VALUES ($1, $2, $3)'
  CONN.exec_params(sql, [memo_id, params['title'], params['content']])
  redirect to('/memos')
end

get '/memos/new' do
  erb :create_memo
end

get '/memos/:memo_id/edit' do
  @memo_hash = db_select(params['memo_id'])
  @title = @memo_hash[0]['title']
  @content = @memo_hash[0]['content']
  erb :edit_memo
end

delete '/memos/:memo_id' do
  sql = 'DELETE FROM memos WHERE memo_id = $1'
  CONN.exec_params(sql, [params['memo_id']])
  redirect to('/memos')
end

get '/memos/:memo_id' do
  @memo_hash = db_select(params['memo_id'])
  @title = @memo_hash[0]['title']
  @content = @memo_hash[0]['content']
  erb :show_memo
end

patch '/memos/:memo_id' do
  sql = 'UPDATE memos SET title = $1, content = $2 WHERE memo_id = $3'
  CONN.exec_params(sql, [params['title'], params['content'], params['memo_id']])
  redirect to('/memos')
end

not_found do
  "404 Not Found : #{env['sinatra.error'].message}"
end

def db_select(memo_id)
  sql = 'SELECT * FROM memos WHERE memo_id = $1'
  CONN.exec_params(sql, [memo_id])
end

def db_select_all
  sql = 'SELECT * FROM memos'
  CONN.exec_params(sql)
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
