# 无限画布 · macOS 一键启动（Apple Silicon / arm64）

## 快速开始

1. 把整个文件夹拷贝到 Mac 上（U 盘、隔空投送、网盘均可），**整个文件夹**一起拷贝，不要只拷 `main.py`。
2. **首次使用**：右键点击 `mac-启动服务.command` → 选择「打开」→ 再点「打开」（绕过安全警告）
3. **之后使用**：直接双击 `mac-启动服务.command` 即可

服务启动后会自动在浏览器打开 http://127.0.0.1:3000/（约 2～5 秒，等端口就绪后打开；没弹出来就手动访问该地址）。

## 内置运行环境（重点）

本文件夹已内置 **Python 3.12 + 全部第三方依赖**，位于 `python-mac/` 目录：

```
python-mac/
├── bin/python3            内置 Python 解释器（arm64）
└── lib/python3.12/site-packages/
    ├── fastapi、starlette、uvicorn
    ├── pydantic、pydantic_core
    ├── httpx、httpcore、h11、anyio、certifi
    ├── requests、urllib3、idna、charset_normalizer
    ├── pillow（PIL）
    ├── python-multipart（表单 / 文件上传）
    ├── websockets、httptools、watchfiles（WebSocket 与热重载）
    └── python-dotenv、pyyaml
```

因此：

- **不需要安装 Python**（不依赖系统自带的 `/usr/bin/python3`，也不依赖 Homebrew）
- **不需要 `pip install` 任何依赖**，启动过程无需联网
- 换一台 Apple 芯片 Mac 时，只要整个文件夹拷过去，双击就能启动

> 依赖版本与项目自带的 Windows 运行环境（`python/`）保持一致，对齐已验证可用的组合。

## 系统要求

| 项目 | 要求 |
|------|------|
| 芯片 | **仅支持 arm64（Apple Silicon：M1 / M2 / M3 / M4…）** |
| 系统 | macOS 11 Big Sur 或更高版本 |
| 架构不符 | Intel Mac 上脚本会提示「当前架构为 x86_64」并退出 |

## 文件说明

| 文件 | 说明 |
|------|------|
| `Mac版启动说明.html` | **图文版启动说明**（含安全拦截、权限修复的截图步骤，双击用浏览器打开） |
| `mac-一键修复.command` | **一键体检 + 自动修复**（架构、目录权限、文件完整性、执行权限、隔离属性、依赖、图标、端口），推荐遇到问题时先跑这个 |
| `mac-启动服务.command` | 双击启动（自动修权限、用内置 Python 启动、清理 3000 端口旧进程），图标为「创」 |
| `python-mac/` | 内置 Python 3.12 + 全部依赖（约 114 MB，请勿删除） |
| `mac-修复权限.command` | 轻量修复：执行权限 + 隔离属性 + 图标 |
| `创.icns` | 「创」图标源文件（自定义图标丢失时用于恢复） |
| `main.py` | 服务主程序 |
| `安装即梦CLI.command` | 安装/更新 dreamina CLI |
| `登录即梦CLI.command` | 登录 dreamina CLI |

> 被系统拦截、或提示「没有正确的访问权限」时，直接双击 `Mac版启动说明.html`，按图文步骤操作即可。

## 一键修复（推荐先试）

双击 `mac-一键修复.command`，会自动逐项检查并修复：

| # | 检查项 | 处理方式 |
|---|--------|----------|
| 1 | 芯片架构 | 非 arm64 时明确提示（Intel Mac 不支持） |
| 2 | 文件夹位置 | 测试目录可写；放在只读 DMG / 受限路径时提示先拷贝到本机 |
| 3 | 文件完整性 | 检查 `main.py`、`VERSION`、`static/`、`python-mac/`、`创.icns` |
| 4 | 执行权限 | 自动 `chmod +x` 脚本与内置 Python |
| 5 | 隔离属性 | 递归清除 `python-mac/` 的 `com.apple.quarantine`，并报告残留 |
| 6 | 运行环境与依赖 | 运行内置 Python、导入全部依赖、编译校验 `main.py` |
| 7 | 自定义图标 | 从 `创.icns` 恢复 `mac-*.command` 的「创」图标（幂等） |
| 8 | 3000 端口 | 结束占用进程并确认端口释放 |

最后输出「✓ 正常 / ⚠ 提醒 / ✗ 失败」统计与「本次自动修复」清单。脚本只改权限、扩展属性和图标，不联网、不碰画布数据。

## 脚本图标说明

`mac-启动服务.command` / `mac-修复权限.command` / `mac-一键修复.command` 都已设置 Finder 自定义图标（「创」图案）。macOS 的自定义图标保存在文件的**资源分支**里，以下情况可能丢失并显示为终端图标（不影响使用）：

- 上传到 GitHub / 网页网盘后重新下载
- 在 Windows 上解压/重新压缩
- 用文本编辑器另存覆盖了脚本

恢复方法：双击 `mac-一键修复.command` 或 `mac-修复权限.command`（会自动从 `创.icns` 重新写入图标，幂等，多跑几次也只保留一份）。也可在终端手动执行：

```bash
cd /你的路径/画布文件夹
./mac-修复权限.command
```

## 常见问题

### 1. 提示「无法打开，因为无法验证开发者」

右键点击 `mac-启动服务.command` → 选择「打开」→ 再点「打开」。

或：系统设置 → 隐私与安全性 → 安全性 → 点击「仍要打开」。

仍然不行时，双击 `mac-修复权限.command`，它会递归清除 `python-mac/` 的隔离属性（`com.apple.quarantine`）——这是拷贝后无法运行的最常见原因。

### 2. 双击后窗口一闪就消失

在「终端」里手动运行，看具体报错：

```bash
cd /你的路径/画布文件夹
./mac-启动服务.command
```

### 3. 提示「当前架构为 x86_64」

本文件夹只内置了 arm64 版本。Intel Mac 请改用其它版本，或自行安装 Python 3.10+ 后运行 `python3 main.py`。

### 4. 端口 3000 被占用

启动脚本会自动结束占用 3000 端口的旧进程，无需手动处理。

### 5. 提示「依赖自检未通过」

说明 `python-mac/` 不完整（拷贝中断、被安全软件清理、解压时丢文件）。重新完整拷贝整个文件夹即可，不需要去装系统 Python 的依赖。

## 手动控制

### 启动服务（使用内置环境）

```bash
cd /你的路径/画布文件夹
./python-mac/bin/python3 main.py
```

### 不希望自动打开浏览器

```bash
NO_BROWSER=1 ./mac-启动服务.command
```

### 停止服务

在启动窗口按 `Ctrl+C`，或直接关闭终端窗口。

### 迁移到另一台 Mac

直接拷贝整个文件夹即可；如被系统拦截，双击 `mac-修复权限.command` 后再启动。

## 访问服务

- 本机访问：http://127.0.0.1:3000/
- 局域网访问：http://你的IP:3000/（启动时会显示）
