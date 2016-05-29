function Handle-InternalLink($url, $text, $title){
    #handles external links (non-self posts)
    $internal_json = Parse-JSON(Invoke-RedditGet($url + ".json"));
    
    Write-Host "Title: " -NoNewline -ForegroundColor Cyan;
    Write-Host "$title`n";

    Write-Host "Self text: " -NoNewline -ForegroundColor Cyan;
    Write-Host "$text`n";

    for($index = 0;$index -lt $internal_json[1].data.children.length; $index++){
        Write-Host "[$index]" -ForegroundColor Cyan -NoNewline
        Write-Host "$($internal_json[1].data.children[$index].data.body)";
    }
    
    Continue-Browsing; 
}