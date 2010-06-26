ActionController::Routing::Routes.draw do |map|
	map.resources :attached_files

	# Main site links
	map.with_options :controller => 'about' do |about|
		about.about 'about', :action => 'index'
		about.overview 'about/overview.:format', :action => 'overview'
		about.director 'about/director.:format', :action => 'director'
		about.history 'about/history.:format', :action => 'history'
		about.bylaws 'about/rules-and-bylaws.:format', :action => 'rules-and-bylaws'
		about.contacts 'about/contacts.:format', :action => 'contacts'
		about.what_is_a_brass_band 'about/brass-banding.:format', :action => 'brass-banding'
	end
	map.resources :news_items, :as => 'news', :only => [:index]
	map.book 'book', :controller => 'book'
	map.join 'join', :controller => 'join'
	map.resources :concerts, :only => [:index, :new, :create], :collection => {:next => :get, :past => :get, :upcoming => :get}
	map.resources :members, :member => {:move_up => :put, :move_down => :put} do |member|
		member.resource :privileges, :only => [:show], :controller => 'private/privileges'
		member.resource :section, :only => [:update]
	end
	map.resources :fans, :only => [:new, :create, :destroy]
	map.home 'home', :controller => 'home'
	map.root :home
	
	# Authentication
	map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
	map.login '/login', :controller => 'user_sessions', :action => 'new'
	map.resource :user_session
	
	# Private for Members, only accessible with a Username/Password
	map.namespace :private do |private|
		private.with_options(:layout => 'private') do |private|
			private.resource :roster, :only => [:show]
			private.resource :privileges, :only => [:edit]
			private.resources :news_items do |news_item|
				news_item.resources :attached_files, :only => [:new, :create, :destroy]
			end
		end
	end
end
