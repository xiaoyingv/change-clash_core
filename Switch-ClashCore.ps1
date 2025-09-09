# Switch-ClashCore.ps1
# 用于切换 Clash for Windows 的内核（支持多个内核）
# 日期：2025

# ========== 配置区 ==========
# 注意：CFW_Path 路径请替换成你安装的目录
$CFW_Path = "C:\Clash for Windows\Clash for Windows.exe"
$ConfigDir = "$env:USERPROFILE\.config\clash"
$StateFile = "$ConfigDir\core_state.txt"
$MihomoConfigLink = "$env:USERPROFILE\.config\mihomo"
$CoreTemplateDir = "teamp_core"  # 内核模板文件夹
# ============================

# 内核定义
$AvailableCores = @{
    "1" = @{
        Name = "Premium"
        FileName = "premium.exe"
        DisplayName = "Clash Premium (原版)"
    }
    "2" = @{
        Name = "ClashMeta"
        FileName = "clash_meta.exe"
        DisplayName = "Clash Meta"
    }
    "3" = @{
        Name = "Mihomo"
        FileName = "mihomo.exe"
        DisplayName = "Mihomo (最新版内核)"
    }
}

Write-Host "🚀 Clash 内核切换器 - 正在执行..." -ForegroundColor Cyan

# 检查主程序是否存在
if (-not (Test-Path $CFW_Path)) {
    Write-Error "❌ 未找到 Clash for Windows 主程序！请检查路径：$CFW_Path"
    pause
    exit 1
}

# 初始化内核模板文件夹
if (-not (Test-Path $CoreTemplateDir)) {
    New-Item -ItemType Directory -Path $CoreTemplateDir -Force | Out-Null
    Write-Host "✅ 已创建内核模板文件夹: $CoreTemplateDir" -ForegroundColor Green
    Write-Host "请将以下内核文件放入 $CoreTemplateDir 文件夹中:" -ForegroundColor Yellow
    Write-Host "  - premium.exe (Clash Premium)" -ForegroundColor Yellow
    Write-Host "  - clash_meta.exe (Clash Meta)" -ForegroundColor Yellow
    Write-Host "  - mihomo.exe (Mihomo)" -ForegroundColor Yellow
    Write-Host ""
}

# 检查内核模板文件夹中的内核文件
foreach ($core in $AvailableCores.Values) {
    $corePath = Join-Path $CoreTemplateDir $core.FileName
    if (-not (Test-Path $corePath)) {
        Write-Host "⚠️  未找到内核文件: $($core.FileName)" -ForegroundColor Yellow
    }
}

