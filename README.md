Shellit
=======

Reqirements
-----------

1. PowerShell 3.0

2. ExecutionPolicy that allows 3rd party scripts to run. If you don't, you run run the following as an administrator in your PowerShell window:

		Set-ExecutionPolicy RemoteSigned



Shellit is a Reddit client for PowerShell. 
Import the module then simply run shellit.ps1.
Not using any parameters will prompt you to login (optional) and display the front page, but if you wish to view a specific subreddit, run it with the -SubReddit parameter.

		./shellit.ps1
		./shellit.ps1 -SubReddit bestoflegaladvice 

History
-------

**Version 1.1.0**

Moved from monolith to module with functions

**Version 1.0.1**

Users can view comments from any post

**Version 1.0**

Users are able to:
* login (optional) to see links from their subreddit. 
* navigate to next/previous pages of reddit
* view comments of self-posts