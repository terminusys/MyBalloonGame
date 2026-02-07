@echo off
chcp 65001 > nul
echo ========================================
echo 🎈 热气球游戏 - 一键发布到公网
echo ========================================
echo.
echo 正在发布到 Surge.sh...
echo.

cd /d "%~dp0"

surge --domain my-balloon-game-%random%.surge.sh

echo.
echo ========================================
echo ✅ 发布完成！
echo.
echo 📋 复制上面的链接分享给朋友吧！
echo.
echo 提示：
echo - 手机和电脑都可以访问
echo - 支持多人实时同步
echo - 永久免费托管
echo ========================================
echo.
pause
