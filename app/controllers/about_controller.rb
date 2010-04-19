class AboutController < ApplicationController
	layout :render_without_layout_for_ajax
	before_filter :render_tabs
	
	def index
	end
	
	private
		def is_ajax_request?
			# This controller assumes that all content of the .js format is from an AJAX
			# request for loading tabs.
			request.format.js?
		end
		
		def render_tabs
			unless is_ajax_request?
				@Tabs = [
					{:path => overview_path, :title => 'Overview'},
					{:path => history_path, :title => 'History of MBB'},
					{:path => what_is_a_brass_band_path, :title => 'What is a Brass Band?'},
					{:path => director_path, :title => 'Our Musical Director'},
					{:path => bylaws_path, :title => 'Rules and Bylaws'},
					{:path => contacts_path, :title => 'Contacts'}
				]
				
				render 'tabs'
			end
		end
		
		def render_without_layout_for_ajax
			if is_ajax_request?
				false
			else
				'application'
			end
		end
end
