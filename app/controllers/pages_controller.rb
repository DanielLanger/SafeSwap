class PagesController < ApplicationController

VENMO_CLIENT_ID = '1376'
VENMO_CLIENT_SECRET = 'fgbben7cfRf8QeHxh9BesPFwdQnJL48u'
VENMO_BASE_URL = 'https://api.venmo.com/'
VENMO_DEFAULT_SCOPES  = [ 'access_profile', 'access_friends', 'access_feed', 'make_payments']

  def index
    respond_to do |format|
      format.html
    end
  end
  
  def login
    if session['venmo_token']
      return 'Your Venmo token is %s' % session[:venmo_token]
    else
      redirect_to 'https://api.venmo.com/oauth/authorize?client_id=%s&scope=make_payments,access_profile&response_type=code' % VENMO_CLIENT_ID
    end
  end
  
  def oauth_authorized
    require "uri"
    require "net/http"
    require 'net/https'
    require 'json'
    code = params[:code]
    url = "https://api.venmo.com/oauth/access_token"
=begin
    access_token_exchange_url = "#{VENMO_BASE_URL}oauth/access_token"
    uri = URI.parse(access_token_exchange_url)
    response = Net::HTTP.post_form(uri, { "code" => code, "client_id" => "#{VENMO_CLIENT_ID}", "client_secret" => "#{VENMO_CLIENT_SECRET}"})
    
    body = response.body

    puts "res"
    puts JSON.load body
=end
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  data = "code=#{code}&client_id=#{VENMO_CLIENT_ID}&client_secret=#{VENMO_CLIENT_SECRET}"
  puts data
  resp = http.post(uri.path, data)
  puts resp.body

  end
  
  def home
    respond_to do |format|
      format.html
    end
  end
      
    
end
