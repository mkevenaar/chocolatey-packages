@{
  Severity = @('Error', 'Warning')
  Rules = @{
    PSUseCompatibleCmdlets = @{
      Compatibility = @(
        'desktop-3.0-windows'
        'desktop-4.0-windows'
        'desktop-5.1.14393.206-windows'
      )
    }
    PSUseCompatibleSyntax = @{
      TargetedVersions = @(
        '5.1'
        '4.0'
        '3.0'
      )
    }
  }
  ExcludeRules = @('PSAvoidUsingWriteHost')
}
