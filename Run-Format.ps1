$cwd = Get-Location
try {
    Set-Location $PSScriptRoot
    terraform fmt -recursive
}
finally {
    Set-Location $cwd
}