# Backup de uma distro do WSL: exporta para um .tar com a data no nome,
# grava o SHA-256 ao lado e, com -Testar, prova que o arquivo restaura.
# Uso: .\backup.ps1 -Distro Ubuntu-26.04 -Destino E:\backups [-Testar]
param(
    [Parameter(Mandatory)][string]$Distro,
    [Parameter(Mandatory)][string]$Destino,
    [switch]$Testar
)
$ErrorActionPreference = 'Stop'

# o wsl.exe escreve a lista de distros em UTF-16; sem isto, sai com espacos
function Lista-Distros {
    $antes = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::Unicode
    $nomes = wsl.exe -l -q | Where-Object { $_.Trim() -ne '' } |
        ForEach-Object { $_.Trim() }
    [Console]::OutputEncoding = $antes
    return $nomes
}

if ((Lista-Distros) -notcontains $Distro) {
    throw "A distro '$Distro' nao existe. Veja os nomes com: wsl -l -v"
}
New-Item -ItemType Directory -Force $Destino | Out-Null
$data = Get-Date -Format 'yyyy-MM-dd'
$arquivo = Join-Path $Destino "$Distro-$data.tar"
if (Test-Path $arquivo) { throw "Ja existe: $arquivo (nao vou sobrescrever)" }

"Exportando $Distro para $arquivo ..."
wsl.exe --export $Distro $arquivo
if ($LASTEXITCODE -ne 0) { throw "O wsl --export falhou ($LASTEXITCODE)" }

# impressao digital: muda se um unico byte do arquivo mudar
$hash = (Get-FileHash $arquivo -Algorithm SHA256).Hash.ToLower()
"$hash  $(Split-Path $arquivo -Leaf)" | Set-Content "$arquivo.sha256"
$mb = [math]::Round((Get-Item $arquivo).Length / 1MB, 1)
"Pronto: $mb MB, sha256 $hash"

if ($Testar) {
    # restaura numa distro com nome "teste-..." e apaga so ela no fim
    $clone = "teste-$Distro"
    if ((Lista-Distros) -contains $clone) {
        throw "Ja existe a distro '$clone'; apague-a ou renomeie antes."
    }
    $pasta = Join-Path $Destino "restauro-$clone"
    "Restaurando como '$clone' para provar o backup ..."
    wsl.exe --import $clone $pasta $arquivo --version 2
    if ($LASTEXITCODE -ne 0) { throw "O wsl --import falhou" }
    try {
        $quem = (wsl.exe -d $clone -- whoami).Trim()
        "Usuario que abre na restaurada: $quem"
        if ($quem -eq 'root') {
            "AVISO: abriu como root; falta [user] default= no /etc/wsl.conf."
        }
        else { "OK    a restauracao abre com um usuario comum." }
    }
    finally {
        # o nome comeca com 'teste-': nunca apaga a distro de verdade
        wsl.exe --unregister $clone | Out-Null
        Remove-Item $pasta -Recurse -Force -ErrorAction SilentlyContinue
        "Clone '$clone' removido."
    }
}
