#!/bin/bash

# Xử lý lấy đường dẫn TARGET_DIR an toàn (dù chạy thường hay sudo)
if [ "$EUID" -eq 0 ] && [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
    TARGET_DIR="$USER_HOME/.local/share/applications"
else
    TARGET_DIR="$HOME/.local/share/applications"
fi

DESKTOP_DEST="$TARGET_DIR/quizapp.desktop"

echo "================================================="
echo "🗑️  Đang tiến hành gỡ bỏ Quiz App khỏi Menu..."

if [ -f "$DESKTOP_DEST" ]; then
    rm -f "$DESKTOP_DEST"
    echo "✅ Đã xóa file shortcut: $DESKTOP_DEST"
else
    echo "⚠️  Không tìm thấy shortcut ứng dụng trong $TARGET_DIR"
fi

# Làm mới database ứng dụng của Linux Desktop
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$TARGET_DIR" &> /dev/null
fi

echo "✅ Đã gỡ bỏ Quiz App khỏi Application Menu thành công!"
echo "📌 Bạn có thể xóa thư mục này nếu không còn sử dụng."
echo "================================================="