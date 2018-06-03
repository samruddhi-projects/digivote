Application Demo:

1. Go to PlayStore/AppStore and install Salesforce app
2.	Open the app after installing and you'll see a login screen
3.	Enter Voter user credentials. (ID: sghadge@elections.com, pwd: election@123)
4.	The Voter will receive SMS containing verification code on the registered number. (Note: we have disabled OTP for judging)
5.	The voter will be prompted to enter his Aadhar ID and OTP for now. Enter aadhaar_id : "547039586626" and otp : "123456" 
	(In actual, if Aadhar APIs are available, he will be prompted to enter aadhar id and give his fingerprints)
6.	After identity verification, he will be taken to voting screen if 
	a. He has logged in within his voting slot
	b. He has not voted before
7. Voting screen will display all candidated with their respective parties. Each party will have their unique random 5 digit code.
8. Enter the code for the party you wish to vote for. While entering the code the characters will be masked for secrecy.
9. Click on Submit button. 
