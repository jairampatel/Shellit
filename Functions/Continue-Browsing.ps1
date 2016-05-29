function Continue-Browsing(){
    #asks user if they want to continue browsing reddit
    $input = Get-Confirmation "Continue browsing reddit?";
    if(($input -eq 'n') -or ($input -eq 'q')){
        Exit-Shellit;
    }
}
