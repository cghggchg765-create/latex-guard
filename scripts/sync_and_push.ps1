$repoPath = "F:\deskop\latex-guard"
$skillSource = "C:\Users\11352\.agents\skills\latex-guard\SKILL.md"
$skillDest = "$repoPath\SKILL.md"

if (Test-Path $skillSource) {
    Copy-Item -Path $skillSource -Destination $skillDest -Force
    Write-Host "[OK] SKILL.md synced" -ForegroundColor Green
} else {
    Write-Host "[WARN] Source not found: $skillSource" -ForegroundColor Yellow
    exit 1
}

cd $repoPath
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
