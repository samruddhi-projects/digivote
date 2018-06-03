Presentation: https://docs.google.com/presentation/d/11pxmlV2bNFekYzZxSOSDR9xf0Fi-zL3UUg373YwQLaA/edit#slide=id.g3ba5371c67_8_5

Application Flow & Demo:

Web version: http://login.salesforce.com
1. Open the link
2. Enter Voter user credentials. 
	Username: sghadge@elections.com
	Password: election@123
4. The Voter will receive SMS containing verification code on the registered number. (Note: we have disabled OTP for judging)
	Click on Vote tab
5. The voter will be prompted to enter his Aadhar ID and OTP for now. 
	Enter aadhaar_id : "547039586626" and otp : "123456" 
	(Ideally, voter will be prompted to enter aadhar id and give his fingerprints)
6. After identity verification, he will be taken to voting screen if 
	a. He has logged in within his 20 mins voting slot (Note: we configured the time slot from 11 to 1pm for judging)	
	b. He has not voted before
7. Voting screen will display all candidated with their respective parties. Each party will have their unique random 5 digit code.
8. Enter the code for the party you wish to vote for. While entering the code the characters will be masked for secrecy.
9. Click on Submit button. 
If you login as the same voter again, you will not be allowed to vote.


App version:
1. Go to PlayStore/AppStore and install Salesforce app
2.	Open the app after installing and you'll see a login screen
3.	Enter Voter user credentials. 
	Username: sghadge@elections.com
	Password: election@123
4.	The Voter will receive SMS containing verification code on the registered number. (Note: we have disabled OTP for judging)
5.	The voter will be prompted to enter his Aadhar ID and OTP for now. Enter aadhaar_id : "547039586626" and otp : "123456" 
	(Ideally, voter will be prompted to enter aadhar id and give his fingerprints)
6.	After identity verification, he will be taken to voting screen if 
	a. He has logged in within his 20 mins voting slot (Note: we configured the time slot from 11 to 1pm for judging)	
	b. He has not voted before
7. Voting screen will display all candidated with their respective parties. Each party will have their unique random 5 digit code.
8. Enter the code for the party you wish to vote for. While entering the code the characters will be masked for secrecy.
9. Click on Submit button. 
If you login as the same voter again, you will not be allowed to vote.
