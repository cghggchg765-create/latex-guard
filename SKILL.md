# LaTeX Guard — LaTeX 编译防错与排版质量守护技能

## 技能描述

NEU-Thesis LaTeX 编译防错指南。覆盖3大类常见编译错误的快速诊断与修复方案、表格排版策略速查、标准编译流程、模板使用规范，以及自我完善机制。

**触发条件**：任何涉及 .tex 文件编写、LaTeX 编译、表格制作、xelatex 命令执行、bibtex 引用处理的场景。关键词包括："编译论文"、"LaTeX报错"、"表格溢出"、"xelatex"、"tex文件"、"bibtex"、"Extra alignment"、"Overfull"、"Float too large"。

**默认模板路径**：你的NEU-Thesis模板根目录 (东北大学学位论文通用模板)

---

## 一、三大类常见编译错误

### 1.1 "Extra alignment tab has been changed to \cr."

**含义**：表格列数定义与实际数据列数不匹配。

**原因**：`\begin{tabular}{...}` 中定义的列数 < 数据行中 `&` 分隔符数 + 1。

**诊断**：数清列格式中 `l`/`c`/`r`/`p{}` 的个数，再数数据行中 `&` 的个数。例如 `{ccccccc}` 有7列，每行应恰好有6个 `&`。

**修复**：
- 修改 `\begin{tabular}{...}` 中的列数定义使其匹配数据行
- 或删除数据行中多余的 `&`

### 1.2 "Overfull \hbox" / "Float too large for page"

**含义**：表格宽度超出页面宽度。

**原因**：多列表格（≥6列）未做缩放处理。

**修复优先级（按表格宽度选择）**：

| 表格特征 | 方案 | 命令/环境 |
|---------|------|---------|
| 列数≤5 | 居中 + 五号字 | `\centering\zihao{5}` |
| 列数6-8 | 缩放适配 | `\tablefit{\begin{tabular}{...}...\end{tabular}}` |
| 列数≥9 | 横向页面 | `\begin{sidewaystable}...\end{sidewaystable}` |
| 超长表格 | 跨页表格 | `\begin{longtable}{...}...\end{longtable}` |
| 附录超大表 | 缩放 + 横向 | `sidewaystable` 内嵌 `\tablefit` |

### 1.3 图表与对应文字跨页（图表跑了，文字留在上页）

**含义**：浮动体（table/figure）飘到了下一页，和描述它的文字分开了。

**原因**：LaTeX 浮动体默认自由漂，`[!htbp]` 只是建议。

**修复三阶梯**：

| 方案 | 命令 | 适用场景 |
|------|------|---------|
| 强制就地（首选） | `\begin{table}[H]` | 图表必须紧跟在文字后面，不飘 |
| 浮动屏障 | `\FloatBarrier` | 该位置之前的所有浮动都必须落位 |
| 缩小浮动体 | `\resizebox{\textheight}{!}{...}` | 浮动体高度超过页面剩余空间 |

**用法**：
```latex
\usepackage{float}          % 放入 Style/artratex.sty
\usepackage{placeins}       % 提供 \FloatBarrier

% 方式一：H 强制锁定
\begin{table}[H]
  \centering
  ...
\end{table}

% 方式二：在需要锁定浮动的位置插入
\FloatBarrier
```

### 1.4 公式与变量解释被分页切开

**含义**：公式在一页底部，它的"其中 $x$ 为..."解释文字被截到下一页顶部。

**修复**：用 `minipage` 盒子把公式和解释文字捆在一起：

```latex
\noindent\begin{minipage}{\textwidth}
\begin{equation}
  w_j = \frac{(\prod a_{ij})^{1/n}}{\sum (\prod a_{kj})^{1/n}} \tag{1}
\end{equation}
其中 $a_{ij}$ 为判断矩阵元素，$n$ 为矩阵阶数，$w_j$ 为权重向量。
\end{minipage}
```

如果公式太多且确实无法避免跨页，至少确保公式编号在同一页，用 `\nopagebreak[4]` 在公式后：
```latex
\end{equation}
\nopagebreak[4]     % 强烈建议此处不要分页
其中 $x'_{ij}$...
```

### 1.5 段落孤行（一行只有一个字 / 一两个字）

**含义**：段落最后一行只剩下1-2个字，单独占据一整行（widow/orphan lines）。

**修复**：在 Thesis.tex 导言区（`\begin{document}` 之前）添加：

