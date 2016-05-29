function Process-ShellitCommands(){
    #prompts user for command input
    $command_string = Get-ShellitCommands;
    $input = "";
    while(1 -le 1){
        
        $json = Parse-JSON(Invoke-RedditGet(Get-RedditURL));
        Show-Links $json;

        #keep prompting for valid input
        $input = Get-ShellitInput $command_string $json;
        
        if($input -eq 'q'){
            Exit-Shellit;
        }
        if($input -eq 'n'){
            Get-NextPage $json;
        }
        elseif($input -eq 'p'){
            Get-PreviousPage $json;
        }
        elseif(Test-NumericValue($input)){
            $index = [int]$input % 25;
            $data = $json.data.children[$index].data;              
            Handle-Link $data;
        }
    }
}