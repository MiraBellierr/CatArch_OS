param(
  [Parameter(Mandatory = $true)]
  [ValidateRange(1, 42)]
  [int]$Day,
  [Parameter(Mandatory = $true)]
  [string]$Goal
)

$dayTag = ('{0:D2}' -f $Day)
$file = "docs/day-$dayTag-task.md"

@"
# Day $dayTag - $Goal

## Build Tasks
- TODO

## Contribution Tasks
- TODO

## Done Criteria
- TODO

## Evidence
- TODO (screenshots/logs/outputs)

## Risk and Rollback
- TODO
"@ | Set-Content -Path $file -Encoding utf8

Write-Output "Created $file"
