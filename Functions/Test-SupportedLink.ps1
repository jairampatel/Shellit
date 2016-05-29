function Test-SupportedLink($domain, $url){
    #checks if the url/domain contains images/videos
    if($Global:domain.Contains($domain) -or $Global:extension.Contains($url.Substring($url.LastIndexOf(".") + 1) ) ){
        return $false;
    }
    return $true;
}