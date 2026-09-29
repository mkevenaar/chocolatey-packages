Import-Module Chocolatey-AU

# Virtual package uses the dependency updater to get the version.
. $PSScriptRoot\..\telegram.install\update.ps1

function global:au_SearchReplace {
   @{
        "$($Latest.PackageName).nuspec" = @{
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
        }
    }
}

# Left empty intentionally to override BeforeUpdate in telegram.install.
function global:au_BeforeUpdate { }

Update-Package -ChecksumFor none
