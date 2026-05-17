---
name: latex-guard
description: LaTeX 编译防错与排版质量守护技能。专为东北大学学位论文模板(NEU-Thesis)设计，但适用于任何中文学位论文LaTeX模板。提供7类常见编译错误的快速诊断修复、表格排版规范、标准编译流程、12类PDF排版质量检测清单、编译后强制验证流程。关键词触发："编译论文"、"LaTeX报错"、"表格溢出"、"xelatex"、"tex文件"、"bibtex"、"Extra alignment"、"Overfull"、"Float too large"、任何涉及.tex文件编译的场景。
---

# LaTeX Guard — LaTeX 编译防错与排版质量守护技能

## 技能触发

任何涉及 .tex 文件编写、LaTeX 编译、表格制作、xelatex 命令执行、bibtex 引用处理的场景均触发本技能。默认面向 NEU-Thesis 模板，但诊断方法同样适用于其他中文学位论文模板。

---

## 一、七大类常见编译错误

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

### 1.3 图表与对应文字跨页

**含义**：浮动体（table/figure）飘到了下一页，和描述它的文字分开了。

**原因**：LaTeX 浮动体默认自由漂移，`[!htbp]` 只是建议。

**修复三阶梯**：

| 方案 | 命令 | 适用场景 |
|------|------|---------|
| 强制就地（首选） | `\begin{table}[H]` | 图表紧跟在文字后面，不飘 |
| 浮动屏障 | `\FloatBarrier` | 该位置之前所有浮动都必须落位 |
| 缩小浮动体 | `\resizebox{\textheight}{!}{...}` | 浮动体高度超过页面剩余空间 |

**用法**：
```latex
\usepackage{float}          % 放入 Style/artratex.sty
\usepackage{placeins}       % 提供 \FloatBarrier
\begin{table}[H]\centering ... \end{table}   % H 强制锁定
\FloatBarrier                                % 浮动屏障
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

公式太多无法避免跨页时，用 `\nopagebreak[4]` 确保编号在同一页：
```latex
\end{equation}\nopagebreak[4]   % 强烈建议此处不分页
其中 $x'_{ij}$...
```

### 1.5 段落孤行（一行只有一个字 / 一两个字）

**含义**：段落最后一行只剩下1-2个字，单独占据一整行（widow/orphan lines）。

**修复**：在 Thesis.tex 导言区（`\begin{document}` 之前）添加：

```latex
\clubpenalty=10000      % 禁止段首孤行
\widowpenalty=10000     % 禁止段尾孤行
\raggedbottom           % 允许底部留白，避免拉伸产生孤行
```

**单个段落手动修复**：段尾加 `\looseness=-1` 让 LaTeX 尝试收紧一行。

### 1.6 章节间的多余空白页

**含义**：新章从奇数页（右页）开始，上一章在奇数页结束时自动插入空白页。

**原因**：模板设定了 `openright`（学位论文正式规范）。

| 方案 | 命令 | 适用 |
|------|------|------|
| 符合规范（保留） | 不修改 | 正式提交版 |
| 消除空白页 | `\let\cleardoublepage\clearpage` | 草稿/审阅版 |

消除空白页操作（仅工作草稿）：在 `\begin{document}` 前插入 `\let\cleardoublepage\clearpage`。

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
\begin{table}[!htbp]\centering\zihao{5}
  \caption{表格标题}\label{tab:唯一标识}
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
\begin{table}[!htbp]\centering\zihao{5}
  \caption{表格标题}\label{tab:xxx}
  \tablefit{\begin{tabular}{cccccc}
      \toprule 列1 & 列2 & 列3 \\ \midrule 数据 \\ \bottomrule
  \end{tabular}}
  \vspace{2pt}\tablefootnotesize
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

### 3.4 🔴 编译后强制验证（重要！）

每次编译完成后**必须**执行以下步骤，漏一步即为严重错误：

#### 步骤一：验证 PDF 输出位置

编译完成后，立即确认 PDF **确实生成在项目目录下**：

```bash
ls -la "Thesis.pdf"
# 或 PowerShell: Get-Item "Thesis.pdf" | Select FullName, Length
```

- ⚠️ **经典错误**：xelatex 工作目录是模板默认路径，但实际项目在其他目录。编译前务必 `cd` 到项目根目录，编译后验证 PDF 在该目录下。
- 如果 PDF 生成到了错误路径，立即拷贝到正确位置。

#### 步骤二：重命名为论文标题

PDF **不得**以 `Thesis.pdf` 交付，必须重命名：

```bash
mv Thesis.pdf "论文完整主标题.pdf"
# Windows: Rename-Item "Thesis.pdf" "论文完整主标题.pdf"
```

- 标题从 `Tex/Frontpages.tex` 的 `\thesistitle{}` 字段获取
- 使用中文主标题，不含副标题、不含英文翻译

#### 步骤三：推送绝对路径给用户

必须向用户输出 PDF 的完整绝对路径：

```
📄 PDF 已生成：<项目目录>/<论文标题>.pdf（XX 页，X.XX MB）
```

- 使用完整绝对路径，附带页数和文件大小，不可省略。

#### 诊断命令索引

```bash
rg "^!" Thesis.log                        # 统计 Error
rg "Overfull.*hbox" Thesis.log | rg "pt"  # 统计表格溢出
rg "Warning.*Citation" Thesis.log         # 查看引用问题
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
│   ├── Frontpages.tex  ← 封面字段
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
| `Tex/` 下各章节内容文件 | 页面布局、字体规范、页码格式 |
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
6. **空白页**：模板 `openright` 规范；草稿用 `\let\cleardoublepage\clearpage`
7. **图表跨页**：浮动体用 `[H]` 强制锁定位置，或用 `\FloatBarrier` 屏障
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
19. **PDF 路径错误**：编译前 cd 到项目根目录；编译后 verify PDF 落在项目目录下
20. **PDF 文件名不规范**：输出文件必须重命名为论文中文标题，不能保留 "Thesis.pdf"
21. **编译后未告知用户路径**：完成编译和重命名后，必须推送 PDF 的完整绝对路径 + 页数 + 文件大小

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

