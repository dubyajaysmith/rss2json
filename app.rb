require 'sinatra'
require 'uri'
require 'net/http'
require 'json'
require 'crack'

get '/' do

  @feed = params[:feed] if params
  @callback = params[:callback] if params

  if @feed
    return "Invalid Feed URL" if !valid_url?(@feed)

    json = convert_feed(@feed)
    headers 'Access-Control-Allow-Origin' => '*'
    content_type :json
    response = (@callback) ? "#{@callback}(#{json})" : json
  else
    send_file File.expand_path('index.html', settings.public_folder)
  end

end

def convert_feed(feed)
    xml = Net::HTTP.get_response(URI.parse(feed)).body
    Crack::XML.parse(xml).to_json
end

def valid_url?(feed)
  url = URI.parse(feed)
  %w( http https ).include?(url.scheme)
rescue URI::BadURIError
  false
rescue URI::InvalidURIError
  false
end