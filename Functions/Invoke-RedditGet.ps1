function Invoke-RedditGet([string]$url){
    #performs GET request and returns result as a string
    
    Clear-Host;
    Invoke-WaitMessage;

    $client = New-Object System.Net.WebClient;
    $client.Headers.Add("user-agent", $Global:user_agent);
    $client.Headers.Add("Cookie","reddit_session=$Global:cookie");
    $string = $client.DownloadString($url);
    
    Clear-Host;
    return $string;
}