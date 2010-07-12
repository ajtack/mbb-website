require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConcertsController do
	it { should route(:get,  '/concerts/new'     ).to(:controller => :concerts, :action => :new              ) }
	it { should route(:post, '/concerts'         ).to(:controller => :concerts, :action => :create           ) }
	it { should route(:get,  '/concerts/past'    ).to(:controller => :concerts, :action => :past             ) }
	it { should route(:get,  '/concerts/next'    ).to(:controller => :concerts, :action => :next             ) }
	it { should route(:get,  '/concerts/upcoming').to(:controller => :concerts, :action => :upcoming         ) }
	it { should route(:get,  '/concerts/1/edit'  ).to(:controller => :concerts, :action => :edit,   :id => 1 ) }
	it { should route(:put,  '/concerts/1'       ).to(:controller => :concerts, :action => :update, :id => 1 ) }
	
	describe '#new' do
		context 'when NOT logged in' do
			before { logout }
			
			it 'should redirect to the login page' do
				get :new
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in as an unprivileged member' do
			before { login({}, {:privileged? => false}) }
			
			it 'should deny access' do
				get :new
				response.code.should == '403' # Forbidden
				response.should_not render_template('concerts/new')
			end
		end
		
		context 'when logged in as a privileged member' do
			before { login({}, {:privileged? => true}) }
			
			it 'should permit access' do
				get :new
				response.should be_success
				response.should render_template('concerts/new')
			end
		end
	end
	
	describe '#create' do
		context 'when NOT logged in' do
			before { logout }
			
			it 'should redirect to the login page' do
				post :create
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in as an unprivileged member' do
			before { login({}, {:privileged? => false}) }
			
			it 'should deny access' do
				post :create
				response.code.should == '403' # Forbidden
				response.should_not render_template('concerts/new')
			end
		end
		
		context 'when logged in as a privileged member' do
			before { login({}, {:privileged? => true}) }
			
			context 'and submitting valid data' do
				before do
					@the_concert = mock_model(Concert, :save => true)
					Concert.should_receive(:new).with('these' => :attributes).and_return(@the_concert)
				end
				
				it 'should redirect to the concerts list' do
					post :create, :concert => {:these => :attributes}
					response.should redirect_to(concerts_path)
				end
				
				it 'should note the posted concert in a notice' do
					post :create, :concert => {:these => :attributes}
					flash[:notice].should_not be_nil
				end
			end
			
			context 'but submitting invalid data' do
				before do
					@the_concert = mock_model(Concert, :save => false)
					Concert.should_receive(:new).with('these' => :attributes).and_return(@the_concert)
				end
				
				it 'should re-render the concert creation form' do
					post :create, :concert => {:these => :attributes}
					response.should render_template('concerts/new')
				end
			end
		end
	end
	
	describe '#edit' do
		context 'when not logged in' do
			before { logout }
			
			it 'should redirect to the login page' do
				get :edit, :id => :something
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in, but not privileged,' do
			before { login({}, {:privileged => false}) }
			
			it 'should deny access' do
				get :edit, :id => :something
				response.code.should == '403'  # Forbidden
			end
			
			it 'should not render the form' do
				get :edit, :id => :something
				response.should_not render_template('concerts/edit')
			end
		end
		
		context 'when logged in with privileges' do
			before do
				login({}, {:privileged => true})
				Concert.stub!(:find).and_return(mock_model(Concert))
			end
			
			it 'should be successful' do
				get :edit, :id => :something
				response.should be_success
			end
			
			it 'should render the edit template' do
				get :edit, :id => :something
				response.should render_template('concerts/edit')
			end
			
			it 'should choose the identified concert to edit' do
				Concert.should_receive(:find).with('something')
				get :edit, :id => 'something'
			end
		end
	end
	
	describe '#update' do
		context 'when not logged in' do
			before { logout }
			
			it 'should render the login page' do
				put :update, :id => :something
				response.should redirect_to(login_url)
			end
		end
		
		context 'when logged in, but unprivileged,' do
			before { login({}, {:privileged => false}) }
			
			it 'should render the news page' do
				put :update, :id => :something
				response.should render_template('/private/news_items/index')
			end
			
			it 'should forbid the changes' do
				put :update, :id => :something
				response.code.should == '403'  # Forbidden
			end
		end
		
		context 'when logged in with privileges' do
			before { login({}, {:privileged => true}) }
			
			context 'submitting valid changes' do
				before { Concert.stub!(:find).and_return(mock_model(Concert, :update_attributes => true, :title => 'something')) }
				
				it 'should return by redirecting to the upcoming concert schedule' do
					put :update, :id => :something
					response.should redirect_to(upcoming_concerts_url)
					response.code.should == '303'
				end
				
				it 'should retrieve the target concert' do
					Concert.should_receive(:find).with('something')
					put :update, :id => 'something'
				end
			end
			
			context 'submitting invalid changes' do
				before { Concert.stub!(:find).and_return(mock_model(Concert, :update_attributes => false)) }
				
				it 'should render the edit form again' do
					put :update, :id => :something
					response.should render_template('concerts/edit')
				end
				
				it 'should return "bad request"' do
					put :update, :id => :something
					response.code.should == '400'
				end
				
				it 'should retrieve the target concert' do
					Concert.should_receive(:find).with(:something)
					put :update, :id => :something
				end
			end
		end
	end
end
