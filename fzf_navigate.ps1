# For customizing fzf

# Write-Output "Hello"

if(-not(Get-Command fzf -ErrorAction SilentlyContinue)){
    Write-Error "fzf is not installed, install fzf first"
    exit 1
}
else{
    Write-Output "Allright good to go"
}




$selection = & {Get-ChildItem |
    ForEach-Object { $_.FullName } |
    & fzf --multi --height=80% --border=sharp `
        --preview='tree {}' `
        --preview-window='45%,border-sharp' `
        --prompt='Dirs > ' `
        --bind="del:execute()" `
        --bind='ctrl-p:toggle-preview' `
        --bind='ctrl-d:change-prompt(Dirs > )' `
        --bind='ctrl-d:+change-preview(tree {})' `
        --bind='ctrl-d:+refresh-preview' `
        --bind='ctrl-e:change-prompt(Files > )' `
        --bind='ctrl-e:+change-preview(powershell -Command cat {})' `
        --bind='ctrl-e:+refresh-preview' `
        --bind='ctrl-f:+change-preview(tree /f {})' `
        --bind='ctrl-f:+refresh-preview' `
        --bind='ctrl-a:select-all' `
        --bind='ctrl-x:deselect-all' `
        --header='
        CTRL-D : To display subfolders in preview window
        CTRL-F : To display all files in the folder
        CTRL-E : To display content of files
        CTRL-A : To select all
        CTRL-X : To deselect all 
        CTRL-P : To toggle preview 
        ENTER to edit | DEL to delete
        '
    }



# if directory then cd into it, if file then open using specified editor or by default vs code
# Container : eqivalent to -d in bash (directory) 
# Leaf : equivalent to -f in bash (file)

if ($selection) {
    $selectionArray = $selection.Split("`n")
    foreach ($path in $selectionArray) {
        if (Test-Path -Path $path) {
            if (Test-Path -Path $path -PathType Container) {
                Set-Location -Path $path
            }
            elseif (Test-Path -Path $path -PathType Leaf) {
                if ($env:EDITOR) {
                    & $env:EDITOR $path
                }
                else {
                    Write-Host "Opening $path with VS Code"
                    code $path
                }
            }
        }
    }
}