# For customizing fzf

# Write-Output "Hello"

if(-not(Get-Command fzf -ErrorAction SilentlyContinue)){
    Write-Error "fzf is not installed, install fzf first"
    exit 1
}
else{
    Write-Output "Allright good to go"
}




$selection = & {Get-ChildItem -Directory|
    ForEach-Object { $_.FullName } |
    & fzf --multi --height=80% --border=sharp `
        --preview='tree {}' `
        --preview-window='45%,border-sharp' `
        --prompt='Dirs > ' `
        --bind='del:execute(rm -ri {+})' `
        --bind='ctrl-p:toggle-preview' `
        --bind='ctrl-d:change-prompt(Dirs > )' `
        --bind='ctrl-d:+reload:{}' `
        --bind='ctrl-d:+change-preview(tree {})' `
        --bind='ctrl-d:+refresh-preview' `
        --bind='ctrl-f:change-prompt(Files > )' `
        --bind='ctrl-f:+reload:{}' `
        --bind='ctrl-f:+change-preview(cat {})' `
        --bind='ctrl-f:+refresh-preview' `
        --bind='ctrl-a:select-all' `
        --bind='ctrl-x:deselect-all' `
        --header='
        CTRL-D : To display all directories 
        CTRL-F : To display files 
        CTRL-A : To select all
        CTRL-X : To deselect all 
        CTRL-P : To toggle preview 
        ENTER to edit | DEL to delete
        '
    }



# if directory then cd into it, if file then open using specified editor or by default vs code
if (Test-Path -Path $selection -PathType Container){       
    Set-Location -Path $selection   
}
elseif ($env:EDITOR) {
    & $env:EDITOR $selection
}
else{
    Write-Host "No editor defined - Opening with the vs code"
    code $selection
}


# Container : eqivalent to -d in bash (directory) 
# Leaf : equivalent to -f in bash (file)



