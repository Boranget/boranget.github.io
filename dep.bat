@echo off
:: 设置命令行编码为UTF-8，解决中文乱码
chcp 65001 >nul 2>&1

:: 判断用户是否输入了提交信息，若无则使用默认值
if "%1"=="" (
    set "commit_msg=[UPDATE]"
) else (
    set "commit_msg=%1"
)

:: 先拉取远程最新代码，避免冲突
echo 正在拉取远程仓库最新更新...
git pull origin master

:: Git提交流程
echo 正在提交本地更改...
git add .
git commit -m"%commit_msg%"
git push origin master

echo 操作完成！
pause