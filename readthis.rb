=begin

===================================
ROBINS EMERGENCY BAD DAY HELPLINE!
===================================

So you've had a bad day? World got you down? No problem!

Give Robin a call, TOLL FREE, on +44 800 011 9544

Robin is guaranteed to cheer you up!!

http://infinite-peak-4683.herokuapp.com/



============
Technical!
============

This app is built on Ruby's Sinatra framework, on my own bootstrap for Sinatra.

It uses:

* Twilio-rb
* Sinatra
* Haml
* SASS
* Redis
* Pusher
* SoundCloud
* Em-Synchrony


Technically, the way it works is:

The user calls up, after having a bad day, and in need of cheering up.  They are then given a series of options to help make them feel better.

Whichever option they pick, plays the relative sound clip for their request.

Option 5 of the Twilio 'gather' is to leave Robin a voice message. (To say thanks for cheering me up!)

If option 5 is selected, Twilio records the voice clip, sends it via syncrony to Soundcloud, and pulls the hosted MP3 back to the main website to be displayed on the homepage.



================
INSPIRATIONS!
================
INSPIRED BY ROB SPECTRE'S - SOMEBODY PUT SOMETHING IN MY RING APP! THANKS ROB!

This app was inspired by <a href="https://github.com/RobSpectre" target="_blank">Rob Spectre's<a>  'Somebody put something in my Ring' App.
His original App was writted in Python, so here's an alternate idea, in Ruby. :)

=end