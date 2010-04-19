class AboutController < ApplicationController
	layout :render_without_layout_for_ajax
	
	private
		def render_without_layout_for_ajax
			if request.format.js?
				false
			else
				'application'
			end
		end
end
