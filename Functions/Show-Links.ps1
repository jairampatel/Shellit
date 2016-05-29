function Show-Links($json){
    #shows the links for the current page of reddit you're on
    for($index = 0;$index -lt $json.data.children.length;$index++){
        Write-Host "[$($Global:current_count + $index)]" -ForegroundColor Cyan -NoNewline;
        Write-Host "$($json.data.children[$index].data.subreddit) - " -ForegroundColor Yellow -NoNewline;
        Write-Host "$($json.data.children[$index].data.title)";
    }
}