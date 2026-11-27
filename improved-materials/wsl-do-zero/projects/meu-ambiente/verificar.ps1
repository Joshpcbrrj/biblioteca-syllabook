# Confere, do lado Windows, se o PC esta pronto para o WSL 2.
$build = [System.Environment]::OSVersion.Version.Build
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$emUso = (Get-CimInstance Win32_ComputerSystem).HypervisorPresent
$wsl = Get-Command wsl.exe -ErrorAction SilentlyContinue

# mostra OK ou FALHA para cada teste
function Checa($texto, $ok) {
    if ($ok) { "OK    $texto" } else { "FALHA $texto" }
}

$versaoOk = $build -ge 19041
# com o hipervisor em uso, o campo do firmware aparece como False
$virtOk = $cpu.VirtualizationFirmwareEnabled -or $emUso

Checa "Windows 10 build 19041+ ou 11 (este: build $build)" $versaoOk
Checa "virtualizacao ligada no firmware ou em uso" $virtOk
Checa "wsl.exe encontrado" ($null -ne $wsl)

# o modelo do .wslconfig (windows/) passa no conferidor, sem ser aplicado
$modelo = Join-Path $PSScriptRoot 'windows\wslconfig.modelo'
$conferidor = Join-Path $PSScriptRoot 'windows\conferir-wslconfig.ps1'
$modeloOk = (Test-Path $modelo) -and (Test-Path $conferidor) -and
    -not (& $conferidor -Caminho $modelo | Select-String 'FALHA')
Checa "modelo do .wslconfig confere (windows/)" $modeloOk

# o backup.ps1 existe e a sintaxe dele esta correta (sem roda-lo)
$bkp = Join-Path $PSScriptRoot 'backup.ps1'
$erros = $null
if (Test-Path $bkp) {
    [void][System.Management.Automation.Language.Parser]::ParseFile(
        $bkp, [ref]$null, [ref]$erros)
}
Checa "backup.ps1 presente e sem erro de sintaxe" `
    ((Test-Path $bkp) -and $erros.Count -eq 0)
