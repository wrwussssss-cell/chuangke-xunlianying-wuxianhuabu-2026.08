#!/bin/bash
# 无限画布 · macOS 一键启动（仅支持 Apple Silicon / arm64）
# 内置 Python 3.12 与全部第三方依赖，无需联网、无需安装任何库
# 双击运行即可

cd "$(dirname "$0")" || exit 1
APP_DIR="$(pwd)"

echo "============================================"
echo "   无限画布 · 启动服务 (Apple Silicon)"
echo "============================================"
echo ""

# ---------- 1. 芯片架构检查 ----------
ARCH="$(uname -m)"
if [ "$ARCH" != "arm64" ]; then
    echo "✗ 检测到当前架构为：$ARCH"
    echo "  本文件夹内置的是 arm64（Apple 芯片）版本，"
    echo "  请在 M1 / M2 / M3 / M4 等 Apple 芯片的 Mac 上运行。"
    echo ""
    read -n 1 -s -r -p "按任意键退出..."
    exit 1
fi

# ---------- 2. 修复权限与安全隔离属性 ----------
echo "正在修复权限..."
# 清除 Gatekeeper 隔离属性（拷贝到新 Mac 后可能被重新打上）
xattr -cr "$APP_DIR/python-mac" 2>/dev/null
xattr -d com.apple.quarantine "$APP_DIR/main.py" 2>/dev/null
xattr -d com.apple.quarantine "$APP_DIR"/mac-*.command 2>/dev/null
# 设置执行权限（U 盘 / 网盘传输后可能丢失）
chmod +x "$APP_DIR"/*.command 2>/dev/null
chmod +x "$APP_DIR/main.py" 2>/dev/null
chmod +x "$APP_DIR"/python-mac/bin/* 2>/dev/null
echo "权限已修复！"
echo ""

# ---------- 3. 定位内置 Python（优先，无需安装依赖） ----------
PY=""
# 兼容网盘 / 压缩包传输后符号链接丢失的情况，依次尝试真实文件名
for cand in "$APP_DIR/python-mac/bin/python3" "$APP_DIR/python-mac/bin/python3.12" "$APP_DIR/python-mac/bin/python"; do
    if [ -x "$cand" ] && "$cand" -c "pass" >/dev/null 2>&1; then
        PY="$cand"
        break
    fi
done
if [ -n "$PY" ]; then
    echo "使用内置 Python 运行环境（无需安装依赖库）"
else
    echo "⚠ 未找到内置 Python 运行环境 python-mac/，尝试使用系统 Python..."
    if [ -x /opt/homebrew/bin/python3 ]; then
        PY=/opt/homebrew/bin/python3
    elif command -v python3 >/dev/null 2>&1; then
        PY="$(command -v python3)"
    else
        echo ""
        echo "✗ 找不到可用的 Python3。"
        echo "  请确认本文件夹完整解压（应包含 python-mac 文件夹），"
        echo "  或安装 Python 3.10+：https://www.python.org/downloads/"
        echo ""
        read -n 1 -s -r -p "按任意键退出..."
        exit 1
    fi
fi

# 快速自检：依赖是否就绪
if ! "$PY" -c "import fastapi, uvicorn, httpx, requests, PIL, pydantic, multipart" >/dev/null 2>&1; then
    echo ""
    echo "⚠ 依赖自检未通过，内置环境可能不完整（文件损坏或被安全软件删除）。"
    echo "  仍尝试继续启动..."
    echo ""
fi

# 隔离用户目录下的同名包，避免与本机已装的库互相干扰
export PYTHONNOUSERSITE=1
export PYTHONUNBUFFERED=1

# ---------- 4. 清理占用 3000 端口的旧进程 ----------
OLD_PID=$(lsof -ti :3000 2>/dev/null)
if [ -n "$OLD_PID" ]; then
    echo "检测到 3000 端口被占用，正在停止旧进程 (PID: $OLD_PID)..."
    kill $OLD_PID 2>/dev/null
    sleep 1
    if lsof -ti :3000 >/dev/null 2>&1; then
        kill -9 $(lsof -ti :3000) 2>/dev/null
    fi
    echo "旧进程已停止。"
    echo ""
fi

# ---------- 5. 局域网地址 ----------
LAN_IP="$(ipconfig getifaddr en0 2>/dev/null)"
[ -z "$LAN_IP" ] && LAN_IP="$(ipconfig getifaddr en1 2>/dev/null)"

echo "正在启动服务（就绪后会自动打开浏览器）..."
echo "本机访问： http://127.0.0.1:3000/"
if [ -n "$LAN_IP" ]; then
    echo "局域网访问： http://$LAN_IP:3000/"
fi
echo "提示：图文步骤见「Mac版启动说明.html」（双击打开）"
echo "============================================"
echo ""

# ---------- 6. 后台等待端口就绪，然后自动打开浏览器 ----------
# 轮询本机 3000 端口（最多约 30 秒），避免服务启动慢时打开一个空白错误页
open_browser_when_ready() {
    local tries=0
    while [ "$tries" -lt 60 ]; do
        if curl -s --max-time 1 -o /dev/null "http://127.0.0.1:3000/" 2>/dev/null; then
            open "http://127.0.0.1:3000/" 2>/dev/null
            return 0
        fi
        sleep 0.5
        tries=$((tries + 1))
    done
}

OPEN_WAITER_PID=""
# 如需禁止自动打开浏览器，可在终端里用 NO_BROWSER=1 ./mac-启动服务.command 启动
if [ "${NO_BROWSER:-0}" != "1" ]; then
    open_browser_when_ready &
    OPEN_WAITER_PID=$!
fi

# ---------- 7. 启动 ----------
"$PY" main.py

# 服务退出后，停止尚未完成的浏览器等待任务
if [ -n "$OPEN_WAITER_PID" ]; then
    kill "$OPEN_WAITER_PID" 2>/dev/null
fi

echo ""
echo "服务已停止。按 Enter 键关闭窗口..."
read -r _ || true
