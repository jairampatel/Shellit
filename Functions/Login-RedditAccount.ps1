function Login-RedditAccount(){
    #login to Reddit if you want to
    
    $user = Read-Host "Username";
    $pass = Read-Host -AsSecureString "Password";

    $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
    $params = "api_type=json&passwd=$plain&rem=true&user=$user";
    $post_url = "http://www.reddit.com/api/login";
    
    [string]$response = Invoke-WebRequest -Uri $post_url -Method Post -UserAgent $Global:user_agent -Body $params;
    
    if( $response.Contains("modhash") ){
        $json = ConvertFrom-Json $response;
        $Global:modhash = $json.json.data.modhash;
        $Global:cookie = $json.json.data.cookie;
    }
    elseif( $response.contains("WRONG_PASSWORD") ){
        Write-Host "Wrong username/password";
    }
    elseif( $response.contains("RATELIMIT")){
        $response -match "try again in (\d+) (\w+).";
        Write-Host "Please try logging in again after $($matches[1]) $($matches[2])";
    }
}
