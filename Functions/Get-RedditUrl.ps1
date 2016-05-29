function Get-RedditURL(){
    #returns the url of reddit based on what page you're on and if you're logged in
    
    if ($SubReddit -ne ""){  
        $SubReddit  
        $url_string = "http://www.reddit.com/r/$SubReddit/.json"
    }
    else {
        $url_string = "http://www.reddit.com/.json"
    }

    if( ($Global:current_count -ne 0)){
        $url_string += "?";
    }
    $to_add = @();

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
