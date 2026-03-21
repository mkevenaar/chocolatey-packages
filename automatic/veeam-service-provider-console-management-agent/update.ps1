Import-Module Chocolatey-AU

#Virtual package uses dependency updater to get the version
. $PSScriptRoot\..\veeam-service-provider-console-iso\update.ps1

function global:au_SearchReplace {
  @{
    "$($Latest.PackageName).nuspec" = @{
      "(^.+version=`")(\[.*\])(`".+$)"                   = "`$1[$($Latest.Version)]`$3"
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]filename\s*=\s*)([`"'].*[`"'])"              = "`$1'$($Latest.Filename)'"
    }
  }
}

# Left empty intentionally to override BeforeUpdate
function global:au_BeforeUpdate { }

update -ChecksumFor none