# 读取当前内核状态
$CurrentCore = "Premium"  # 默认值
if (Test-Path $StateFile) {
    try {
        $content = Get-Content $StateFile -ErrorAction Stop
        if ($content -match "current_core=(.+)") {
            $CurrentCore = $matches[1].Trim()
        } else {
            Write-Host "⚠️  状态文件格式不正确，使用默认内核: Premium" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️  读取状态文件失败，使用默认内核: Premium" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  状态文件不存在，使用默认内核: Premium" -ForegroundColor Yellow
    # 创建初始状态文件
    Set-Content -Path $StateFile -Value "current_core=Premium" -Force
}

# 显示当前内核
Write-Host "`n当前使用的内核: $CurrentCore" -ForegroundColor Cyan

# 显示菜单
Write-Host "`n请选择要切换的内核:" -ForegroundColor Yellow
foreach ($key in $AvailableCores.Keys | Sort-Object) {
    $core = $AvailableCores[$key]
    $indicator = if ($core.Name -eq $CurrentCore) { "← 当前使用" } else { "" }
    Write-Host "$key. $($core.DisplayName) $indicator" -ForegroundColor White
}

# 获取用户选择
$selection = Read-Host "`n请输入选项数字 (1-3)"
if (-not $AvailableCores.ContainsKey($selection)) {
    Write-Host "❌ 无效的选择!" -ForegroundColor Red
    pause
    exit 1
}

$selectedCore = $AvailableCores[$selection]
if ($selectedCore.Name -eq $CurrentCore) {
    Write-Host "✅ 已经是 $($selectedCore.DisplayName) 内核，无需切换" -ForegroundColor Green
    pause
    exit 0
}

# 杀掉 Clash 进程（静默）
$process = Get-Process -Name "Clash for Windows" -ErrorAction SilentlyContinue
if ($process) {
    Stop-Process -Name "Clash for Windows" -Force
    Write-Host "✅ 已终止 Clash for Windows 进程" -ForegroundColor Green
    Start-Sleep -Seconds 2  # 等待进程完全退出
} else {
    Write-Host "⚠️ 未检测到正在运行的 Clash 进程" -ForegroundColor Yellow
}

# 复制选定的内核文件到当前目录
$sourceCore = Join-Path $CoreTemplateDir $selectedCore.FileName
$targetCore = "clash-win64.exe"  # Clash for Windows 默认加载的内核文件名

if (-not (Test-Path $sourceCore)) {
    Write-Error "❌ 未找到选定的内核文件: $sourceCore"
    Write-Host "请将 $($selectedCore.FileName) 放入 $CoreTemplateDir 文件夹中" -ForegroundColor Red
    pause
    exit 1
}

try {
    Copy-Item -Path $sourceCore -Destination $targetCore -Force
    Write-Host "✅ 已复制 $($selectedCore.FileName) 为 $targetCore" -ForegroundColor Green
} catch {
    Write-Error "❌ 复制内核文件失败：$($_.Exception.Message)"
    pause
    exit 1
}

# 处理符号链接（仅 Mihomo 内核需要）
if ($selectedCore.Name -eq "Mihomo") {
    # 删除旧符号链接（如果存在）
    if (Test-Path $MihomoConfigLink -PathType Container) {
        Remove-Item $MihomoConfigLink -Recurse -Force -ErrorAction SilentlyContinue
    }

    # 检查 Clash 配置是否存在
    if (-not (Test-Path "$ConfigDir\config.yaml")) {
        Write-Error "❌ 未找到配置文件！请先运行一次 Clash for Windows 生成配置。"
        pause
        exit 1
    }

    # 创建符号链接（使用原始脚本的方法）
    Write-Host "✅ 正在为 Mihomo 内核创建符号链接..." -ForegroundColor Green
    Start-Process -FilePath "cmd" -ArgumentList "/c mklink /D `"$MihomoConfigLink`" `"$ConfigDir`"" -Verb RunAs -Wait -WindowStyle Hidden

    # 验证符号链接
    if (-not (Test-Path "$MihomoConfigLink\config.yaml")) {
        Write-Error "❌ 符号链接创建失败！请手动以管理员身份运行 CMD 并执行："
        Write-Host "mklink /D `"$MihomoConfigLink`" `"$ConfigDir`"" -ForegroundColor Red
        pause
        exit 1
    } else {
        Write-Host "✅ 符号链接创建成功，配置已关联！" -ForegroundColor Green
    }
} else {
    # 如果不是 Mihomo 内核，删除符号链接（如果存在）
    if (Test-Path $MihomoConfigLink -PathType Container) {
        Remove-Item $MihomoConfigLink -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "✅ 已删除 Mihomo 符号链接" -ForegroundColor Green
    }
}

# 更新状态文件
Set-Content -Path $StateFile -Value "current_core=$($selectedCore.Name)" -Force
Write-Host "🎉 已切换到 $($selectedCore.DisplayName) 内核！" -ForegroundColor Green

# 启动 Clash for Windows
Write-Host "✅ 正在启动 Clash for Windows..." -ForegroundColor Green
Start-Process -FilePath $CFW_Path

Write-Host ""
Write-Host "🎊 内核切换已完成！" -ForegroundColor Magenta
Write-Host "当前内核: $($selectedCore.DisplayName)" -ForegroundColor Cyan
pause