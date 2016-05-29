function Handle-Link($data){
    #handle a link that the user chose
    
    if(Test-SelfLink $data.domain){
        Handle-InternalLink $data.url $data.selftext $data.title;
    }
    else{
        $response = Get-LinkOrComment "Do you want to view the link or the comments?";
        
        if($response -eq "c"){
            $comment_url = "http://www.reddit.com" + $data.permalink;
            Handle-InternalLink $comment_url $data.selftext $data.title;
        }
        elseif($response -eq "l"){
            Handle-ExternalLink $data.url ;
        }
        elseif($response -eq "q"){
            Exit-Shellit;
        }
    }          
}