# Windows 版 Codex 桌面能力补全工具包

<img src="assets/readme/codex-windows-toolkit-hero-v2.png" alt="项目总览图" style="width:100%; height:auto;" />

英文版： [README.en.md](README.en.md)

这个仓库把 Windows 版 Codex 桌面能力补全经验整理成一个可发布、可审计、可复用的工程项目。它提供脱敏配置模板、验证脚本、运行手册和长任务状态文件，让 Browser、Chrome 插件、Computer Use、MCP 与 `/goal` fallback 可以在 Windows 上更稳定地协同工作。

## 背景

在 Windows 环境里，Codex Desktop 的能力是否完整可用，常常取决于多个条件同时成立：插件是否启用、Node 和 Python 是否可被找到、MCP server 是否能启动、Browser helper 是否能被解析、Computer Use 是否有正确的桌面权限、`/goal` 能力是否在当前版本或账号里开放。任意一环失败，用户看到的就是“接口缺失”或“功能不可用”。

本项目参考了 Qoder Computer Use 文章里提到的产品分层：浏览器任务优先用 Browser，必须操作原生桌面应用时才用 Computer Use；同时参考 Harness Engineering 的长任务组织方式，把目标、任务清单、进度和验证命令落到项目文件中。这样即使会话被压缩、应用重启、插件状态变化，也能从仓库文件恢复上下文。

最新同步的 Chrome 插件修复把 `node_repl` MCP 入口改为稳定启动脚本，并补齐 `NODE_REPL_NODE_PATH` 与 `NODE_REPL_TRUSTED_CODE_PATHS`。插件更新后即使运行时只保留无扩展名 `node_repl`，脚本也会自动补出 `node_repl.exe` hardlink，再启动同版本运行时，确保 Chrome 与内置 Browser 的 `browser-client.mjs` 可以拿到原生管道能力。

## 设计原则

第一，能用命令行或接口完成的事情，不走视觉自动化。文件读写、Git、脚本、配置检查、打包发布都应该由命令完成。

第二，网页和本地预览优先走 Browser。Browser 能读取 DOM、定位元素、截图和验证前端页面，比桌面坐标点击更稳定，也更省 token。

第三，Computer Use 只处理 GUI-only 场景。系统设置、原生 IDE、模拟器、Figma Desktop、Postman、Charles、Keynote 这类没有稳定命令行接口的工作，才交给 Computer Use。

第四，长任务必须有持久状态。`/goal` 不能只依赖聊天上下文，必须把 objective、任务清单、进度和恢复命令写入仓库，保证恢复和审计。

## 最新功能展示

下面这些截图来自 `images/` 目录中的最新功能状态，覆盖聊天指令、完整指令面板、内置浏览器、浏览器插件、Computer Use、设置页和解锁后的电脑控制流程。

<table>
  <tr>
    <td align="center" width="50%">
      <img src="images/聊天指令完备.png" alt="聊天指令完备" style="width:100%; height:auto;" />
      <div>聊天指令完备</div>
    </td>
    <td align="center" width="50%">
      <img src="images/指令完备2.png" alt="指令完备2" style="width:100%; height:auto;" />
      <div>指令完备2</div>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="images/内置浏览器功能完备.png" alt="内置浏览器功能完备" style="width:100%; height:auto;" />
      <div>内置浏览器功能完备</div>
    </td>
    <td align="center" width="50%">
      <img src="images/浏览器插件功能完备.png" alt="浏览器插件功能完备" style="width:100%; height:auto;" />
      <div>浏览器插件功能完备</div>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="images/电脑控制功能完备.png" alt="电脑控制功能完备" style="width:100%; height:auto;" />
      <div>电脑控制功能完备</div>
    </td>
    <td align="center" width="50%">
      <img src="images/computer-use-windows可用.png" alt="computer-use-windows可用" style="width:100%; height:auto;" />
      <div>computer-use-windows 可用</div>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="images/设置界面功能完备.png" alt="设置界面功能完备" style="width:100%; height:auto;" />
      <div>设置界面功能完备</div>
    </td>
    <td align="center" width="50%">
      <img src="images/电脑控制解锁.png" alt="电脑控制解锁" style="width:100%; height:auto;" />
      <div>电脑控制解锁</div>
    </td>
  </tr>
</table>

这些图直接对应仓库现在的功能展示状态，便于在 Typora 和 GitHub 里快速确认 Browser、Computer Use、设置页和命令面板都已经打通。

## 运行时分层

<img src="assets/readme/runtime-decision-flow.png" alt="运行时选择流程图" style="width:100%; height:auto;" />