```latex
% 孤行控制
\clubpenalty=10000      % 禁止段首孤行（页底只留段首一行）
\widowpenalty=10000     % 禁止段尾孤行（页顶只留段尾一行）
\raggedbottom           % 允许页面底部留白，避免强行拉伸产生孤行
```

**针对单个段落的手动修复**：
```latex
% 在段落末尾加 \looseness=-1 让 LaTeX 尝试收紧一行
正文内容...最后几个字。\looseness=-1
```

### 1.6 章节间的多余空白页

**含义**：新章节总是从奇数页（右页）开始，如果上一章在奇数页结束，中间自动插入空白页。

**原因**：论文模板设定了 `openright`（这是学位论文的正式规范）。

**两种处理方式**：

| 方案 | 命令 | 适用 |
|------|------|------|
| 符合规范（保留） | 不修改 | 正式提交版 |
| 消除空白页 | `\let\cleardoublepage\clearpage` | 草稿/审阅版 |

**消除空白页的具体操作**（仅用于工作草稿）：
在 Thesis.tex 的 `\begin{document}` 之前插入：
```latex
\let\cleardoublepage\clearpage
```

### 1.7 "Undefined citation" / 引用显示 "[?]"

**含义**：参考文献引用无法解析。

**原因**：BibTeX 未运行，或 bib key 与 ref.bib 中不匹配，或 `\cite{}` 拼写错误。

**修复**：
1. 检查 `Biblio/ref.bib` 中是否存在该 key
2. 确认 `\cite{}` 中的 key 拼写与 bib 文件完全一致（区分大小写）
3. 重新执行完整编译链：`xelatex → bibtex → xelatex → xelatex`

---

## 二、表格排版完整规范

### 2.1 表格标准模板

```latex
% 标准表格模板（6-8列宽表用\tablefit）
\begin{table}[!htbp]
  \centering\zihao{5}
  \caption{表格标题}
  \label{tab:唯一标识}
  \tablefit{
    \begin{tabular}{cccccccc}
      \toprule
      列1 & 列2 & 列3 & 列4 & 列5 & 列6 & 列7 & 列8 \\
      \midrule
      数据行 & ... & ... & ... & ... & ... & ... & ... \\
      \bottomrule
    \end{tabular}
  }
\end{table}
```

### 2.2 单元格过长的处理

当某一列内容过长时，使用 `p{宽度}` 指定列宽让其自动换行：

```latex
\begin{tabular}{lp{4cm}p{3cm}cc}
```
- `p{4cm}`：该列宽度4cm，超出自动换行
- 可用表达式：`p{\dimexpr0.15\textwidth-2\tabcolsep\relax}` 精确计算

### 2.3 表格注释和脚注

```latex
\begin{table}[!htbp]
  \centering\zihao{5}
  \caption{表格标题}
  \label{tab:xxx}
  \tablefit{
    \begin{tabular}{cccccc}
      \toprule
      列1 & 列2 & 列3 \\
      \midrule
      数据 \\
      \bottomrule
    \end{tabular}
  }
  \vspace{2pt}
  \tablefootnotesize
  注：表格脚注内容，说明数据来源、缩写等。
\end{table}
```

### 2.4 LaTeX公式在表格单元格中

表格内的短公式用 `$...$` 内联，长公式用 `\makecell{$\displaystyle ...$}`：

```latex
% 需要在导言区加载 \usepackage{makecell}
& \makecell{$\displaystyle I = \frac{n}{W}\frac{\sum w_{ij}...}{\sum ...}$} &
```

---

## 三、标准编译流程

### 3.1 完整编译链（4步）

```bash
cd <你的NEU-Thesis模板目录>
xelatex -interaction=nonstopmode Thesis.tex    # 第1步：生成 .aux 文件
bibtex Thesis                                   # 第2步：生成 .bbl 引用数据
xelatex -interaction=nonstopmode Thesis.tex    # 第3步：解析引用
xelatex -interaction=nonstopmode Thesis.tex    # 第4步：确认交叉引用
```

### 3.2 快速编译（仅改正文无新增引用时）

```bash
xelatex -interaction=nonstopmode Thesis.tex
```

### 3.3 编译结果判断标准

- **成功**：生成 `Thesis.pdf`，.log 中无 `^!` 开头的 Error 行
- **警告可忽略**：`Overfull`、`Underfull`、`Font Warning` 通常不影响结果
- **必须修复**：`^!` 开头的 Error，`Float too large`，引用显示 `[?]`

