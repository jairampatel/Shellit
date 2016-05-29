Param
    (
    [Parameter(Mandatory=$False,Position=0)]
    [string]$SubReddit
    )

$global:SubReddit=$SubReddit

#Start program execution

$LoginResult = Get-Confirmation "Would you like to login to Reddit?";

if ($LoginResult -ieq 'y'){
    Login-RedditAccount;
}
elseif ($LoginResult -ieq 'q'){
    Exit-Shellit;
}

Process-ShellitCommands;