# LaTeX Guard - LaTeX 编译防错与排版质量守护技能

[![GitHub stars](https://img.shields.io/github/stars/cghggchg765-create/latex-guard)](https://github.com/cghggchg765-create/latex-guard)
[![License](https://img.shields.io/github/license/cghggchg765-create/latex-guard)](./LICENSE)

## 简介

LaTeX Guard 是一个面向 OpenCode/Claude 的智能技能，专为 LaTeX 论文撰写提供全流程编译防错与排版质量保障。无论你是使用 NEU-Thesis、北大模板还是其他中文学位论文模板，该技能都能帮你系统性避免常见的 LaTeX 编译陷阱。

## 🎓 基于模板

本 Skill 专为**东北大学学位论文 LaTeX 模板**设计，但诊断方法与修复策略同样适用于其他 LaTeX 论文场景。

**原始模板信息：**

| 项目 | 详情 |
|------|------|
| 项目名 | [NEU-Thesis](https://github.com/sci-m-wang/NEU-Thesis) — 东北大学学位论文 LaTeX 模板 |
| 原作者 | [sci-m-wang](https://github.com/sci-m-wang) |
| 上游项目 | 基于 [mervin0502/neuthesis](https://github.com/mervin0502/neuthesis) 和 [NEUAI/neuthesis-enhanced](https://github.com/NEUAI/neuthesis-enhanced) |
| 许可证 | Apache 2.0 |

模板已针对 Overleaf 优化，可在本地或在线环境直接使用。LaTeX Guard 在此基础上补充了编译错误快速诊断、排版质量检测、编译后强制验证等实用功能。

## 🚀 快速开始

### 前置要求

- 安装 [NEU-Thesis 模板](https://github.com/sci-m-wang/NEU-Thesis)：`git clone https://github.com/sci-m-wang/NEU-Thesis.git`
- 安装 LaTeX 环境（推荐 TeX Live 2024+）
- 安装 OpenCode（或兼容的 AI 编程助手）

### 安装本 Skill

```bash
git clone https://github.com/cghggchg765-create/latex-guard.git ~/.agents/skills/latex-guard
```

### 使用方式

在 OpenCode 中直接说出触发关键词即可，AI 将自动加载技能并响应：

- "帮我编译论文" — 自动执行完整编译链并验证结果
- "表格溢出了怎么修" — 根据表格特征推荐最佳修复方案
- "检查 PDF 排版质量" — 按 12 大类逐项扫描排版问题
- "系统性修复所有图表位置" — 启动批量浮动体修复工作流（攻击模式）

## 核心功能

- 🔍 **编译错误快速诊断**：7 类常见编译错误（列对齐、溢出、浮动体跨页、公式分离、孤行、空白页、引用未解析），每类均提供诊断方法与修复方案
- 📊 **表格排版规范**：标准三线表模板、单元格自动换行、脚注嵌入、公式单元格、宽表缩放策略
- 🎯 **12 类 PDF 排版质量检测清单**：从封面题名页到参考文献，覆盖页码、目录、公式、表格、图片、标点、格式统一性、内容冗余等全部维度的逐项检查
- 🔴 **编译后强制验证**：三步验证流程（确认 PDF 位置 → 重命名为论文标题 → 推送绝对路径），防止交付错误文件
- ⚡ **一键检查脚本**：PowerShell 5 步批量扫描（占位符、编译错误、引用未解析、表格溢出、浮动体过大）
- 🚀 **批量浮动体修复工作流（攻击模式）**：对已完成论文进行系统性浮动体位置修复——六步分层推进（扫描 → 全局参数 → 位置参数统一 → 脆弱点绑定 → 编译验证 → 遗留处理），附完整优先级决策表和可复制 bash 命令序列
- 🔄 **自我完善机制**：自动累积新发现的错误模式和解决方案，已沉淀 27 条实战教训

## 📊 Skill 能力全景

| 能力领域 | 覆盖范围 | 关键技术 |
|---------|---------|---------|
| 编译引擎 | xelatex（中文必须）、pdflatex 问题诊断 | `-interaction=nonstopmode` |
| 编译流程 | 完整 4 步链、快速编译、增量编译 | xelatex → bibtex → xelatex × 2 |
| 错误诊断 | 列对齐、宽表溢出、引用未解析、中文乱码 | log 文件解析（`rg "^!"`） |
| 表格排版 | 三线表、列宽控制、缩放、跨页、旋转 | `\tablefit`、`longtable`、`sidewaystable` |
| 浮动体控制 | 图表位置锁定、浮动屏障、高度适配 | `[H]`、`\FloatBarrier`、`minipage`、`afterpage` |
| 批量浮动体修复 | 全局参数调整、位置参数统一 `[hbt!]`、`\nopagebreak[4]` 绑定、minipage 强绑定 | 6 步攻击管线 + 优先级决策表 |
| 孤行控制 | 段首/段尾孤行、段落收紧 | `\clubpenalty`、`\widowpenalty`、`\raggedbottom` |
| 引用管理 | BibTeX 编译、key 校验、交叉引用 | bibtex + 二次 xelatex |
| 排版检测 | 12 大类 50+ 检查点 | 自动扫描 + 人工复核 |
| 模板规范 | 修改红线、结构速查、样式注入 | `artracom.sty` / `artratex.sty` |
| 输出验证 | PDF 路径校验、文件名规范、路径推送 | 三步强制验证流程 |
| 自动化 | 一键排版扫描、编译后检查 | PowerShell 脚本集成 |
| AI 提示词 | LaTeX 代码生成标准模板、修正已有代码模板 | 8 条规范约束 + 5 条修正指令 |

## 🔧 模板修复与改进

以下是在实际使用 NEU-Thesis 模板过程中发现并修复的问题：

| 问题 | 说明 | 状态 |
|------|------|------|
| 编译引擎错误 | pdflatex 导致中文乱码，统一改用 xelatex | ✅ 已修复 |
| 表格列数不匹配 | Extra alignment tab 错误快速诊断 | ✅ 已修复 |
| 宽表溢出 | Overfull hbox，采用 `\tablefit` 自适应缩放 | ✅ 已修复 |
| 浮动体跨页 | 图表与文字分离，`[H]` 强制锁定 + `\FloatBarrier` 屏障 | ✅ 已修复 |
| 公式与解释分离 | `minipage` 捆绑 + `\nopagebreak` 防止断裂 | ✅ 已修复 |
| 段尾孤行控制 | `\clubpenalty` + `\widowpenalty` + `\raggedbottom` | ✅ 已修复 |
| 空白页处理 | 草稿阶段用 `\cleardoublepage` 消除空白页 | ✅ 已修复 |
| 引用缺失 [?] | 完整 4 步编译链 + bib key 校验 | ✅ 已修复 |
| PDF 路径错误 | 编译前 `cd` 到正确项目目录 | ✅ 已修复 |
| PDF 文件名不规范 | 编译后重命名为论文中文标题 | ✅ 已修复 |
| 编译后未告知路径 | 强制推送 PDF 绝对路径 + 页数 + 文件大小 | ✅ 已修复 |
| 12 类排版全面检测 | 封面 → 页码 → 目录 → 正文 → 公式 → 表格 → 图片 → 标点 → 引用 → 模版页 → 格式 → 冗余 | ✅ 已修复 |
| 模板修改红线 | 明确哪些可改、哪些禁止修改 | ✅ 已规范 |
| 页码格式规范 | 修正禁止修改表中的重复条目 | ✅ 已修复 |
| 全局浮动体参数 | `\topfraction=0.9` + `\bottomfraction=0.9` 等 6 项参数调整 | ✅ 已修复 |
| 浮动体位置统一 | 30 处 `[htbp]` → `[hbt!]` 批量优化 | ✅ 已修复 |
| `\nopagebreak[4]` 绑定 | 12 处图表前导文字末尾添加分页禁止指令 | ✅ 已修复 |
| `\usepackage[section]{placeins}` | 章节级别浮动屏障自动控制 | ✅ 已应用 |
| afterpage 延迟浮动 | 精确控制浮动体到下页顶部 | ✅ 已支持 |
| 批量修复工作流 | 6 步攻击管线（扫描→全局参数→位置参数→脆弱点绑定→编译验证→遗留处理） | ✅ 已沉淀 |

## 📂 文件结构

```
latex-guard/
├── SKILL.md                  # 技能定义（核心）
├── README.md                 # 项目说明
├── LICENSE                   # MIT 许可证
├── .gitignore
├── references/               # 参考文档
│   └── template_structure.md # 模板结构速查
└── scripts/
    └── check_latex_quality.ps1 # 排版质量一键扫描
```

## 触发关键词

以下任意关键词将自动触发本技能：

| 类别 | 关键词 |
|------|--------|
| 编译相关 | "编译论文"、"xelatex"、"latex编译"、"编译报错" |
| 错误诊断 | "LaTeX报错"、"Extra alignment"、"Overfull"、"Float too large"、"Undefined citation" |
| 表格相关 | "表格溢出"、"表格排版"、"三线表" |
| 图表位置 | "图表跨页"、"浮动体分离"、"图表漂移"、"图片和文字分开" |
| 批量修复 | "系统性检查浮动体"、"修复所有图表位置"、"批量优化排版"、"论文排版整体修复" |
| 质量检测 | "检查PDF"、"排版质量"、"格式检查" |
| 文件操作 | "tex文件"、"bibtex"、"参考文献引用" |

## 适用场景

- 中文/英文学位论文（硕博）
- 学术期刊论文投稿
- LaTeX 模板开发与调试
- 团队协作中的编译规范检查
- Overleaf 在线 / 本地编译均可
- 已定稿论文的批量排版优化（攻击模式）

## 🙏 致谢

LaTeX Guard 的发展离不开以下项目和贡献者的支持，在此表示由衷的感谢：

- **[sci-m-wang](https://github.com/sci-m-wang)** — 维护 NEU-Thesis 模板，使其可直接在 Overleaf 使用，为我们提供了一个优秀的学位论文写作起点
- **[mervin0502](https://github.com/mervin0502)** — 最初的 neuthesis 模板，为东北大学 LaTeX 论文模板奠定了基础
- **[NEUAI](https://github.com/NEUAI)** — neuthesis-enhanced 增强版，进一步完善了模板的功能和稳定性

正是这些开源贡献让 LaTeX 论文写作变得更加便捷和规范。LaTeX Guard 希望在此基础上，帮助更多同学避免编译和排版中的常见陷阱，专注于论文内容本身。

## 许可证

本项目采用 [MIT License](./LICENSE)。原始 NEU-Thesis 模板采用 [Apache 2.0 License](https://github.com/sci-m-wang/NEU-Thesis/blob/main/LICENSE)。

## 作者

GitHub: [@cghggchg765-create](https://github.com/cghggchg765-create)

---

*若本 Skill 帮助到了你的论文写作，欢迎 Star ⭐ 或提交 Issue 分享你的使用经验！*