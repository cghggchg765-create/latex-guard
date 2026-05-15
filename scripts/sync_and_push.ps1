# LaTeX Guard Auto Sync Script
# 自动从 OpenCode skills 目录同步 SKILL.md 到 Git 仓库并推送
# 依赖: git, SSH key 已配置

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoPath = Resolve-Path "$scriptDir\.."
$skillSource = "$env:USERPROFILE\.agents\skills\latex-guard\SKILL.md"
$skillDest = Join-Path $repoPath "SKILL.md"

if (Test-Path $skillSource) {
    Copy-Item -Path $skillSource -Destination $skillDest -Force
    Write-Host "[OK] SKILL.md synced" -ForegroundColor Green
} else {
    Write-Host "[WARN] Source not found: $skillSource" -ForegroundColor Yellow
    Write-Host "[INFO] 请确认 OpenCode skills 目录存在该文件" -ForegroundColor Gray
    exit 1
}

Set-Location $repoPath
$status = git status --porcelain
if (-not $status) {
    Write-Host "[OK] No changes" -ForegroundColor Green
    exit 0
}

git add -A
$ts = Get-Date -Format "yyyy-MM-dd HH:mm"
git commit -m "auto: skill update - $ts"
git push origin main
Write-Host "[OK] Pushed to GitHub" -ForegroundColor Green
