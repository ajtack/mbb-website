class MembersController < ApplicationController	
	before_filter :require_user, :except => [:index, :show]
	before_filter :check_credentials, :only => [:edit, :update]
	require_role 'Roster Adjustment', :only => [:new, :create, :destroy, :move_up, :move_down]
	
	# GET /members
	# GET /members.xml
	def index
		@members = Member.find(:all)

		respond_to do |format|
			format.html # index.html.erb
			format.xml	{ render :xml => @members }
		end
	end

	# GET /members/john_smith
	# GET /members/john_smith.xml
	def show
		@member = Member.find_by_path_component(params[:id])
	
	  unless @member.nil?
  		respond_to do |format|
  			format.html # show.html.erb
  			format.xml	{ render :xml => @member }
  		end
		else
		  flash[:error] = "The member page you bookmarked no longer exists."
		  redirect_to home_url
	  end
	end

	# GET /private/members/new
	# GET /private/members/new.xml
	def new
		@member = Member.new
		
		respond_to do |format|
			format.html # new.html.erb
			format.xml	{ render :xml => @member }
		end
	end
 
	# POST /private/members
	# POST /private/members.xml
	def create
		@member = Member.new(params[:member])
		success = @member && @member.save
		if success && @member.errors.empty?
			# Protects against session fixation attacks, causes request forgery
			# protection if visitor resubmits an earlier form using back
			# button. Uncomment if you understand the tradeoffs.
			# reset session
			flash[:notice] = "#{@member.name} has been added to the band!"
			
			respond_to do |format|
				format.html { redirect_to(private_roster_url) }
				format.xml	{ head :ok }
			end
		else
			flash[:error]	= "Could not create a new member account for #{@member.name}."
			render :action => 'new'
		end
	end
	
	# GET /private/members/john_smith/edit
	# GET /private/members/john_smith/edit.xml
	def edit
		@member = Member.find_by_path_component(params[:id])
		
		respond_to do |format|
			format.html # edit.html.erb
			format.js	  { render :partial => 'edit_form.html.erb', :member => @member }
		end
	end

	# PUT /private/members/john_smith
	# PUT /private/members/john_smith.xml
	def update
		@member = Member.find_by_path_component(params[:id])
	
		respond_to do |format|
			if @member.update_attributes(params[:member])
				flash[:notice] = 'Member was successfully updated.'
				format.html { redirect_to member_path(@member) }
				format.js   # update.js.rjs
			else
				format.html { render :action => "edit" }
				format.js   # update.js.rjs
			end
		end
	end
	
	# PUT /private/members/Quentin_Daniels/move_up (rjs)
	def move_up
		@member = Member.find_by_path_component(params[:id])
		old_position = @member.position
		@member.move_higher
		@position_changed = (old_position != @member.reload.position)
		render 'private/rosters/move_up'
	end
	
	# PUT /private/members/Quentin_Daniels/move_down (rjs)
	def move_down
		@member = Member.find_by_path_component(params[:id])
		old_position = @member.position
		@member.move_lower
		@position_changed = (old_position != @member.reload.position)
		render 'private/rosters/move_down'
	end
	
	private
		def check_credentials
			unless current_user.has_role?('Roster Adjustment') or params[:id] == current_user.to_pc
				flash[:error] = "You do not have permission to #{action_name} another member."
				redirect_to private_roster_path
				false
			else
				true
			end
		end
end
