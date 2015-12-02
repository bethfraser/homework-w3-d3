require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'pry-byebug'
require 'pg'

get '/tasks' do
  sql = "SELECT * FROM tasks;"
  @tasks_all = run_sql(sql)
  erb :index
end

get '/tasks/new' do
  erb :new
end

post '/tasks' do
  name = params[:name]
  details = params[:details]
  sql = "INSERT INTO tasks (name, details) VALUES ('#{name}', '#{details}');"
  run_sql(sql)
  redirect to('/tasks')
end

get '/tasks/:id' do
  sql = "SELECT * FROM tasks WHERE id = #{params['id']};"
  @task_chosen = run_sql(sql)
# binding.pry
erb :show
end

get '/tasks/:id/edit' do
 erb :edit
end

post '/tasks/:id' do
  name = params[:new_name]
  details = params[:new_details]
  id = params[:id].to_i

  sql = "UPDATE tasks SET name = '#{name}', details = '#{details}' WHERE id = #{id};"
  run_sql(sql)
  redirect to('/tasks')
end

get '/tasks/:id/delete' do
  erb :destroy
end

post '/tasks/:id/delete' do
  if params[:delete] == "yes"
    id = params[:id].to_i
    sql = "DELETE FROM tasks WHERE id = #{id};"
    run_sql(sql)
  end
  redirect to('/tasks')
end

def run_sql(sql_string)
  conn = PG.connect(dbname: 'todo', host: 'localhost')
  result = conn.exec(sql_string)
  conn.close
  return result
end
