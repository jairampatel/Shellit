function Get-LinkOrComment($param){
    $prompt = $param + " " + "([l]ink/[c]omment/[q]uit)";
    $confirmation = Read-Host $prompt
    while ($confirmation -ne 'l' -and $confirmation -ne 'c' -and $confirmation -ne 'q'){
        $confirmation = Read-Host $prompt;
    }
    return $confirmation;
}