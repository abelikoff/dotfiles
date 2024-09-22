# set prompt

function prompt {
    # Just prettify the prompt
    Write-Host -NoNewline -ForegroundColor Green "PS "
    $p = Split-Path -leaf -path (Get-Location)
    $dir = $(get-location).ProviderPath
    Write-Host -NoNewline -ForegroundColor Magenta $p
    Write-Host -NoNewline -ForegroundColor Yellow ""

    # You may use ANSI or direct ConEmuC call

    if ($env:ConEmuBaseDir -ne $null) {
        # Write-Host -NoNewline (([char]27) + "]9;9;`"" + $dir + "`"" + ([char]27) + "\")
        & ConEmuC.exe -StoreCWD "$dir"
    }

    return "> "
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
