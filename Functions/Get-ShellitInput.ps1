function Get-ShellitInput($command_string, $data){
    #gets input from user
    $input = "";  
    $temp = 1;
    while($temp -le 1){
        $input = Read-Host $command_string;
        if(Test-ValidInput $input $data -eq $true){
            $temp++;
        }
    }
    return $input;
}