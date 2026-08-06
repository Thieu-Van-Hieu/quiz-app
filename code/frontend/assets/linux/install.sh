#!/bin/bash

# Kiểm tra nếu người dùng lỡ chạy bằng sudo thì cảnh báo/chuyển về USER thực sự
if [ "$EUID" -eq 0 ] && [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
    TARGET_DIR="$USER_HOME/.local/share/applications"
else
    TARGET_DIR="$HOME/.local/share/applications"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
DESKTOP_SRC="$SCRIPT_DIR/quizapp.desktop"
DESKTOP_DEST="$TARGET_DIR/quizapp.desktop"

if [ ! -f "$DESKTOP_SRC" ]; then
    echo "❌ Lỗi: Không tìm thấy file quizapp.desktop tại $SCRIPT_DIR"
    exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$DESKTOP_SRC" "$DESKTOP_DEST"

# Nếu chạy bằng sudo thì phải đổi lại chủ sở hữu file cho user thường
if [ -n "$SUDO_USER" ]; then
    chown "$SUDO_USER:$SUDO_USER" "$DESKTOP_DEST"
fi

sed -i "s|Exec=AppPath/quizapp|Exec=$SCRIPT_DIR/quizapp|g" "$DESKTOP_DEST"
sed -i "s|Icon=AppPath/logo.png|Icon=$SCRIPT_DIR/logo.png|g" "$DESKTOP_DEST"

chmod +x "$DESKTOP_DEST"
chmod +x "$SCRIPT_DIR/quizapp"

if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$TARGET_DIR" &> /dev/null
fi

echo "================================================="
echo "✅ Đã cài đặt Quiz App vào System Menu thành công!"
echo "📌 File launcher tại: $DESKTOP_DEST"
echo "================================================="