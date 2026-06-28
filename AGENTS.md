# Agent Instructions

## Chocolatey AU Packages

- Fix update logic in `update.ps1` or supporting scripts only.
- Do not manually edit AU-generated package output such as installer URLs, checksums, checksum types, release notes, or dependency-generated metadata.
- Never manually compute and write package checksums. Checksum updates must be produced by the AU script.
- Never commit any change to a `<version>` value in a `.nuspec` file.
- If an AU run changes a `.nuspec` version during validation, exclude/revert that change before committing and report that AU generated it.
- If the local AU run cannot complete because of missing Chocolatey extensions or environment-specific helpers, report the blocker instead of filling generated fields by hand.
- Before finishing AU package work, review `git diff` and confirm that no unintended `.nuspec` version changes or manual checksum changes are present.
- For package-specific commits, prefix the commit subject with the package id in parentheses, followed by a short summary. Example: `(intel-arc-graphics-driver) Fix AU update flow`.
