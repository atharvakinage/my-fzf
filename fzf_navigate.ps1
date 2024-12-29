# For customizing fzf

# Write-Output "Hello"

if(-not(Get-Command fzf -ErrorAction SilentlyContinue)){
    Write-Error "fzf is not installed, install fzf first"
    exit 1
}
else{
    Write-Output "Allright good to go"
}




