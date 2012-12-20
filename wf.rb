# A simple WebFinger Server Example
# Start: ruby wf.rb
# The example SSL PEM password is 'test'...
# Send request to: https://localhost:8443/.well-known/webfinger?resource=acct:john@example.net

require 'webrick'
require 'webrick/https'
require 'openssl'
require 'sinatra'
require 'wfjrd'
require 'yaml'

@@user_db = YAML.load_file('data/data.yaml')

def get_user res
  @@user_db.each do |user| 
    return user if user.has_key? 'Aliases' and user['Aliases'].include? res
  end
  nil # return nothing if no match
end 

include WebFinger
def generate_jrd user, res, secure
  jrd { 
    pretty
    subject res
    expires now + 1.day
    user['Aliases'].each do |id|
      aka id
    end
    user['Links'].each do |item|
      link {
        rel item['rel'] if item['rel']
        href item['href'] if item['href']
        type item['type'] if item['type']
      } unless (!secure && item['secure'])
    end
    if user['Properties'] 
      properties {
        user['Properties'].each do |key,val|
          property key, val
        end
      }
    end
  }
end

##########################################
class MyServer < Sinatra::Base
  before do
    cache_control :public, :must_revalidate, :max_age => 60 * 60 * 24
    headers 'Access-Control-Allow-Origin' => '*'
  end

  get '/.well-known/webfinger' do
    res = params['resource']
    secure = request.secure?
    user = get_user res
    if user != nil
      headers 'Content-Type' => 'application/json'
      stream do |out|
        out << generate_jrd(user, res, secure)
      end
    else
      404 # Not Found!
    end
  end
end

#############################################
puts "PEM Password is 'test'"
CERT_PATH = '/Users/james/git/webfinger/ca'
webrick_options = {
  :Port               => 8443,
  :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
  :DocumentRoot       => "",
  :SSLEnable          => true,
  :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
  :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "server.crt")).read),
  :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "server.key")).read),
  :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ],
  :app                => MyServer
}
server = ::Rack::Handler::WEBrick
trap(:INT) do
    server.shutdown
end
server.run(MyServer, webrick_options)