$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File F:\deskop\latex-guard\scripts\sync_and_push.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "09:00"
Register-ScheduledTask -TaskName "LaTeX Guard Auto Sync" -Action $action -Trigger $trigger -Description "Daily auto sync LaTeX Guard skill to GitHub"
