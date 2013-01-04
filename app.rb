require 'sinatra'
require 'uri'
require 'net/http'
require 'json'
require 'crack'

get '/' do

  @feed = params[:feed] if params

  if @feed
    return "Invalid Feed URL" if !valid_url?(@feed)

    content_type :json
    convert_feed(@feed)
  else
    erb :index
  end

end

def convert_feed(feed)
    xml = Net::HTTP.get_response(URI.parse(@feed)).body
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
