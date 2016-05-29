
function Get-PreviousPage($json){
#go to previous page
    if($Global:current_count -gt 0){
        $Global:current_count -= 25;
        $Global:after.pop;
    }
}