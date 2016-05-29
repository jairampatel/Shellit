gci $PSScriptRoot\Functions -Filter "*.ps1" | ForEach-Object {. $_.FullName}

Export-ModuleMember -Function * -Variable *