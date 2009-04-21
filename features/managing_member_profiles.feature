Story: Managing Band-member Information
	As a band member, I want a way to edit my own profile, so that I can change my biography, picture, and contact information.
	As a board member or a webmaster, I want a way to edit any member's profile, to change the normal stuff plus his status (active, on leave, etc.) in the band.
	
	#
	# Changing personal information
	#
	
	Scenario: As a regular member, I log in and change my picture.
		Given an anonymous member
		  And a registered member named 'Reggie Funkle'
		  And we memorize Reggie Funkle's biography, email, and picture_created_at
		
		 When the anonymous member logs in with name: 'Reggie Funkle', and password: '1234reggie'
		 Then he should be redirected to Reggie Funkle's home page
		  And he should see a link labeled Edit
		
		 When he presses "Edit"
		 Then he should be taken to the edit members page
		  And he should see a <form> containing a file: Picture
		
		 When he attaches the file at "features/support/new_picture.jpg" to "picture"
		  And he presses "Save"
		 Then he should be redirected to Reggie Funkle's home page
		  And Reggie Funkle's picture_created_at should change
		  And Reggie Funkle's biography should not change
		  And Reggie Funkle's email should not change
		
	Scenario: As a regular member, I log in and change my e-mail address.
		Given an anonymous member
		  And a registered member named 'Reggie Funkle'
		  And we memorize Reggie Funkle's biography, email, and picture_created_at
		
		 When the anonymous member logs in with name: 'Reggie Funkle', and password: '1234reggie'
		 Then he should be redirected to Reggie Funkle's home page
		  And he should see a link labeled Edit
		
		 When he presses "Edit"
		 Then he should be taken to the edit members page
		  And he should see a <form> containing a textfield: E-Mail
		
		 When he fills in "email" with "new_email@somewhere.gov"
		  And he presses "Save"
		 Then he should be redirected to Reggie Funkle's home page
		  And Reggie Funkle's email should change
		  And Reggie Funkle's picture_created_at should not change
		  And Reggie Funkle's biography should not change
		
	Scenario: As a regular member, I log in and change my e-mail address.
		Given an anonymous member
		  And a registered member named 'Reggie Funkle'
		  And we memorize Reggie Funkle's biography, email, and picture_created_at

		 When the anonymous member logs in with name: 'Reggie Funkle', and password: '1234reggie'
		 Then he should be redirected to Reggie Funkle's home page
		  And he should see a link labeled Edit

		 When he presses "Edit"
		 Then he should be taken to the edit members page
		  And he should see a <form> containing a textfield: Biography

		 When he fills in "biography" with "I was a happy child once."
		  And he presses "Save"
		 Then he should be redirected to Reggie Funkle's home page
		  And Reggie Funkle's biography should change
		  And Reggie Funkle's email should not change
		  And Reggie Funkle's picture_created_at should not change
		