function Test-NumericValue ($x) {
    #checks if input is a number
    try {
        0 + $x | Out-Null
        return $TRUE
    } catch {
        return $FALSE
    }
}