论文编译完成后，按以下12大类逐项检查生成的 PDF。

### 7.1 封面与题名页

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 学位类型错误 | 硕士标"博士" | `Tex/Frontpages.tex` 中 `\thesislevel{}` |
| 校名断字 | N O R T H E A S T | 校名用 `\textbf` 包裹 |
| 标题断行混乱 | 多余空格、重复 | 用 `\\` 精确控制换行 |
| 信息缺失 | `(xx)` 占位符 | 逐字段填入真实内容 |

### 7.2 页码与页眉

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 页眉重复叠加 | 标题重复N次 | 检查 `\pagestyle` 定义 |
| 页码混用 | 前言阿拉伯/正文罗马 | `\frontmatter`(罗马) `\mainmatter`(阿拉伯) |
| 页码偏移 | I,II,III,IV 重复 | 删除多余 `\pagenumbering{}` |
| 目录页码不匹配 | 标注与实际不符 | 必须 2 次 xelatex |

### 7.3 目录结构

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 章节编号错乱 | 5.3 在 5.1 前 | 检查 `\section` 顺序 |
| 层级异常 | 三级标题缩进错 | `\subsection` 嵌套在 `\section` 内 |
| 引导点不齐 | 点线缺失 | 模板自动生成，不需改 |
| 图表索引缺失 | 图号后无标题 | 每个 `\caption{}` 有文字内容 |

### 7.4 正文结构

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 标题重复 | 同一章出现多次 | 删除重复 `\chapter{}` |
| 层级混乱 | 3.2.1 缺 3.2 | `\subsubsection` 在 `\subsection` 内 |
| 段首空格 | 空格混用 | LaTeX 自动缩进，不手动加 |
| 多余空行 | 连续空行 | 删除 `.tex` 中多余空行 |

