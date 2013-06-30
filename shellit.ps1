$Global:user_agent = "Shellit - Reddit client for Powershell";
$Global:commands = @{"q" = "quit"; "number" = "article"; "n" = "next"; "p" = "previous"};
$Global:modhash = "";
$Global:current_count = [int]0;
$Global:after = New-Object System.Collections.Stack;

#exits program
function exit_program(){
    Write-Host "Good bye";
    Exit;
}
#prompts user if they want to login
function get_confirmation($param){
    $prompt = $param + " " + "([y]es/[n]o/[q]uit)";
    $confirmation = Read-Host $prompt
    while ($confirmation -ne 'y' -and $confirmation -ne 'n' -and $confirmation -ne 'q'){
        $confirmation = Read-Host $prompt;
    }
    return $confirmation;
}
#login to Reddit if you want to
function login(){
    $user = Read-Host "Username";
    $pass = Read-Host -AsSecureString "Password";

    $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
    $params = "api_type=json&passwd=$plain&rem=true&user=$user";
    $post_url = "http://www.reddit.com/api/login";
    
    [string]$response = Invoke-WebRequest -Uri $post_url -Method Post -UserAgent $Global:user_agent -Body $params;

    if( $response.Contains("modhash") ){
        $json = ConvertFrom-Json $response;
        $Global:modhash = $json.json.data.modhash
    }
    elseif( $response.contains("WRONG_PASSWORD") ){
        Write-Host "Wrong username/password";
    }
    elseif( $response.contains("RATELIMIT")){
        $response -match "try again in (\d+) (\w+).";
        Write-Host "Please try logging in again after $($matches[1]) $($matches[2])";
    }
}

#returns string of commands in the format of "command_string = command"
function get_commands(){
    $Global:commands_string = "| ";
    foreach ($h in $Global:commands.GetEnumerator()) {
        $Global:commands_string += $h.Name + " = " + $h.Value + " | ";
    }
    return "$Global:commands_string";
}

#returns the url of reddit based on what page you're on and if you're logged in
function get_reddit_url(){
    $url_string = "http://www.reddit.com/.json";
    if( ($Global:modhashh -ne "") -or ($Global:current_count -ne 0)){
        $url_string += "?";
    }
    $to_add = @();
    if($Global:modhashh -ne ""){
        $to_add += "modhash=$Global:modhashh";
    }
    if($Global:current_count -ne 0){
        $to_add += "count=$Global:current_count";
        $to_add += "after=$($Global:after.Peek())";
    }
    for($x =0;$x -lt $to_add.Length;$x++){
        if($x -ne 0){
            $url_string += "&";
        }
        $url_string += $to_add[$x];
    }
    return $url_string;
}

#performs GET request and returns result as a string
function get_request([string]$url){

    show_wait;

    $client = New-Object System.Net.WebClient;
    $client.Headers.Add("user-agent", $Global:user_agent);

    $string = $client.DownloadString($url);

    Clear-Host;
    return $string;
}

#converts json-formatted string into a parseable format
function parse_json([string]$string_to_parse){
    $json = ConvertFrom-Json $string_to_parse;

    return $json;
}

#shows the links for the current page of reddit you're on
function show_links($json){
    $children = $json.data.children;

    for($index = 0;$index -lt $json.data.children.length;$index++){
        Write-Host "[$($Global:current_count + $index)]" -ForegroundColor Cyan -NoNewline;
        Write-Host "$($json.data.children[$index].data.subreddit) - " -ForegroundColor Yellow -NoNewline;
        Write-Host "$($json.data.children[$index].data.title)";
    }
}

#go to previous page
function go_previous($json){
    if($Global:current_count -gt 0){
        $Global:current_count -= 25;
        $Global:after.pop;
    }
}

#go to next page
function go_next($json){
    $Global:current_count += 25;
    $Global:after.push("$($json.data.after)");
}
#checks if input is a number
function isNumeric ($x) {
    try {
        0 + $x | Out-Null
        return $TRUE
    } catch {
        return $FALSE
    }
}

#checks if input is valid
function is_valid_input($my_input) {
    #if the input is in the command hash and is not a number (q) or if it's a number and is 0-24, return true
    if( ( ((isNumeric($my_input)) -eq $FALSE) -and (($Global:commands.ContainsKey([string]$my_input)) -eq $TRUE ) -and (([string]$my_input).Length -eq 1) ) -or 
        ( ( (isNumeric($my_input)) -eq $TRUE ) -and (([string]$my_input).Length -ge 1 ) ) ) {
        return $TRUE;
    }
    else{
        return $FALSE;
    }
}

#determines if url is a "self" link
function is_self($domain){
    if($domain.contains("reddit.com") -or $domain.contains("self.")){
        return $true;
    }
    else{
        return $false;
    }
}

