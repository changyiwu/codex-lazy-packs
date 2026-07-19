[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$DestinationRoot = (Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex\skills'),

    [ValidateSet('Prompt', 'Keep', 'BackupAndUpdate', 'ManualMerge')]
    [string]$ExistingAction = 'Prompt'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$SkillNames = @('startup-sync', 'shutdown-sync', 'project-init-sync')
$TemplateRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\assets\global-skills')).Path

function Get-TemplatePaths {
    param([Parameter(Mandatory)][string]$SkillName)

    $SkillRoot = Join-Path $TemplateRoot $SkillName
    return [ordered]@{
        Skill = Join-Path $SkillRoot 'SKILL.template.md'
        Ui    = Join-Path $SkillRoot 'agents\openai.template.yaml'
    }
}

function Get-DestinationPaths {
    param([Parameter(Mandatory)][string]$SkillName)

    $SkillRoot = Join-Path $DestinationRoot $SkillName
    return [ordered]@{
        Root  = $SkillRoot
        Skill = Join-Path $SkillRoot 'SKILL.md'
        Ui    = Join-Path $SkillRoot 'agents\openai.yaml'
    }
}

function Test-ManagedFilesMatch {
    param(
        [Parameter(Mandatory)]$TemplatePaths,
        [Parameter(Mandatory)]$DestinationPaths
    )

    foreach ($Key in @('Skill', 'Ui')) {
        if (-not (Test-Path -LiteralPath $DestinationPaths[$Key] -PathType Leaf)) {
            return $false
        }
        $SourceHash = (Get-FileHash -LiteralPath $TemplatePaths[$Key] -Algorithm SHA256).Hash
        $TargetHash = (Get-FileHash -LiteralPath $DestinationPaths[$Key] -Algorithm SHA256).Hash
        if ($SourceHash -ne $TargetHash) {
            return $false
        }
    }
    return $true
}

function Copy-ManagedFiles {
    param(
        [Parameter(Mandatory)]$TemplatePaths,
        [Parameter(Mandatory)]$DestinationPaths
    )

    $null = New-Item -ItemType Directory -Path $DestinationPaths.Root -Force
    $null = New-Item -ItemType Directory -Path (Split-Path -Parent $DestinationPaths.Ui) -Force
    Copy-Item -LiteralPath $TemplatePaths.Skill -Destination $DestinationPaths.Skill -Force
    Copy-Item -LiteralPath $TemplatePaths.Ui -Destination $DestinationPaths.Ui -Force
}

function Get-BackupPath {
    param([Parameter(Mandatory)][string]$DestinationSkillRoot)

    $Timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $Candidate = "$DestinationSkillRoot.backup-$Timestamp"
    $Counter = 1
    while (Test-Path -LiteralPath $Candidate) {
        $Candidate = "$DestinationSkillRoot.backup-$Timestamp-$Counter"
        $Counter++
    }
    return $Candidate
}

foreach ($SkillName in $SkillNames) {
    $TemplatePaths = Get-TemplatePaths -SkillName $SkillName
    $DestinationPaths = Get-DestinationPaths -SkillName $SkillName

    foreach ($TemplatePath in $TemplatePaths.Values) {
        if (-not (Test-Path -LiteralPath $TemplatePath -PathType Leaf)) {
            throw "缺少工作 Skill 範本：$TemplatePath"
        }
    }

    if (-not (Test-Path -LiteralPath $DestinationPaths.Root)) {
        if ($PSCmdlet.ShouldProcess($DestinationPaths.Root, "安裝 $SkillName")) {
            Copy-ManagedFiles -TemplatePaths $TemplatePaths -DestinationPaths $DestinationPaths
            if (-not (Test-ManagedFilesMatch -TemplatePaths $TemplatePaths -DestinationPaths $DestinationPaths)) {
                throw "$SkillName 安裝後驗證失敗。"
            }
            [pscustomobject]@{
                Skill       = $SkillName
                Result      = 'Installed'
                Destination = $DestinationPaths.Root
                Backup      = $null
            }
        }
        continue
    }

    if (-not (Test-Path -LiteralPath $DestinationPaths.Root -PathType Container)) {
        throw "目標路徑存在但不是資料夾：$($DestinationPaths.Root)"
    }

    if (Test-ManagedFilesMatch -TemplatePaths $TemplatePaths -DestinationPaths $DestinationPaths) {
        [pscustomobject]@{
            Skill       = $SkillName
            Result      = 'Current'
            Destination = $DestinationPaths.Root
            Backup      = $null
        }
        continue
    }

    $Action = $ExistingAction
    if ($Action -eq 'Prompt') {
        while ($true) {
            $Choice = Read-Host "[$SkillName] 已存在且內容不同。選擇 [K]保留、[B]備份後更新、[M]手動合併、[Q]停止"
            switch ($Choice.Trim().ToUpperInvariant()) {
                'K' { $Action = 'Keep'; break }
                'B' { $Action = 'BackupAndUpdate'; break }
                'M' { $Action = 'ManualMerge'; break }
                'Q' { throw '使用者停止安裝。' }
                default { Write-Warning '請輸入 K、B、M 或 Q。'; continue }
            }
            break
        }
    }

    if ($Action -eq 'Keep') {
        [pscustomobject]@{
            Skill       = $SkillName
            Result      = 'Kept'
            Destination = $DestinationPaths.Root
            Backup      = $null
        }
        continue
    }

    if ($Action -eq 'ManualMerge') {
        [pscustomobject]@{
            Skill       = $SkillName
            Result      = 'ManualMergeRequired'
            Destination = $DestinationPaths.Root
            Backup      = $null
        }
        continue
    }

    $BackupPath = Get-BackupPath -DestinationSkillRoot $DestinationPaths.Root
    if ($PSCmdlet.ShouldProcess($DestinationPaths.Root, "備份至 $BackupPath 後更新 $SkillName")) {
        Copy-Item -LiteralPath $DestinationPaths.Root -Destination $BackupPath -Recurse
        Copy-ManagedFiles -TemplatePaths $TemplatePaths -DestinationPaths $DestinationPaths
        if (-not (Test-ManagedFilesMatch -TemplatePaths $TemplatePaths -DestinationPaths $DestinationPaths)) {
            throw "$SkillName 更新後驗證失敗；備份保留於 $BackupPath。"
        }
        [pscustomobject]@{
            Skill       = $SkillName
            Result      = 'Updated'
            Destination = $DestinationPaths.Root
            Backup      = $BackupPath
        }
    }
}