推荐按以下顺序选择执行面：

| 层级 | 适用任务 | 本仓库资产 |
| --- | --- | --- |
| 命令行 / 接口 | 文件、Git、脚本、配置、打包、验证 | `tools/*.ps1`、`tests/run-tests.ps1` |
| Browser | 网页、本地预览、DOM 可见内容、前端验证 | `docs/browser-runtime.md` |
| Computer Use | 原生桌面应用、系统设置、跨应用 GUI 流程 | `docs/computer-use.md` |
| Goal Harness | 长任务、跨会话进度、可恢复执行 | `.codex-goals/`、`feature_list.json` |

这套分层能降低误用 Computer Use 的概率。Computer Use 很有价值，但它应该是桌面 GUI 的最后一公里，而不是所有自动化任务的默认入口。

## 长任务状态

<img src="assets/readme/goal-harness-architecture.png" alt="长任务状态图" style="width:100%; height:auto;" />

一个推荐的 Windows 版 Codex 桌面修复流程如下：

1. 先用 `init.ps1` 恢复当前任务状态。
2. 读取 `feature_list.json`，找到优先级最高且未完成的任务。
3. 如果问题属于配置或脚本，直接用 PowerShell 修复并验证。
4. 如果问题属于网页或本地预览，使用 Browser 进行 DOM 级验证。
5. 如果问题必须在桌面应用中完成，才切换到 Computer Use。
6. 每完成一个任务，只把对应 `passes` 从 `false` 改成 `true`。
7. 在 `progress.txt` 和 `.codex-goals/.../progress.md` 记录命令、结果和剩余工作。
8. 最后运行 `tests/run-tests.ps1` 和 `tools/package-release.ps1`。

## 仓库内容

```text
AGENTS.md       Codex 会话规则
CLAUDE.md       Harness Engineering 入口说明
README.md       中文说明
README.en.md    英文说明
docs/           Browser、Computer Use、Goal、Release 文档
templates/      脱敏后的 Codex 配置模板
scripts/        Chrome 插件 node_repl 启动脚本
tools/          导出、安装预检、校验和打包脚本
tests/          项目验证入口
images/         最新功能展示截图
.codex-goals/   项目内持久 goal 状态
.claude/        Harness 的 planner / generator / evaluator / hooks
```

## 快速开始

```powershell
cd C:\Users\admin\Desktop\test
powershell -NoProfile -ExecutionPolicy Bypass -File .\init.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\run-tests.ps1
```

查看当前 Codex 配置差异时，可使用导出脚本写到本地忽略目录 `artifacts/`：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\export-codex-assets.ps1
```

生成发布包：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\package-release.ps1
```

发布包会写入 `dist/`，该目录默认不进入 Git。

## 与文章对应关系

Qoder 文章强调 Computer Use 不应该只是“看截图猜坐标”，而应该围绕结构化界面信息和观察-执行-复查闭环来工作。Windows 版 Codex 桌面版当前暴露出来的工具形态不同，但工程原则可以迁移：

- Browser 负责结构化网页界面。
- Computer Use 负责必须观察桌面状态的原生 GUI。
- Harness 文件负责保存长任务状态。
- 验证脚本负责把“看起来完成”变成“可重复检查”。

对应研究记录见 `docs/research/wechat-qoder-computer-use.md`。

## 验证与发布

项目完成的最低标准是：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\run-tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\package-release.ps1
git status --short
```

其中 `tests/run-tests.ps1` 会检查：

- 必需文件是否存在。
- JSON 是否可解析。
- 中文 README 是否仍残留英文章节标题。
- 英文 README 是否存在，并且没有混入中文章节标题。
- 两个 README 是否至少引用三张本地图。
- README 图片路径是否真实存在。
- 打包脚本是否能生成 zip。

## 适合谁

这个项目适合需要在 Windows 上长期使用 Codex Desktop 的用户，尤其是已经启用多个插件、MCP server、Browser、Computer Use 和长任务工作流，但希望把修复经验整理成可发布资产的人。

它也适合作为一个模板：把个人环境里的经验转化为公共仓库时，保留结构、脚本和验证方法，使用占位配置替代本机私有值。

## 资料来源

- OpenAI Codex 官方介绍：https://openai.com/index/introducing-the-codex-app/
- OpenAI Codex 使用场景：https://developers.openai.com/codex/explore
- Qoder 微信文章：https://mp.weixin.qq.com/s/rx9yNaCJcBh9a_8dOedOlw
- 本机验证记录：`docs/research/local-sources.md`
- 生图记录：`docs/research/image-generation.md`
