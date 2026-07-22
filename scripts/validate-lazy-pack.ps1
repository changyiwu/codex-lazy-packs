[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$Failures = [System.Collections.Generic.List[string]]::new()
$LegacyUserSkillPathPatterns = @(
    '(?i)\.codex[\\/]skills(?![\\/]\.system(?=$|[\\/]|[^A-Za-z0-9._-]))',
    '(?i)dot_codex[\\/]skills'
)

function Add-Failure {
    param([Parameter(Mandatory)][string]$Message)
    $Failures.Add($Message)
}

function Get-RepoRelativePath {
    param([Parameter(Mandatory)][string]$Path)
    if ($Path.StartsWith($Root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $Path.Substring($Root.Length).TrimStart('\', '/')
    }
    return $Path
}

$ChapterFiles = Get-ChildItem -LiteralPath $Root -File -Filter '*.md' |
    Where-Object { $_.Name -match '^(?<number>\d+(?:\.\d+)?)-' }

$DuplicateNumbers = $ChapterFiles |
    Group-Object { [regex]::Match($_.Name, '^(\d+(?:\.\d+)?)-').Groups[1].Value } |
    Where-Object Count -gt 1

foreach ($Group in $DuplicateNumbers) {
    Add-Failure "章號重複：$($Group.Name) -> $($Group.Group.Name -join ', ')"
}

$TextExtensions = @('.md', '.yaml', '.yml', '.toml', '.ps1')
$TextFiles = Get-ChildItem -LiteralPath $Root -Recurse -File |
    Where-Object {
        $_.Extension -in $TextExtensions -and
        $_.FullName -notmatch '[\\/]\.git[\\/]'
    }

foreach ($File in $TextFiles) {
    $Content = Get-Content -Raw -Encoding utf8 -LiteralPath $File.FullName
    $Relative = Get-RepoRelativePath $File.FullName

    if ($Content.Contains([char]0xfffd)) {
        Add-Failure "發現 Unicode 取代字元：$Relative"
    }

    if ($Content -match 'OpenJS\.NodeJS(?!\.LTS)') {
        Add-Failure "發現非 LTS Node.js 安裝指令：$Relative"
    }

    if ($LegacyUserSkillPathPatterns | Where-Object { $Content -match $_ }) {
        Add-Failure "發現舊的使用者 Skill 路徑，請改用 ~/.agents/skills；~/.codex/skills/.system 僅供 Codex 隨附的系統 Skill：$Relative"
    }

    if ($File.Extension -eq '.md') {
        foreach ($Match in [regex]::Matches($Content, '\[[^\]]*\]\((?<target>[^)]+\.md)(?:#[^)]*)?\)')) {
            $Target = $Match.Groups['target'].Value.Trim('<', '>')
            if ($Target -match '^(?:https?://|mailto:|/)') {
                continue
            }
            $DecodedTarget = [uri]::UnescapeDataString($Target)
            $ResolvedTarget = Join-Path $File.DirectoryName $DecodedTarget
            if (-not (Test-Path -LiteralPath $ResolvedTarget)) {
                Add-Failure "失效的 Markdown 連結：$Relative -> $Target"
            }
        }
    }
}

$SkillFiles = Get-ChildItem -LiteralPath (Join-Path $Root 'skills') -Recurse -File -Filter 'SKILL.md'
$SkillNames = [System.Collections.Generic.List[string]]::new()
foreach ($SkillFile in $SkillFiles) {
    $Content = Get-Content -Raw -Encoding utf8 -LiteralPath $SkillFile.FullName
    $Relative = Get-RepoRelativePath $SkillFile.FullName
    $Frontmatter = [regex]::Match($Content, '(?s)\A---\s*\r?\n(?<body>.*?)\r?\n---')
    if (-not $Frontmatter.Success) {
        Add-Failure "Skill 缺少有效 YAML frontmatter：$Relative"
        continue
    }

    $Body = $Frontmatter.Groups['body'].Value
    $NameMatch = [regex]::Match($Body, '(?m)^name:\s*["'']?(?<name>[a-z0-9-]+)')
    if (-not $NameMatch.Success) {
        Add-Failure "Skill 缺少合法 name：$Relative"
        continue
    }
    if ($Body -notmatch '(?m)^description:\s*\S') {
        Add-Failure "Skill 缺少 description：$Relative"
    }

    $Name = $NameMatch.Groups['name'].Value
    $SkillNames.Add($Name)
    $UiPath = Join-Path $SkillFile.DirectoryName 'agents/openai.yaml'
    if (Test-Path -LiteralPath $UiPath) {
        $Ui = Get-Content -Raw -Encoding utf8 -LiteralPath $UiPath
        if (-not $Ui.Contains('$' + $Name)) {
            Add-Failure "openai.yaml 的 default_prompt 未包含 `$$Name：$(Get-RepoRelativePath $UiPath)"
        }
    }
}

if ($SkillFiles.Count -ne 11) {
    Add-Failure "可直接安裝的 Skill 數量應為 11，實際為 $($SkillFiles.Count)"
}

foreach ($DuplicateName in ($SkillNames | Group-Object | Where-Object Count -gt 1)) {
    Add-Failure "Skill name 重複：$($DuplicateName.Name)"
}

foreach ($AssetSkillFile in ($SkillFiles | Where-Object FullName -Match '[\\/]assets[\\/]')) {
    Add-Failure "assets 內不可放置可被掃描的 SKILL.md，請改用範本檔名：$(Get-RepoRelativePath $AssetSkillFile.FullName)"
}

if ($Failures.Count -gt 0) {
    Write-Host "Validation failed with $($Failures.Count) issue(s):" -ForegroundColor Red
    foreach ($Failure in $Failures) {
        Write-Host "- $Failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Validation passed: chapter numbers, Markdown links, Skill metadata, user Skill paths, UTF-8 text, and Node.js LTS commands are valid." -ForegroundColor Green
