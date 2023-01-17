~\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe --init --shell pwsh --config ~\AppData\Local\Programs\oh-my-posh\themes\clean-detailed.omp.json | Invoke-Expression

Import-Module -Name Terminal-Icons
Import-Module posh-git

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows

$NOTES_NAME = "notes"
$NOTES_DIR = $HOME
$NOTES_PATH = "$NOTES_DIR\$NOTES_NAME"

# Functions
function pretty-ls($path) {
	Get-ChildItem $path | Format-Wide -Column 3
}

function la($path) {
	Get-ChildItem $path
}

function profile-path {
	Write-Output $PROFILE
}

function open-profile {
	vim $PROFILE
}

function note-dir-init {
	if (-not(Test-Path $NOTES_PATH)) {
		try {
			New-Item -Path $NOTES_DIR -Name $NOTES_NAME -ItemType "directory"
			Write-Host "$NOTES_DIR has been created."

			Set-Location $NOTES_PATH 
			git init
			Write-Host "$NOTES_PATH.git has been created."
		}
		catch {
			throw $_.Exception.Message
		}
	}
}

function note {
	$currentDayName = Get-Date -UFormat %A
	$currentDay = Get-Date -UFormat %d
	$currentMonth = (Get-Culture).DateTimeFormat.GetMonthName((Get-Date -UFormat %m))
	$currentMonthLower = ($currentMonth).ToLower()
	$currentYear = Get-Date -UFormat %Y

	$file = "$NOTES_PATH\$currentYear\$currentMonthLower\$currentDay.md"

	# check if the file exists already, if not, load template
	if (-not(Test-Path $file)) {
		try {
			$template = "# $currentDayName ($currentMonth $currentDay, $currentYear)`n`n## Morning`n`n- [ ]`n`n## Afternoon`n`n- [ ]`n`n## Notes`n`n"
			$template | Out-File -FilePath $file
			Write-Host "The file [$file] has been created."
		}
		catch {
			throw $_.Exception.Message
		}
	}

	vim $file
}

function notes {
	$currentMonth = Get-Date -UFormat %m
	$currentMonth = (Get-Culture).DateTimeFormat.GetMonthName($currentMonth).ToLower()
	$currentMonthLower = ($currentMonth).ToLower()
	$currentYear = Get-Date -UFormat %Y

	$target = "$currentYear\$currentMonthLower"
	
	Set-Location $NOTES_PATH
	if (-not(Test-Path "$target")) {
		try {
			New-Item -Name "$target" -ItemType "directory"
			Write-Host "$target has been created."
		}
		catch {
			throw $_.Exception.Message
		}
	}
	Set-Location "$target"
	
}

function notes-commit {
	$currentDayName = Get-Date -UFormat %A
	$currentMonth = Get-Date -UFormat %m
	$currentMonth = (Get-Culture).DateTimeFormat.GetMonthName($currentMonth).ToLower()
	$currentMonthLower = ($currentMonth).ToLower()
	$currentYear = Get-Date -UFormat %Y

	Set-Location $NOTES_PATH
	git add -A
	git commit -m "Note commit $currentDayName, $currentMonthLower $currentYear"
}

function note-summary {
	$currentMonth = Get-Date -UFormat %m
	$currentMonth = (Get-Culture).DateTimeFormat.GetMonthName($currentMonth).ToLower()
	$currentYear = Get-Date -UFormat %Y
	
	$summary = "summary-$currentMonth-$currentYear.md"

	Out-File -FilePath $summary

	Get-ChildItem -Exclude $summary  | Get-ChildItem -Filter *.md | 
	Foreach-Object -Process { Add-Content -Path $summary -Value (Get-Content $_) }

	# ConvertFrom-Markdown -Path $summary -OutputType PDF 

	Write-Host "|--> [$summary] has been created."
	# Write-Host "|--> [summary-$currentMonth-$currentYear.pdf] has been created."
	Write-Host "|--> Done."
}

# Aliases 
Set-Alias -Name ls -Value pretty-ls
Set-Alias -Name profile -Value open-profile
Set-Alias -Name nt -Value note
