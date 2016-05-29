function Get-ShellitCommands(){
    #returns string of commands in the format of "command_string = command"
    
    $Global:commands_string = "| ";
    foreach ($h in $Global:commands.GetEnumerator()) {
        $Global:commands_string += $h.Name + " = " + $h.Value + " | ";
    }
    return "$Global:commands_string";
}