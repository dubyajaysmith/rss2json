require 'sinatra'

get '/' do

  @feed = params[:feed] if params
  @count = params[:count] if params

  if @feed
    erb :output
  else
    erb :index
  end

end