#displays waiting message
function show_wait(){
    Write-Host "Please wait...";
}
#asks user if they want to continue browsing reddit
function continue_browsing(){
    $input = get_confirmation "Continue browsing reddit?";
    if(($input -eq 'n') -or ($input -eq 'q')){
        exit_program;
    }
    Clear-Host;   
}
#handles external links (non-self posts)
function handle_internal($url, $text, $title){
    $internal_json = parse_json(get_request($url + ".json"));
    
    Write-Host "Title: " -NoNewline -ForegroundColor Cyan;
    Write-Host "$title`n";

    Write-Host "Self text: " -NoNewline -ForegroundColor Cyan;
    Write-Host "$text`n";

    for($index = 0;$index -lt $internal_json[1].data.children.length; $index++){
        Write-Host "[$index]" -ForegroundColor Cyan -NoNewline
        Write-Host "$($internal_json[1].data.children[$index].data.body)";
    }
    
    continue_browsing; 
}
#handles external links (non-self posts)
function handle_external($url){

    $html = get_request($url);
    $text = Html-ToText($html);

    Write-Host $text;

    continue_browsing;
}
#handle a link that the user chose
function handle_link($data){
   
    if(is_self $data.domain){
        handle_internal $data.url $data.selftext $data.title;
    }
    else{
        handle_external $data.url ;
    }
}

#prompts user for command input
function process_commands(){
    $command_string = get_commands;
    $input = "";
    while(1 -le 1){
        
        $json = parse_json(get_request(get_reddit_url));
        show_links $json;

        #keep prompting for valid input
        $temp = 1;
        while($temp -le 1){
            $input = Read-Host $command_string;
            if(is_valid_input($input) -eq $true){
                $temp++;
            }
        }
        if($input -eq 'q'){
            exit_program;
        }
        
        
        if($input -eq 'n'){
            go_next $json;
        }
        elseif($input -eq 'p'){
            go_previous $json;
        }
        elseif(IsNumeric($input)){
            $index = [int]$input % 25;
            $data = $json.data.children[$index].data;              
            handle_link $data;
        }
    }
}

#converts html to text to display in console
function Html-ToText {
    param([System.String] $html)
    
    # remove line breaks, replace with spaces
    $html = $html -replace "(`r|`n|`t)", " "
    # write-verbose "removed line breaks: `n`n$html`n"
    
    # remove invisible content
    @('head', 'style', 'script', 'object', 'embed', 'applet', 'noframes', 'noscript', 'noembed') | % {
    $html = $html -replace "<$_[^>]*?>.*?</$_>", ""
    }
    # write-verbose "removed invisible blocks: `n`n$html`n"
    
    # Condense extra whitespace
    $html = $html -replace "( )+", " "
    # write-verbose "condensed whitespace: `n`n$html`n"
    
    # Add line breaks
    @('href','div','p','blockquote','h[1-9]') | % { $html = $html -replace "</?$_[^>]*?>.*?</$_>", ("`n" + '$0' )} 
    # Add line breaks for self-closing tags
    @('href','div','p','blockquote','h[1-9]','br') | % { $html = $html -replace "<$_[^>]*?/>", ('$0' + "`n")} 
    # write-verbose "added line breaks: `n`n$html`n"
    
    #strip tags 
    $html = $html -replace "<[^>]*?>", ""
    # write-verbose "removed tags: `n`n$html`n"
      
    # replace common entities
    @( 
    @("&amp;bull;", " * "),
    @("&amp;lsaquo;", "<"),
    @("&amp;rsaquo;", ">"),
    @("&amp;(rsquo|lsquo);", "'"),
    @("&amp;(quot|ldquo|rdquo);", '"'),
    @("&amp;trade;", "(tm)"),
    @("&amp;frasl;", "/"),
    @("&amp;(quot|#34|#034|#x22);", '"'),
    @('&amp;(amp|#38|#038|#x26);', "&amp;"),
    @("&amp;(lt|#60|#060|#x3c);", "<"),
    @("&amp;(gt|#62|#062|#x3e);", ">"),
    @('&amp;(copy|#169);', "(c)"),
    @("&amp;(reg|#174);", " "),
    @("&amp;nbsp;", " "),
    @("&nbsp;", " "),
    @("&#8217;", "'"),
    @("&#8230;", "..."),
    @("&#8220;", "`""),
    @("&#8221;", "`""),
    @("&bull;", " * "),
    @("&lsaquo;", "<"),
    @("&rsaquo;", ">"),
    @("&(rsquo|lsquo);", "'"),
    @("&(quot|ldquo|rdquo);", '"'),
    @("&trade;", "(tm)"),
    @("&frasl;", "/"),
    @("&(quot|#34|#034|#x22);", '"'),
    @('&(amp|#38|#038|#x26);', "&"),
    @("&(lt|#60|#060|#x3c);", "<"),
    @("&(gt|#62|#062|#x3e);", ">"),
    @('&(copy|#169);', "(c)"),
    @("&(reg|#174);", " "),
    @("  ", " "),
    @("`n`n", "`n"),
    @("&amp;(.{2,6});", "")
    ) | % { $html = $html -replace $_[0], $_[1] }

    @( 
    @("`n", "`n`n")
    ) | % { $html = $html -replace $_[0], $_[1] }
    # write-verbose "replaced entities: `n`n$html`n"
    
    return $html
    
}  

#Start program execution

$login_result = get_confirmation "Would you like to login to Reddit?";

if ($login_result -eq 'y'){
    login;
}
elseif ($login_result -eq 'q'){
    exit_program;
}
process_commands;