### 3.4 诊断命令

```bash
# 统计 Error 数量
rg "^!" Thesis.log

# 统计 Overfull 数量（关注表格相关）
rg "Overfull.*hbox" Thesis.log | rg "pt" 

# 查看引用问题
rg "Warning.*Citation" Thesis.log
rg "Warning.*undefined" Thesis.log
```

---

## 四、NEU-Thesis 模板结构速查

```
<你的NEU-Thesis模板目录>/
├── Thesis.tex          ← 主入口（不要改结构和选项）
├── Style/
│   ├── neuthesis.cls   ← 文档类（禁止修改）
│   ├── artratex.sty    ← 样式宏包（可添加 \RequirePackage）
│   └── artracom.sty    ← 用户自定义宏（可自由添加命令）
├── Tex/
│   ├── Frontpages.tex  ← 封面字段（填信息，不改结构）
│   ├── Abstract.tex    ← 中英文摘要
│   ├── Mainmatter.tex  ← 引用章节输入文件
│   ├── Backmatter.tex  ← 致谢 + 附录
│   ├── Chap_1.tex ~ Chap_7.tex  ← 各章节内容
│   └── Tables_Best_Practices.tex  ← 表格参考（不参与编译）
├── Biblio/
│   └── ref.bib         ← BibTeX 参考文献数据库
├── Img/                ← 图表存放目录
└── simfang.ttf, simhei.ttf, simkai.ttf, simsun.ttc ← 中文字体文件
```

### 4.1 模板修改红线

| ✅ 允许修改 | ❌ 禁止修改 |
|-----------|-----------|
| `Style/artracom.sty` 添加新命令 | `Thesis.tex` 的 `\documentclass` 和选项 |
| `Style/artratex.sty` 添加 `\RequirePackage` | `neuthesis.cls` 的格式定义 |
| `Tex/` 下各章节内容文件 | 页面布局、字体规范、编译引擎（必须用 xelatex） |
| `Img/` 存放新图片 | `Frontpages.tex` 的字段结构 |
| `Biblio/ref.bib` 增删条目 | 编译引擎（必须用 xelatex） |

---

## 五、自我完善机制

每次编译过程发现新的错误类型或排版技巧时，立即追加到本文档对应章节。

### 5.1 添加新错误的格式

```markdown
### [错误关键字]
- **出现场景**：
- **诊断方法**：
- **修复步骤**：
- **模板修复位置**（如适用）：
```

### 5.2 添加新表格技巧的格式

追加到第二章"表格排版完整规范"中，保持编号递增。

### 5.3 已累积的教训

1. **列对齐错误(Extra alignment tab)**：数 `&` + 1 = 列数，两者必须匹配
2. **宽表溢出(Overfull)**：`\tablefit` 缩放是最通用方案
3. **巨型表格(Float too large)**：`\resizebox{\textwidth}{!}` 包裹整个 tabular
4. **引用缺失(Undefined citation)**：完整4步编译链是最可靠方案
5. **中文乱码**：必须用 `xelatex`，不要用 `pdflatex`
6. **空白页**：模板设计为每章从奇数页开始，不修改此行为
7. **图表跨页**：浮动体用 `[H]` 强制锁定位置，或用 `\FloatBarrier` 屏障
8. **公式与解释分离**：用 `minipage` 捆在一起，或用 `\nopagebreak[4]` 阻断开裂
9. **段尾孤行**：导言区设 `\clubpenalty=10000` + `\widowpenalty=10000` + `\raggedbottom`
10. **章节空白页**：草稿阶段用 `\let\cleardoublepage\clearpage` 消除；正式提交恢复 `openright`

---

## 六、常用工具宏

以下宏已在 `Style/artracom.sty` 中定义，所有章节文件可直接使用：

| 宏命令 | 作用 | 用法 |
|-------|------|------|
| `\tablefit{...}` | 表格缩放到页面宽度 | `\tablefit{\begin{tabular}...\end{tabular}}` |
| `\tablefootnotesize` | 表格脚注字号 | `\tablefootnotesize 注：...` |
| `\Vector{...}` | 数学向量（粗斜体） | `\Vector{x}` |
| `\Matrix{...}` | 数学矩阵（粗正体） | `\Matrix{A}` |
| `\Unit{...}` | 单位（正体） | `\Unit{kg/m^3}` |
| `\nopagebreak[4]` | 强烈建议在此不分页 | 公式后紧跟 `\nopagebreak[4]` |
| `\looseness=-1` | 尝试将段落收紧一行 | 段落末尾 `\looseness=-1` |

