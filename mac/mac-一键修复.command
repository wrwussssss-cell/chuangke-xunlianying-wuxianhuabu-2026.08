#!/bin/bash
# 无限画布 · macOS 一键修复（仅支持 Apple Silicon / arm64）
#
# 作用：逐项体检并自动修复「拷贝到新 Mac 后」最常见的问题
#   1) 芯片架构      2) 目录可写      3) 文件完整性    4) 执行权限
#   5) 隔离属性      6) 运行环境与依赖 7) 自定义图标    8) 3000 端口占用
#
# 安全说明：只修改文件权限/扩展属性/图标，不联网、不改动画布数据。
# 双击运行即可。

cd "$(dirname "$0")" || exit 1
APP_DIR="$(pwd)"

# ---------- 输出样式 ----------
if [ -t 1 ]; then
    GRN=$'\033[32m'; YEL=$'\033[33m'; RED=$'\033[31m'; BLD=$'\033[1m'; RST=$'\033[0m'
else
    GRN=""; YEL=""; RED=""; BLD=""; RST=""
fi
OK=0; WARN=0; FAIL=0; FIXED=0
FIXED_NOTES=""
ok()      { printf '  %s✓%s %s\n' "$GRN" "$RST" "$1"; OK=$((OK+1)); }
warn()    { printf '  %s⚠%s %s\n' "$YEL" "$RST" "$1"; WARN=$((WARN+1)); }
bad()     { printf '  %s✗%s %s\n' "$RED" "$RST" "$1"; FAIL=$((FAIL+1)); }
section() { printf '\n%s%s%s\n' "$BLD" "$1" "$RST"; }

printf '%s' "$BLD"
echo "============================================"
echo "   无限画布 · 一键修复 (Apple Silicon)"
echo "============================================"
printf '%s' "$RST"
echo ""

# ======================================================================
section "1. 芯片架构"
ARCH="$(uname -m)"
if [ "$ARCH" = "arm64" ]; then
    ok "Apple Silicon (arm64) —— 与内置运行环境匹配"
else
    bad "当前架构为 $ARCH，本文件夹只内置了 arm64 版本，Intel Mac 无法使用"
fi

# ======================================================================
section "2. 文件夹位置"
if touch "$APP_DIR/.write_test" 2>/dev/null && rm -f "$APP_DIR/.write_test" 2>/dev/null; then
    ok "目录可读写：$APP_DIR"
else
    bad "目录不可写（可能在只读 DMG、共享目录或受限路径），请先把整个文件夹拷到「下载」或「桌面」"
fi

# ======================================================================
section "3. 文件完整性"
for f in main.py VERSION static python-mac 创.icns; do
    if [ -e "$f" ]; then
        ok "存在 $f"
    else
        bad "缺少 $f（请重新完整拷贝整个文件夹，不要只拷 main.py）"
    fi
done

