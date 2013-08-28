TTwitterFeed
===================

Fetching Twitter Feed without having to login - X-Code Project
================================================================

Creating a Twitter Api Key - Authenticating using OAuth 

	1. Go to https://dev.twitter.com/apps/new and log in, if necessary
	2. Supply the necessary required fields, accept the TOS, and solve the CAPTCHA.
	3. Submit the form
	4. Copy the consumer key (API key) and consumer secret from the screen into your application

    If you also need the access token representing your own account’s relationship with the application:

	1. Ensure that your application is configured correctly with the permission level you need (read-only, read-write, read-write-with-direct messages).
	2. On the application’s detail page, invoke the “Your access token” feature to automatically negotiate the access token at the permission level you need.
	3. Copy the indicated access token and access token secret from the screen into your application

    Be sure and configure your application as needed before attempting the “your access token” step.


Setting Up X-Code Project

The Project fetches twitter feed without having to login. For this it uses the STTwitter Project on GitHub. Please refer to the project for more information on OAuth authentication.

	1. Download the X-Code project from GitHub
	2. Build the project. It will show few errors.
	3. Open the TTwitterApiKey.h file.
	4. Replace the Consumer key, Consumer Secret, OAuth Token, OAuth Token Secret, with the ones you generated.
	5. Build and run the project.