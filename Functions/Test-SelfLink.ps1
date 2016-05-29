function Test-SelfLink($domain){
#determines if url is a "self" link
    if($domain.contains("reddit.com") -or $domain.contains("self.")){
        return $true;
    }
    else{
        return $false;
    }
}
