function Handle-ExternalLink($url){
    #handles external links (non-self posts)

    $html = Invoke-RedditGet($url);
    $text = ConvertFrom-HTML($html);

    Write-Host $text;

    Continue-Browsing;
}