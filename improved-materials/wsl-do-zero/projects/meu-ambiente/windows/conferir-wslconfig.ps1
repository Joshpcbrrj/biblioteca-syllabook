# Confere um arquivo .wslconfig sem aplica-lo: so le o arquivo e responde.
param([string]$Caminho = "$PSScriptRoot\wslconfig.modelo")

$conhecidas = 'memory', 'processors', 'swap', 'vmIdleTimeout',
    'networkingMode', 'defaultVhdSize', 'guiApplications',
    'nestedVirtualization'
$falhas = 0

# mostra OK ou FALHA para cada linha que olha
function Checa($texto, $ok) {
    if ($ok) { "OK    $texto" } else { "FALHA $texto"; $script:falhas++ }
}

foreach ($linha in Get-Content $Caminho) {
    $l = $linha.Trim()
    # pula comentarios, linhas em branco e cabecalhos de secao
    if ($l -eq '' -or $l.StartsWith('#') -or $l.StartsWith('[')) { continue }
    $chave, $valor = $l -split '=', 2
    $chave = $chave.Trim(); $valor = "$valor".Trim()
    Checa "chave conhecida: $chave" ($conhecidas -contains $chave)
    if ($chave -in 'memory', 'swap', 'defaultVhdSize') {
        Checa "$chave tem numero e unidade (ex.: 8GB)" `
            ($valor -match '^\d+\s?(MB|GB|TB)$' -or $valor -eq '0')
    }
    if ($chave -in 'processors', 'vmIdleTimeout') {
        Checa "$chave e um numero inteiro" ($valor -match '^\d+$')
    }
}
"---"
if ($falhas -eq 0) { "Arquivo conferido: nada de estranho." }
else { "$falhas problema(s) encontrados."; exit 1 }
