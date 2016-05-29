
function Get-NextPage($json){
    #go to next page
    $Global:current_count += 25;
    $Global:after.push("$($json.data.after)");
}