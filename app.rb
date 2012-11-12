require 'bundler'
require 'sinatra'
require 'haml'
require 'twilio-rb'

Twilio::Config.setup \
  account_sid: ENV['ACacce7accff8f3b232da7f94d4b7c05ea'],
  auth_token:  ENV['d182a62755fd30ea218f969ad01d523d']

get '/' do
	haml :index
end

post '/voice' do
	Twilio::TwiML.build do |res|	
	  res.gather action: '/play', method: 'POST', numDigits: '1'	do |r|
		  r.say 'Welcome to Robins Emergency Bad Day Hotline.', voice: 'man'
		  r.say 'To cheer yourself up, listen to the following options.', voice: 'man'
		  r.say 'Press 1 to here Robin tell you how much he loves you.', voice: 'man'
		  r.say 'Press 2 to here an inspirational Pep Talk.', voice: 'man'
		  r.say 'Press 3 to here a joke.', voice: 'man'
		  r.say 'Or press 4 to here Robin do an impression of Lord Voldemort.', voice: 'man'		  
		  r.say 'Press 5 to leave a message for Robin.', voice: 'woman'
		  r.pause 5
		end
	end  
end

post '/play' do
	if params[:Digits == '1']
	  Twilio::TwiML.build { |r| r.play 'love.mp3' }
	else
		Twilio::TwiML.build { |r| r.say 'NO THIS IS BROKEN', voice: 'man' }
	end
end    	

get '/voice' do
	haml :voice
end	
