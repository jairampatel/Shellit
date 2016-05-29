$Global:user_agent = "Shellit - Reddit client for Powershell";
$Global:commands = @{"q" = "quit"; "number" = "article"; "n" = "next"; "p" = "previous"};
$Global:modhash = "";
$Global:cookie = "";
$Global:current_count = [int]0;
$Global:after = New-Object System.Collections.Stack;
$Global:domain = @("imgur.com","i.imgur.com","youtube.com");
$Global:extension = @("jpg","jpeg","gif","png");