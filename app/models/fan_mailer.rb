class FanMailer < ActionMailer::Base
	def welcome(fan)
		recipients fan.email
		from       'Madison Brass Band <communications@madisonbrass.com>'
		subject    'Thanks for being a fan!'
		sent_on    Time.now
		body       ({:fan => fan})
	end
end
