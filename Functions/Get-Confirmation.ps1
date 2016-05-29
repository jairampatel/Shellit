function Get-Confirmation($param){
    
    #prompts user if they want to login 

    $prompt = $param + " " + "([y]es/[n]o/[q]uit)";
    $confirmation = Read-Host $prompt
    while ($confirmation -ne 'y' -and $confirmation -ne 'n' -and $confirmation -ne 'q'){
        $confirmation = Read-Host $prompt;
    }
    return $confirmation;
}