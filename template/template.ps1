$title = Read-Host "Please enter article name"

if ($title -eq "") {
    Write-Host "Error: Article name cannot be empty!"
    exit 1
}

# 修改路径，将目录创建在 _posts 下
$postsPath = Join-Path $PSScriptRoot "..\_posts"
$directoryPath = Join-Path $postsPath $title

if (!(Test-Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath -Force | Out-Null
    Write-Host "Directory created: $directoryPath"
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$template = Get-Content -Path ".\template_base.md" -Raw -Encoding UTF8

$content = $template.Replace("{TITLE}", $title).Replace("{TIME}", $timestamp)

$filePath = Join-Path $directoryPath "$title.md"

# 创建 UTF8 编码对象（无 BOM）
$utf8WithoutBom = New-Object System.Text.UTF8Encoding $false
[IO.File]::WriteAllText($filePath, $content, $utf8WithoutBom)

Write-Host "File created: $filePath"
Write-Host "Complete!"