### 7.5 公式与数学符号

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 上下标错误 | cm2 应为 cm² | 用 `cm$^2$` / `\textsuperscript{2}` |
| 变量未斜体 | x 应为 $x$ | 变量用 `$x$` 包裹 |
| 正斜体混排 | 单位 m 需正体 | `\Unit{m}` / `\mathrm{m}` |
| 编号不对齐 | 编号偏离 | 用 `\begin{equation}` |
| 公式引用残缺 | `[3]` 写成 `(3)` | `\label{eq:xxx}` + `\eqref{eq:xxx}` |

### 7.6 表格排版

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 三线表缺失 | 有竖线/多余横线 | 只用 `\toprule` `\midrule` `\bottomrule` |
| 跨页割裂 | 无表头续页 | `longtable` + `\endhead` |
| 表题分离 | 不在同一页 | `\begin{table}[H]` 锁定 |
| 列宽不均 | 溢出或过空 | 用 `p{3cm}` 固定列宽 |
| 表注缺失 | 无数据来源 | `\tablefootnotesize 注：...` |

### 7.7 图片与插图

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 图题缺失 | 图号后无文字 | 每个 `\caption{}` 填标题 |
| 图号不连续 | 缺图3.2 | 检查 `\label` 和引用 |
| 图题分离 | 图题跨页 | `\begin{figure}[H]` |
| 分辨率低 | 模糊/锯齿 | 导出 dpi=300，PNG/PDF |
| 引用格式错误 | 图2-1 → 图2.1 | `\ref{fig:xxx}` |

### 7.8 文字与标点符号

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 全角半角混排 | 中文夹英文标点 | 中文后用全角 `，。：；` |
| 引号不配对 | `"xxx"` → `"xxx"` | 直接输入 `""` |
| 破折号错误 | `--` 代 `—` | 用 `——` 或 `---` |
| 单位无空格 | 25cm → 25 cm | `\Unit{cm}` |
| 特殊符号 | ℃ % ± 错位 | `$^\circ$C` `\%` `$\pm$` |

### 7.9 参考文献与引用

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 上标位置 | 正文[1] 应为上标 | `\cite{}` 自动上标 |
| 序号不连续 | [1][2][5] | 检查 bib 条目完整性 |
| 英文未斜体 | 期刊名正体 | BibTeX `journal` 自动处理 |
| 条目不齐 | 悬挂缩进缺失 | `.bst` 自动处理 |
| 格式不统一 | 中英文混排混乱 | `ref.bib` 统一管理 |

### 7.10 固定模版页

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 声明页污染 | 页眉在声明页 | `\thispagestyle{empty}` |
| 摘要标题重复 |"摘 要"×3 | 删除多余 `\chapter*{摘要}` |
| 中英文不对应 | 段数不一致 | 确保一一对应 |
| 关键词格式 | 逗号分隔 | 统一用 `；` |

### 7.11 格式统一性

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 字体混用 | 宋/黑/楷随机 | 宋体正文+黑体标题 |
| 字号混乱 | 同级字数不同 | 模板自动统一 |
| 行距/段距不一致 | 间距差异 | 模板 `\linespread{}` |
| 中英文间距 | 无空格或过大 | XeLaTeX 自动处理 |

### 7.12 内容冗余与乱码

| 检查点 | 关键词 | 修复 |
|-------|--------|------|
| 乱码字符 |"宝""男士" | 替换为正确中文 |
| 占位符残留 |"(作者姓名)" | 替换为真实信息 |
| 代码残留 |"pip install" | 删除非论文内容 |
| 重复段落 | 同一段×2 | 删除重复内容 |

---

## 八、编译后一键排版检查

将打包的 PowerShell 脚本（见 `scripts/check_latex_quality.ps1`）放到模板根目录，编译后运行即可批量扫描：占位符残留、编译 Error、引用未解析、表格溢出、浮动体过大。