---

## 七、PDF 排版质量全面检测清单

论文编译完成后，按以下12大类逐项检查生成的 PDF。每一类均给出 **grep/肉眼检查要点** 和 **LaTeX 修复方案**。

---

### 7.1 封面与题名页

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 学位类型错误 | 硕士论文标"博士学位论文" | `Tex/Frontpages.tex` 中 `\thesislevel{}` 字段 |
| 校名断字 | 大写字母间空格：N O R T H E A S T | 校名用 `\textbf` 包裹，不加空格 |
| 标题断行混乱 | 标题中多余空格、重复 | 用 `\\` 精确控制换行，不用连续空格 |
| 信息缺失 | 学院/专业/日期为占位符 `(xx)` | 逐字段填入真实内容 |

---

### 7.2 页码与页眉

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 页眉重复叠加 |"东北大学博士学位论文"重复N次 | 检查 `neuthesis.cls` 中 `\pagestyle` 定义 |
| 页码混用 | 前言用阿拉伯数字、正文用罗马数字 | 模板已处理：`\frontmatter`(罗马) `\mainmatter`(阿拉伯) |
| 页码偏移 | I,II,III,IV 重复 | 检查是否有额外的 `\pagenumbering{}` 调用 |
| 目录页码不匹配 | 目录标页15，实际在17页 | 必须运行 2 次 xelatex 解析交叉引用 |

---

### 7.3 目录结构

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 章节编号错乱 | 5.3 出现在 5.1 前 | 检查 `\section` 顺序 |
| 层级异常 | 三级标题缩进不对 | 确保 `\subsection` 嵌套在 `\section` 内 |
| 引导点不齐 | 点线缺失或密度不对 | 模板 `\tableofcontents` 自动生成，不需改 |
| 图表索引缺失 | 图/表编号后无标题文字 | 每个 `\caption{}` 必须有文字内容 |

---

### 7.4 正文结构

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 标题重复 | 第1章 引言 出现多次 | 删除重复的 `\chapter{}` |
| 层级混乱 | 3.2.1 前无 3.2 | `\subsubsection` 必须在 `\subsection` 内 |
| 段首空格 | 全角/半角空格混用 | LaTeX 自动处理缩进，不要在段首手动加空格 |
| 多余空行 | 两个连续空行 | 删除 `Tex/` 文件中多余空行 |

---

### 7.5 公式与数学符号

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 上下标错误 | `cm2` 应为 `cm²` | 用 `cm$^2$` 或 `cm\textsuperscript{2}` |
| 变量未斜体 | 正文中 `x` 应为 $x$ | 变量名用 `$x$` 包裹 |
| 正斜体混排 | 单位 `m` 应为正体 | 用 `\Unit{m}` 宏 或 `\mathrm{m}` |
| 编号不对齐 | 公式编号偏左或居中 | 用 `\begin{equation}` 自动右对齐编号 |
| 公式引用残缺 | `[3]` 写成 `(3)` | 公式用 `\label{eq:xxx}` + `\eqref{eq:xxx}` 引用 |

---

### 7.6 表格排版

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 三线表缺失 | 表格有竖线或多条横线 | 只用 `\toprule` `\midrule` `\bottomrule` |
| 跨页割裂 | 表格下半截在下一页、无表头 | 用 `longtable` + `\endhead` 重复表头 |
| 表题分离 | 表题和表格不在同一页 | 用 `\begin{table}[H]` 锁定 |
| 列宽不均 | 文字溢出单元格或过空 | 用 `p{3cm}` 固定列宽 |
| 表注缺失 | 无数据来源、无缩写说明 | `\tablefootnotesize 注：...` |

---

### 7.7 图片与插图

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 图题缺失 | 图号后无文字 | 每个 `\caption{}` 必须填标题 |
| 图号不连续 | 图3.1→图3.3 缺图3.2 | 检查 `\label` 和引用 |
| 图题分离 | 图和图题跨页 | `\begin{figure}[H]` 锁定 |
| 分辨率低 | 图片模糊、锯齿 | 导出图时设 `dpi=300`，用 PNG/PDF 格式 |
| 引用格式错误 | `图2-1` 应为 `图2.1` | 用 `\ref{fig:xxx}` 自动生成正确格式 |

---

