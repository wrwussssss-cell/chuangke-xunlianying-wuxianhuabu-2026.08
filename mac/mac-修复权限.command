#!/bin/bash
# 修复 macOS Gatekeeper 安全限制
# 运行此脚本后，双击 .command 文件就不会再提示权限问题了

cd "$(dirname "$0")"

echo "============================================"
echo "   修复 macOS 安全限制"
echo "============================================"
echo ""

# 移除下载文件的 quarantine 属性（这是阻止运行的主要原因）
# 修正：原脚本引用了不存在的 启动服务.command/启动服务.py/mac-*.sh，
# 改为覆盖项目中实际存在的文件。
echo "正在移除安全限制..."

xattr -r -d com.apple.quarantine mac-启动服务.command 2>/dev/null
xattr -r -d com.apple.quarantine mac-修复权限.command 2>/dev/null
xattr -r -d com.apple.quarantine 安装即梦CLI.command 2>/dev/null
xattr -r -d com.apple.quarantine 登录即梦CLI.command 2>/dev/null
xattr -r -d com.apple.quarantine main.py 2>/dev/null
# 内置 Python 运行环境（Apple Silicon），清除全部扩展属性避免被拦截
xattr -cr python-mac 2>/dev/null

echo "✓ 已移除安全限制"
echo ""

# 设置执行权限
chmod +x mac-启动服务.command 2>/dev/null
chmod +x mac-修复权限.command 2>/dev/null
chmod +x 安装即梦CLI.command 2>/dev/null
chmod +x 登录即梦CLI.command 2>/dev/null
chmod +x main.py 2>/dev/null
chmod +x python-mac/bin/* 2>/dev/null

echo "✓ 已设置执行权限"
echo ""

# ---------- 恢复自定义图标 ----------
# Finder 自定义图标存放在文件的资源分支里，压缩包/网盘/U 盘传输后可能丢失。
# 只要有 创.icns 且系统带 Rez/SetFile（Xcode 命令行工具），就自动补回。
restore_icon() {
    local target="$1"
    [ -f "$target" ] || return 0
    if [ -n "$(DeRez -only icns "$target" 2>/dev/null)" ]; then
        SetFile -a C "$target" 2>/dev/null   # 已包含图标资源，仅确保 Finder 标志位
        return 0
    fi
    [ -f "创.icns" ] || return 0
    command -v Rez >/dev/null 2>&1 || return 0
    command -v DeRez >/dev/null 2>&1 || return 0
    command -v SetFile >/dev/null 2>&1 || return 0

    local tmp; tmp="$(mktemp -d 2>/dev/null)" || return 0
    cp "创.icns" "$tmp/icon.icns" 2>/dev/null || { rm -rf "$tmp"; return 0; }
    sips -i "$tmp/icon.icns" >/dev/null 2>&1
    DeRez -only icns "$tmp/icon.icns" > "$tmp/icon.rsrc" 2>/dev/null
    if [ -s "$tmp/icon.rsrc" ] && Rez -append "$tmp/icon.rsrc" -o "$target" >/dev/null 2>&1; then
        SetFile -a C "$target" 2>/dev/null
        echo "  ✓ 已恢复 $(basename "$target") 的自定义图标"
    fi
    rm -rf "$tmp"
}

echo "正在恢复自定义图标..."
if command -v Rez >/dev/null 2>&1 && [ -f "创.icns" ]; then
    for f in mac-*.command; do
        [ -f "$f" ] && restore_icon "$f"
    done
else
    echo "  跳过（未安装 Xcode 命令行工具或缺少 创.icns）"
fi
echo ""

echo "============================================"
echo "   修复完成！"
echo "============================================"
echo ""
echo "现在可以正常双击 'mac-启动服务.command' 了。"
echo ""
echo "如果仍然提示权限问题，请到："
echo "系统设置 → 隐私与安全性 → 点击'仍要打开'"
echo ""
echo "提示：完整图文步骤见「Mac版启动说明.html」（双击用浏览器打开）"
echo ""
read -p "按 Enter 键退出..."
