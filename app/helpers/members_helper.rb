module MembersHelper
	
	#
	# Use this to wrap view elements that the user can't access.
	# !! Note: this is an *interface*, not *security* feature !!
	# You need to do all access control at the controller level.
	#
	# Example:
	# <%= if_authorized?(:index,	 User)	do link_to('List all users', users_path) end %> |
	# <%= if_authorized?(:edit,		@user) do link_to('Edit this user', edit_user_path) end %> |
	# <%= if_authorized?(:destroy, @user) do link_to 'Destroy', @user, :confirm => 'Are you sure?', :method => :delete end %> 
	#
	#
	def if_authorized?(action, resource, &block)
		if authorized?(action, resource)
			yield action, resource
		end
	end

	#
	# Link to user's page ('members/1')
	#
	# By default, their login is used as link text and link title (tooltip)
	#
	# Takes options
	# * :content_text => 'Content text in place of member.login', escaped with
	#	 the standard h() function.
	# * :content_method => :member_instance_method_to_call_for_content_text
	# * :title_method => :member_instance_method_to_call_for_title_attribute
	# * as well as link_to()'s standard options
	#
	# Examples:
	#	 link_to_member @member
	#	 # => <a href="/members/3" title="barmy">barmy</a>
	#
	#	 # if you've added a .name attribute:
	#	content_tag :span, :class => :vcard do
	#		(link_to_member member, :class => 'fn n', :title_method => :login, :content_method => :name) +
	#					': ' + (content_tag :span, member.email, :class => 'email')
	#	 end
	#	 # => <span class="vcard"><a href="/members/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
	#
	#	 link_to_member @member, :content_text => 'Your user page'
	#	 # => <a href="/members/3" title="barmy" class="nickname">Your user page</a>
	#
	def link_to_member(member, options={})
		raise "Invalid member" unless member
		options.reverse_merge! :content_method => :name, :title_method => :name, :class => :nickname
		content_text			= options.delete(:content_text)
		content_method = options.delete(:content_method)
		content_text		||= member.send(content_method) unless content_method.nil?
		options[:title] ||= member.send(options.delete(:title_method))
		link_to h(content_text), private_member_path(member), options
	end

	#
	# Link to login page using remote ip address as link content
	#
	# The :title (and thus, tooltip) is set to the IP address 
	#
	# Examples:
	#	 link_to_login_with_IP
	#	 # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
	#
	#	 link_to_login_with_IP :content_text => 'not signed in'
	#	 # => <a href="/login" title="169.69.69.69">not signed in</a>
	#
	def link_to_login_with_IP content_text=nil, options={}
		ip_addr					 = request.remote_ip
		content_text		||= ip_addr
		options.reverse_merge! :title => ip_addr
		if tag = options.delete(:tag)
			content_tag tag, h(content_text), options
		else
			link_to h(content_text), login_path, options
		end
	end

	#
	# Link to the current user's page (using link_to_member) or to the login page
	# (using link_to_login_with_IP).
	#
	def link_to_current_member(options={})
		if current_member
			link_to_member current_member, options
		else
			content_text = options.delete(:content_text) || 'not signed in'
			# kill ignored options from link_to_member
			[:content_method, :title_method].each{|opt| options.delete(opt)} 
			link_to_login_with_IP content_text, options
		end
	end

end