### 7.8 文字与标点符号

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 全角半角混排 | 中文中夹英文标点 `,.:;` | 中文后用全角 `，。：；` |
| 引号不配对 | `"xxx"` 应为 `"xxx"` | 中文引号用 `\zihaodian` 或直接输入 `""` |
| 破折号错误 | `--` 代 `—` | 用 `——`（两字线）或 `---`（英文破折号）|
| 单位无空格 | `25cm` → `25 cm` | 用 `\Unit{cm}` 自动加半角空格 |
| 特殊符号 | `℃` `%` `±` 排版错位 | 用 `$^\circ$C` `\%` `$\pm$` |

---

### 7.9 参考文献与引用

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 上标位置 | 正文[1] 应为 正文$^{[1]}$ | 用 `\cite{}` 自动生成上标 |
| 序号不连续 | [1][2][5] 缺[3][4] | 检查 bib 文件条目完整性 |
| 英文未斜体 | 期刊名应为斜体 | BibTeX 中 `journal` 字段自动处理 |
| 条目不齐 | 悬挂缩进缺失 | `gbt7714-unsrt.bst` 自动处理 |
| 格式不统一 | 中英文混排格式混乱 | 中英文分别用对应格式，`ref.bib` 统一管理 |

---

### 7.10 固定模版页

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 声明页污染 | 页眉出现在声明页 | 声明页用 `\thispagestyle{empty}` |
| 摘要标题重复 |"摘 要"出现3次 | 删除多余的 `\chapter*{摘要}` |
| 中英文不对应 | 中文摘要5段、英文3段 | 确保内容一一对应 |
| 关键词格式 | 用逗号而非分号分隔 | 统一用 `；` 分隔关键词 |

---

### 7.11 格式统一性

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 字体混用 | 宋体黑体楷体随机出现 | 模板统一为宋体正文+黑体标题 |
| 字号混乱 | 同级别标题字号不同 | `\chapter` `\section` `\subsection` 自动统一 |
| 行距/段距 | 不同段落间距不一致 | 模板已设 `\linespread{}`，不需修改 |
| 中英文间距 | 中英文间无空格或过大 | XeLaTeX 自动处理，不需额外加空格 |

---

### 7.12 内容冗余与乱码

| 检查点 | AI 检测关键词 | LaTeX 修复 |
|-------|-------------|-----------|
| 乱码字符 |"宝""男士""r 2置" | 删除或替换为正确中文 |
| 占位符残留 |"(作者姓名)""(导师)" | 替换为真实信息 |
| 代码残留 |"需安装networkx包""pip install" | 删除所有非论文内容 |
| 重复段落 | 同一段出现2次 | 删除重复内容 |

---

## 八、编译后一键排版检查脚本

将以下 PowerShell 脚本保存到模板根目录，编译后运行即可批量扫描常见排版问题：

```powershell
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
```

---

## 九、已累积的全部教训

1. **列对齐错误**：数 `&` + 1 = 列数，两者必须匹配
2. **宽表溢出**：`\tablefit` 缩放是最通用方案
3. **巨型表格**：`\resizebox{\textwidth}{!}` 包裹整个 tabular
4. **引用缺失**：完整4步编译链是最可靠方案
5. **中文乱码**：必须用 `xelatex`，不要用 `pdflatex`
6. **空白页**：模板 `openright` 规范；草稿用 `\let\cleardoublepage\clearpage`
7. **图表跨页**：浮动体用 `[H]` 强制锁定位置
8. **公式与解释分离**：用 `minipage` 捆在一起，或用 `\nopagebreak[4]` 阻断开裂
9. **段尾孤行**：导言区设 `\clubpenalty=10000` + `\widowpenalty=10000` + `\raggedbottom`
10. **三线表缺失**：只用 `\toprule` `\midrule` `\bottomrule`
11. **表格跨页割裂**：用 `longtable` + `\endhead` 重复表头
12. **英文期刊名未斜体**：BibTeX 的 `journal` 字段自动处理
13. **单位与数字无空格**：用 `\Unit{cm}` 宏
14. **公式变量未斜体**：变量用 `$x$`，单位用 `\mathrm{m}`
15. **图题分离**：`\begin{figure}[H]` 锁定图片位置
16. **图片模糊**：导出时设 `dpi=300`
17. **占位符残留**：编译后用脚本扫描 `(作者姓名)` 等关键字
18. **目录页码不匹配**：必须2次 xelatex 解析交叉引用
