# check_latex_quality.ps1
# 放到你的NEU-Thesis模板根目录，编译后运行

Write-Host "=== LaTeX 排版质量扫描 ===" -ForegroundColor Cyan

# 1. 检查占位符残留
Write-Host "`n[1/5] 占位符检查..."
rg -l "作者姓名|导师姓名|学号|学院名称" Thesis.pdf 2>$null
if ($LASTEXITCODE -eq 0) { Write-Host "  ⚠ 发现占位符未替换!" -ForegroundColor Red }

# 2. 检查编译 Error
Write-Host "`n[2/5] 编译错误..."
$errors = rg "^!" Thesis.log
if ($errors) { Write-Host "  ❌ 发现 $($errors.Count) 个编译错误" -ForegroundColor Red }

# 3. 检查引用未解析
Write-Host "`n[3/5] 引用解析..."
rg "Warning.*undefined" Thesis.log
rg "Warning.*Citation.*undefined" Thesis.log

# 4. 检查表格溢出
Write-Host "`n[4/5] 表格溢出..."
rg "Overfull.*hbox.*pt" Thesis.log | rg -v "(1\.|2\.|3\.|4\.|5\.|6\.|7\.|8\.|9\.)pt"

# 5. 检查浮动体溢出
Write-Host "`n[5/5] 浮动体过大..."
rg "Float too large" Thesis.log

Write-Host "`n=== 扫描完成 ===" -ForegroundColor Cyan