# ======================================================================
section "4. 执行权限"
chmod +x "$APP_DIR"/*.command 2>/dev/null
chmod +x "$APP_DIR/main.py" 2>/dev/null
chmod +x "$APP_DIR"/python-mac/bin/* 2>/dev/null
if [ -x "$APP_DIR/mac-启动服务.command" ] && [ -x "$APP_DIR/python-mac/bin/python3" ]; then
    ok "启动脚本与内置 Python 均为可执行"
else
    bad "执行权限设置失败（文件可能被锁定或属于其他用户），可尝试 chmod +x *.command"
fi

# ======================================================================
section "5. Gatekeeper 隔离属性"
xattr -cr "$APP_DIR/python-mac" 2>/dev/null
for f in "$APP_DIR"/*.command "$APP_DIR/main.py"; do
    [ -e "$f" ] && xattr -d com.apple.quarantine "$f" 2>/dev/null
done
LEFT_Q=$(xattr -r -l "$APP_DIR/python-mac" 2>/dev/null | grep -c "com.apple.quarantine")
LEFT_Q=${LEFT_Q:-0}
if [ "$LEFT_Q" -eq 0 ]; then
    ok "内置环境已无 quarantine 隔离属性"
else
    warn "python-mac 中仍有 $LEFT_Q 处隔离属性（通常不影响运行；仍被拦截时到「系统设置 → 隐私与安全性」点「仍要打开」）"
fi

# ======================================================================
section "6. 运行环境与依赖"
PY="$APP_DIR/python-mac/bin/python3"
[ -x "$PY" ] || PY="$APP_DIR/python-mac/bin/python3.12"
RUNTIME_OK=0
if [ -x "$PY" ] && "$PY" -c 'pass' >/dev/null 2>&1; then
    RUNTIME_OK=1
    ok "内置 Python 可运行：$("$PY" -V 2>&1)"
else
    bad "内置 Python 无法运行（python-mac 损坏或无执行权限）"
fi

if [ "$RUNTIME_OK" -eq 1 ]; then
    if "$PY" -c 'import fastapi, uvicorn, httpx, requests, PIL, pydantic, multipart, websockets' >/dev/null 2>&1; then
        ok "依赖完整：fastapi / uvicorn / httpx / requests / pillow / pydantic / multipart / websockets"
    else
        bad "依赖缺失（python-mac 不完整），请重新完整拷贝该目录"
    fi
    if "$PY" -c 'compile(open("main.py", encoding="utf-8").read(), "main.py", "exec")' >/dev/null 2>&1; then
        ok "main.py 语法完整（未损坏）"
    else
        bad "main.py 疑似损坏或版本不匹配，请重新下载/拷贝"
    fi
fi

# ======================================================================
section "7. Finder 自定义图标"
# 自定义图标存在文件资源分支里，经 GitHub / 命令行 zip / FAT32 等传输后会丢失。
# 有 创.icns 且系统带 Rez/SetFile（Xcode 命令行工具）时自动补回。
restore_icon() {
    local target="$1"
    [ -f "$target" ] || return 1
    if [ -n "$(DeRez -only icns "$target" 2>/dev/null)" ]; then
        SetFile -a C "$target" 2>/dev/null
        return 0
    fi
    [ -f "$APP_DIR/创.icns" ] || return 1
    local tmp; tmp="$(mktemp -d 2>/dev/null)" || return 1
    cp "$APP_DIR/创.icns" "$tmp/icon.icns" 2>/dev/null || { rm -rf "$tmp"; return 1; }
    sips -i "$tmp/icon.icns" >/dev/null 2>&1
    DeRez -only icns "$tmp/icon.icns" > "$tmp/icon.rsrc" 2>/dev/null
    local rc=1
    if [ -s "$tmp/icon.rsrc" ] && Rez -append "$tmp/icon.rsrc" -o "$target" >/dev/null 2>&1; then
        SetFile -a C "$target" 2>/dev/null
        rc=0
    fi
    rm -rf "$tmp"
    return $rc
}

if ! command -v Rez >/dev/null 2>&1 || ! command -v SetFile >/dev/null 2>&1; then
    warn "未安装 Xcode 命令行工具，跳过图标修复（不影响使用）"
elif [ ! -f "$APP_DIR/创.icns" ]; then
    warn "缺少 创.icns，跳过图标修复"
else
    ICON_FIXED=0
    ICON_TOTAL=0
    for f in "$APP_DIR"/mac-*.command; do
        [ -f "$f" ] || continue
        ICON_TOTAL=$((ICON_TOTAL+1))
        if [ -z "$(DeRez -only icns "$f" 2>/dev/null)" ]; then
            restore_icon "$f" && ICON_FIXED=$((ICON_FIXED+1))
        fi
    done
    if [ "$ICON_FIXED" -eq 0 ]; then
        ok "$ICON_TOTAL 个脚本的「创」图标均正常"
    else
        ok "已为 $ICON_FIXED 个脚本恢复「创」图标（共 $ICON_TOTAL 个）"
        FIXED=$((FIXED+1))
        FIXED_NOTES="${FIXED_NOTES}图标 ×${ICON_FIXED}；"
    fi
fi

# ======================================================================
section "8. 3000 端口占用"
PORT_PIDS="$(lsof -ti :3000 2>/dev/null | tr '\n' ' ')"
if [ -z "$PORT_PIDS" ]; then
    ok "3000 端口空闲"
else
    FIRST_PID=$(echo "$PORT_PIDS" | awk '{print $1}')
    PROC_NAME=$(lsof -p "$FIRST_PID" 2>/dev/null | awk 'NR==2 {print $1}')
    warn "3000 端口被占用（PID: $PORT_PIDS 进程: ${PROC_NAME:-未知}），正在停止…"
    kill $PORT_PIDS 2>/dev/null
    sleep 1
    if lsof -ti :3000 >/dev/null 2>&1; then
        kill -9 $(lsof -ti :3000) 2>/dev/null
        sleep 1
    fi
    if lsof -ti :3000 >/dev/null 2>&1; then
        bad "端口仍未释放，请重启 Mac 或手动结束占用进程后再试"
    else
        ok "旧进程已停止，端口已释放"
        FIXED=$((FIXED+1))
        FIXED_NOTES="${FIXED_NOTES}端口占用已清理；"
    fi
fi

# ======================================================================
echo ""
printf '%s' "$BLD"
echo "============================================"
echo "   修复结果"
echo "============================================"
printf '%s' "$RST"
printf '  %s✓ 正常 %d 项%s   %s⚠ 提醒 %d 项%s   %s✗ 失败 %d 项%s\n' \
    "$GRN" "$OK" "$RST" "$YEL" "$WARN" "$RST" "$RED" "$FAIL" "$RST"
echo ""

if [ "$FAIL" -gt 0 ]; then
    echo "仍有未解决的问题，请按上面 ✗ 的提示处理；"
    echo "多数情况是文件夹拷贝不完整，重新完整拷贝整个文件夹即可。"
elif [ "$FIXED" -gt 0 ]; then
    echo "本次已自动修复：${FIXED_NOTES}"
    echo "现在可以双击「mac-启动服务.command」启动服务。"
elif [ "$WARN" -gt 0 ]; then
    echo "修复完成（有少量提醒，一般不影响使用）。"
    echo "现在可以双击「mac-启动服务.command」启动服务。"
else
    echo "全部检查通过，环境健康。"
    echo "现在可以双击「mac-启动服务.command」启动服务。"
fi

echo ""
echo "访问地址： http://127.0.0.1:3000/"
echo ""
printf '%s' "$BLD"
echo "提示：完整图文步骤（系统拦截放行、加执行权限、常见问题）请双击查看"
echo "      「Mac版启动说明.html」——会在浏览器中打开。"
printf '%s' "$RST"
echo ""
read -p "按 Enter 键退出..." || true
