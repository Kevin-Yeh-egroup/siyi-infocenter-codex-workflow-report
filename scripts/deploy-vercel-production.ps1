param(
  [string]$ProjectName = 'siyi-infocenter-codex-workflow-report',
  [string]$Scope = 'egroup-task3s-projects'
)

$ErrorActionPreference = 'Stop'

function Get-DefaultVercelTokenFile {
  $tokenFile = $env:CODEX_VERCEL_TOKEN_FILE
  if ([string]::IsNullOrWhiteSpace($tokenFile)) {
    $tokenFile = [Environment]::GetEnvironmentVariable('CODEX_VERCEL_TOKEN_FILE', 'User')
  }
  if (-not [string]::IsNullOrWhiteSpace($tokenFile)) {
    return $tokenFile
  }

  return Join-Path $env:USERPROFILE '.codex\automation-secrets\vercel-token.dpapi'
}

function Get-VercelTokenFromFile {
  $tokenFile = Get-DefaultVercelTokenFile
  if ([string]::IsNullOrWhiteSpace($tokenFile)) { return '' }
  if (-not (Test-Path -LiteralPath $tokenFile)) { return '' }

  $encryptedToken = (Get-Content -Raw -LiteralPath $tokenFile).Trim()
  if ([string]::IsNullOrWhiteSpace($encryptedToken)) { return '' }

  $secureToken = ConvertTo-SecureString $encryptedToken
  $tokenPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
  try {
    return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($tokenPointer)
  } finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($tokenPointer)
  }
}

function Test-VercelTokenShape {
  param([string]$Token)

  if ([string]::IsNullOrWhiteSpace($Token)) { return $false }
  if ($Token -match '\s') { return $false }
  if ($Token -match '[^\u0000-\u007F]') { return $false }
  return $true
}

$allowEnv = $env:CODEX_ALLOW_VERCEL_PROD_DEPLOY
if ([string]::IsNullOrWhiteSpace($allowEnv)) {
  $allowEnv = [Environment]::GetEnvironmentVariable('CODEX_ALLOW_VERCEL_PROD_DEPLOY', 'User')
}
if ($allowEnv -ne '1') {
  throw 'Blocked: CODEX_ALLOW_VERCEL_PROD_DEPLOY must be 1 for production deploys.'
}

$token = Get-VercelTokenFromFile
if (-not (Test-VercelTokenShape -Token $token)) { $token = $env:CODEX_VERCEL_TOKEN }
if (-not (Test-VercelTokenShape -Token $token)) { $token = $env:VERCEL_TOKEN }
if (-not (Test-VercelTokenShape -Token $token)) {
  throw 'Missing Vercel token. Set CODEX_VERCEL_TOKEN_FILE, CODEX_VERCEL_TOKEN, or VERCEL_TOKEN.'
}

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not (Test-Path -LiteralPath (Join-Path $root 'vercel.json'))) {
  throw "Missing vercel.json in $root"
}

$npx = Get-Command 'npx.cmd' -ErrorAction SilentlyContinue
if (-not $npx) { throw 'npx.cmd not found.' }

Push-Location $root
try {
  $env:VERCEL_TOKEN = $token
  npx.cmd --yes vercel@latest project inspect $ProjectName --scope $Scope --non-interactive | Out-Null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Creating Vercel project: $ProjectName"
    npx.cmd --yes vercel@latest project add $ProjectName --scope $Scope --non-interactive
    if ($LASTEXITCODE -ne 0) {
      throw "Vercel project creation failed with exit code $LASTEXITCODE."
    }
  }

  npx.cmd --yes vercel@latest link --yes --team $Scope --project $ProjectName
  if ($LASTEXITCODE -ne 0) {
    throw "Vercel project link failed with exit code $LASTEXITCODE."
  }

  npx.cmd --yes vercel@latest deploy --prod --yes --scope $Scope --project $ProjectName
  if ($LASTEXITCODE -ne 0) {
    throw "Vercel production deploy failed with exit code $LASTEXITCODE."
  }
} finally {
  Remove-Item Env:VERCEL_TOKEN -ErrorAction SilentlyContinue
  Pop-Location
}
