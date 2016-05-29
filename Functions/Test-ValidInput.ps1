function Test-ValidInput($my_input, $json) {
    #checks if input is valid
    if( ( ((Test-NumericValue($my_input)) -eq $FALSE) -and (($Global:commands.ContainsKey([string]$my_input)) -eq $TRUE ) -and (([string]$my_input).Length -eq 1) ) -or 
        ( ( (Test-NumericValue($my_input)) -eq $TRUE ) -and (([string]$my_input).Length -ge 1 ) ) ) {
    #if the input is in the command hash and is not a number (q) or if it's a number, return true

        return $TRUE;
    }
    else{
        return $FALSE;
    }
}
