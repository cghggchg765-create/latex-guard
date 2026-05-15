# LaTeX Guard — LaTeX 编译防错与排版质量守护

[![GitHub stars](https://img.shields.io/github/stars/cghggchg765-create/latex-guard)](https://github.com/cghggchg765-create/latex-guard)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Skill Type](https://img.shields.io/badge/type-OpenCode%20Skill-6e45c2)](https://github.com/cghggchg765-create/latex-guard)

面向 OpenCode 等 AI 编程助手的智能技能，提供 LaTeX 论文全流程编译防错与排版质量保障。

## 适用场景

- 中英文学位论文（硕/博）
- 学术期刊论文投稿
- LaTeX 模板开发与调试
- 团队编译规范检查

## 核心能力

| 能力 | 说明 |
|------|------|
| 🔍 编译错误诊断 | 7 类常见错误的快速诊断与修复 |
| 📊 表格排版规范 | 标准模板、列宽控制、脚注嵌入 |
| 🎯 12 类排版检测 | 封面到参考文献逐项质量清单 |
| ⚡ 一键扫描 | PowerShell 5 步批量扫描 |
| 🔄 自我完善 | 自动累积新错误模式与方案 |

## 安装

```bash
git clone https://github.com/cghggchg765-create/latex-guard.git ~/.agents/skills/latex-guard
```

或手动下载所有文件到 `~\.agents\skills\latex-guard\`，重启 OpenCode 即可。

## 触发关键词

"编译论文" / "LaTeX报错" / "表格溢出" / "xelatex" / "bibtex" / "Extra alignment" / "Overfull" / "Float too large"

## 文件结构

```
latex-guard/
├── SKILL.md              # 技能定义（核心）
├── README.md
├── LICENSE               # MIT
└── scripts/
    ├── sync_and_push.ps1
    └── register_task.ps1
```

## 许可证

[MIT License](LICENSE)

## 作者

GitHub: [@cghggchg765-create](https://github.com/cghggchg765-create)
