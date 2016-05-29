function Parse-JSON([string]$string_to_parse){
    
    #converts json-formatted string into a parseable format
    $json = ConvertFrom-Json $string_to_parse;

    return $json;
}
