class VenmoController < ApplicationController
before_filter :authenticate_user!


VENMO_CLIENT_ID = '1376'
VENMO_CLIENT_SECRET = 'fgbben7cfRf8QeHxh9BesPFwdQnJL48u'
VENMO_BASE_URL = 'https://api.venmo.com/'
VENMO_DEFAULT_SCOPES  = [ 'access_profile', 'access_friends', 'access_feed', 'make_payments']

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
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    data = "code=#{code}&client_id=#{VENMO_CLIENT_ID}&client_secret=#{VENMO_CLIENT_SECRET}"
    resp = http.post(uri.path, data)
    jsonData = JSON.parse(resp.body)
    puts jsonData
    session[:token] = jsonData["access_token"]
    if current_user.venmo_id == nil
      current_user.venmo_id = jsonData["user"]["id"]
      current_user.username = jsonData["user"]["user-name"]
      current_user.phone = jsonData["user"]["phone"]
      current_user.picture = jsonData["user"]["picture"]
      current_user.balance = jsonData["user"]["balance"]
      current_user.save
    end
    redirect_to :controller => "pages", :action => "home"

  end
end