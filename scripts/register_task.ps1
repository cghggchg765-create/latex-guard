# 注册 Windows 计划任务：每日自动同步 LaTeX Guard 到 GitHub
# 以管理员身份运行此脚本

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$syncScript = Join-Path $scriptDir "sync_and_push.ps1"

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"$syncScript`""
$trigger = New-ScheduledTaskTrigger -Daily -At "09:00"
Register-ScheduledTask -TaskName "LaTeX Guard Auto Sync" -Action $action -Trigger $trigger -Description "Daily auto sync LaTeX Guard skill to GitHub" -Force

Write-Host "[OK] 计划任务已注册：每日 09:00 自动同步" -ForegroundColor Green
