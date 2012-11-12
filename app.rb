require 'bundler'
require 'sinatra'
require 'haml'
require 'twilio-rb'
require 'sinatra/synchrony'
require 'em-synchrony/em-http'
require 'em-synchrony/em-hiredis'
require 'soundcloud'

Twilio::Config.setup \
  account_sid: ENV['ACacce7accff8f3b232da7f94d4b7c05ea'],
  auth_token:  ENV['d182a62755fd30ea218f969ad01d523d']

get '/' do
	haml :index
end

get '/messages' do
	@recordings = redis.lrange 'recordings', 0, 24
	haml :messages
end	

post '/voice' do
	Twilio::TwiML.build do |res|	
	  res.gather action: '/play', method: 'POST', numDigits: '1'	do |r|
		  r.say 'Welcome to Robins Emergency Bad Day Hotline.', voice: 'man'
		  r.say 'To cheer yourself up, listen to the following options.', voice: 'man'
		  r.say 'Press 1 to here Robin tell you how much he loves you.', voice: 'man'
		  r.say 'Press 2 to here an inspirational Pep Talk.', voice: 'man'
		  r.say 'Press 3 to here a joke.', voice: 'man'
		  r.say 'Or press 4 to here Robin do an impression of Lord Vol-de-mort.', voice: 'man'		  
		  r.say 'Press 5 to leave a message for Robin.', voice: 'woman'
		  r.pause 1
		end
	end  
end

post '/play' do
	if params[:Digits] == '1'
	  Twilio::TwiML.build do |s| 
	  	s.play 'http://rbin.co/sounds/love.mp3'
	  	s.say 'Thankyou. Goodbye.'
	  	s.pause 1
	  	s.hangup
	  end	
	elsif params[:Digits] == '2'
		Twilio::TwiML.build do |s| 
	  	s.play 'http://rbin.co/sounds/peptalk.mp3'
	  	s.say 'Thankyou. Goodbye.'
	  	s.pause 1
	  	s.hangup
	  end	
	elsif params[:Digits] == '3'
		Twilio::TwiML.build do |s| 
	  	s.play 'http://rbin.co/sounds/joke.mp3'
	  	s.say 'Thankyou. Goodbye.'
	  	s.pause 1
	  	s.hangup
	  end	
	elsif params[:Digits] == '4'
		Twilio::TwiML.build do |s| 
	  	s.play 'http://rbin.co/sounds/lordvoldemort.mp3'
	  	s.say 'Thankyou. Goodbye.'
	  	s.pause 1
	  	s.hangup
	  end	
	else
		Twilio::TwiML.build do |r|
	    r.say 'leave a message for Robin after the beep', voice: 'woman'
	    r.record action: '/record', max_length: 30
		end	
	end	
end

post '/record' do
  EM.next_tick do
    Fiber.new do
      if url = params['RecordingUrl']
      
        # Race condition in Twilio API #AWKWARD!
        EM::Synchrony.sleep(1)

        audio = EM::HttpRequest.new(url + ".mp3").get.response

        sound = soundcloud.post('/tracks', track: {
          title:      "Message from *******#{params['From'][-4,4]}",
          asset_data: Tempfile.new('recording').tap { |f| f.binmode; f.write audio; f.rewind }
        })

        redis.lpush 'recordings', sound[:uri]
        
        # Temp remove this. SoundCloud takes way too long to get files ready for a real-time element to be practical
        # Pusher['emergencyrobin'].trigger_async 'new_recording', uri: CGI.escape(sound[:uri])

        Twilio::SMS.create to: params['From'], from: params['To'],
          body: "Thanks for your message. Go to http://lovefromrob.in for a little bit of Love, from Robin x"

      end
    end.resume
  end

  Twilio::TwiML.build { |r| r.say 'thanks! goodbye', voice: 'woman' }
end

def soundcloud
  @soundcloud ||= Soundcloud.new \
    client_id:     ENV['17d03c7d6d25934e43f7e23765f717bd'],
    client_secret: ENV['cbb71ecaec6ac445150ec9c2d43e026f'],
    username:      ENV['Rbin'],
    password:      ENV['Hamm3r10']
end

def redis
   $redis ||= EM::Hiredis.connect ENV['REDISTOGO_URL']
end

