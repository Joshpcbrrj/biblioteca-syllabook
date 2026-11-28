# 12. Projeto final: seu museu da computação

> 🗺️ **Neste capítulo:** você monta uma linha do tempo comentada de 15 marcos da computação, com uma causa para cada virada e um mito checado em fonte, e decide quem entra e quem fica de fora. · ⏱️ ~60 min

> 🔥 **Aquecimento:** (1) O que o Transformer dispensou, segundo o artigo de 2017? (2) O que é a Lei 7.232, de 1984, e que tipo de proteção ela dava?
>
> <details>
> <summary>Ver respostas</summary>
>
> (1) A recorrência e as convoluções: o modelo se baseia só em atenção. (2) A Política Nacional de Informática: proteção transitória a empresas nacionais, preferência nas compras públicas e controle de importação por 8 anos.
>
> </details>

## De onde paramos

Nos capítulos 1 a 11 você percorreu mais de dois séculos, do tear de Jacquard aos modelos de linguagem. Agora o trabalho é seu. **A pergunta-guia é: que 15 marcos você escolheria para contar essa história, e o que explica cada virada entre eles?** O capítulo mostra um museu de exemplo, e você monta o seu na prática.

## Escolher marcos

Uma lista de datas não é uma história. Um marco bom é um acontecimento com data, nome e fonte que você consegue explicar em duas frases, e que muda o que as pessoas podiam fazer.

**Um marco é um acontecimento datado, com fonte, depois do qual algo ficou possível que antes não era.**

Cada marco do projeto tem cinco campos: ano, nome, país, causa e capítulo do livro onde ele aparece. O museu de exemplo abaixo usa só marcos que o livro já apresentou com fonte. O seu pode escolher outros, desde que você abra a fonte de cada um antes de afirmar.

```python
# Verificador do museu: cada marco é (ano, nome, país, causa, capítulo)
marcos = [
    (1801, "Tear de Jacquard", "FR", "trocar o desenho sem refazer", 1),
    (1890, "Censo de Hollerith", "US", "contagem manual lenta demais", 3),
    (1936, "Máquina de Turing", "GB", "definir o que é computar", 4),
    (1945, "Programa armazenado", "US", "instruções e dados na memória", 6),
    (1947, "Transistor", "US", "trocar a válvula por chave sólida", 7),
    (1961, "Zezinho do ITA", "BR", "ter uma máquina para ensinar", 6),
    (1964, "System/360", "US", "mesma programação em 5 modelos", 7),
    (1969, "ARPANET", "US", "ligar máquinas por pacotes", 10),
    (1971, "Intel 4004", "US", "processador num só chip", 7),
    (1972, "Patinho Feio", "BR", "computador próprio no Brasil", 7),
    (1975, "Altair 8800", "US", "chips baratos viram um kit", 9),
    (1984, "Lei 7.232", "BR", "proteger empresas nacionais", 9),
    (1989, "AlterNex", "BR", "rede fora da academia", 10),
    (1991, "Web no CERN", "CH", "ligar documentos por links", 10),
    (2022, "ChatGPT", "US", "modelos que conversam", 11),
]
erros = []
if len(marcos) < 15:
    erros.append(f"faltam marcos: {len(marcos)} de 15")
br = [m for m in marcos if m[2] == "BR"]
if len(br) < 2:
    erros.append("menos de 2 marcos brasileiros")
if [m[0] for m in marcos] != sorted(m[0] for m in marcos):
    erros.append("fora de ordem")
for ano, nome, _, causa, cap in marcos:
    if not causa.strip():
        erros.append(f"{nome}: sem causa")
print(f"{len(marcos)} marcos, {len(br)} brasileiros")
for (a, n, *_), (b, m, *_) in zip(marcos, marcos[1:]):
    print(f"{a} -> {b} (+{b - a:>3}): {n} -> {m}")
print("Erros:", erros or "nenhum")
```

Saída real, rodada ao escrever o capítulo:

```text
15 marcos, 4 brasileiros
1801 -> 1890 (+ 89): Tear de Jacquard -> Censo de Hollerith
1890 -> 1936 (+ 46): Censo de Hollerith -> Máquina de Turing
1936 -> 1945 (+  9): Máquina de Turing -> Programa armazenado
1945 -> 1947 (+  2): Programa armazenado -> Transistor
1947 -> 1961 (+ 14): Transistor -> Zezinho do ITA
1961 -> 1964 (+  3): Zezinho do ITA -> System/360
1964 -> 1969 (+  5): System/360 -> ARPANET
1969 -> 1971 (+  2): ARPANET -> Intel 4004
1971 -> 1972 (+  1): Intel 4004 -> Patinho Feio
1972 -> 1975 (+  3): Patinho Feio -> Altair 8800
1975 -> 1984 (+  9): Altair 8800 -> Lei 7.232
1984 -> 1989 (+  5): Lei 7.232 -> AlterNex
1989 -> 1991 (+  2): AlterNex -> Web no CERN
1991 -> 2022 (+ 31): Web no CERN -> ChatGPT
Erros: nenhum
```

Conferência: 2022 − 1991 = 31; 1991 − 1989 = 2; de 1801 a 2022 são 221 anos. ✔ Os intervalos mostram só o que este museu escolheu listar. Eles não são o ritmo da história, e dois marcos vizinhos no tempo (como 1971 e 1972) não provam que um causou o outro.

**Erro comum:** concentrar os marcos numa só época. Os 15 do exemplo cobrem dois séculos; se os seus ficam todos depois de 1970, você está contando só uma parte da história.

## Causa e efeito

Cada marco do museu precisa responder: **o que se queria resolver?** Essa é a causa. A linha do tempo vira uma história quando você liga cada virada à seguinte com essa pergunta.

**Causa, aqui, é o problema que alguém queria resolver; efeito é o que ficou possível depois.**

Exemplo com o que o livro já mostrou: no censo de 1890 havia 63 milhões de pessoas e a estimativa era de que o método manual não terminaria a tempo (capítulo 3). A causa é essa contagem lenta demais; o efeito é o concurso que Hollerith venceu, com cartões e uma máquina tabuladora.

> 💡 **Analogia: a receita.** Um marco é um prato novo; a causa é a fome ou a falta que levou o cozinheiro a inventá-lo. **Onde a analogia falha:** na história de verdade, o "cozinheiro" é muitas vezes um grupo, uma empresa ou um governo, e o prato nem sempre sai (a Máquina Analítica nunca foi concluída).

Duas armadilhas ao escrever a causa. Primeiro, ela precisa vir de uma fonte, não da sua imaginação: se o livro não diz por que algo foi feito, escreva "causa não verificada" em vez de inventar. Segundo, quase nenhuma virada tem uma causa só; escolha a que a fonte destaca e diga que há outras.

**Erro comum:** escrever "porque era inevitável". Isso não é causa. Uma causa é um problema concreto, com data e gente envolvida.

## Checar uma lenda

Todo museu tem lendas na entrada. O seu projeto exige uma checada, com fonte, pelo método do livro: **fato × interpretação × lenda**.

**Lenda é uma história repetida como fato, mas que a fonte não sustenta, ou sustenta só em parte.**

Exemplo resolvido, o "primeiro bug" (capítulo 8):

- **Fato:** a mariposa de 1947 existiu.
- **Lenda:** que foi a origem da palavra "bug". Segundo a JSTOR Daily, a palavra já era usada antes: em 1878 por Edison e em 1889 por um jornal.
- **Como você checou:** abriu a fonte, anotou as datas e comparou com a história que circula.

Outras lendas que o livro já tratou: a "primeira programadora" (a Nota G é fato; o título é debate, capítulo 2) e o "primeiro computador" (depende da definição usada, capítulo 5).

> ⚖️ **Fato × interpretação × lenda.**
> **Fato:** a mariposa de 1947 existiu, e a palavra "bug" já tinha registros anteriores (1878 e 1889).
> **Interpretação:** se o episódio de 1947 ainda merece ser contado como curiosidade, desde que sem o "primeiro".
> **Lenda a evitar:** "foi ali que nasceu a palavra bug".

**Erro comum:** achar que checar uma lenda é apenas dizer "é mentira". A maioria tem uma parte verdadeira, e seu trabalho é separar a parte que a fonte sustenta da que não sustenta.

## Quem ficou de fora

Todo museu de 15 marcos deixa gente de fora, e isso também é uma escolha. O exemplo acima só tem máquinas, leis e redes. Mas os capítulos mostraram quem estava por trás delas: os computadores humanos de Langley, uma equipe de mulheres (capítulo 3); as seis programadoras do ENIAC, que programavam a máquina com fios e chaves (capítulo 5); Grace Hopper e o compilador A-0, de 1952, e Margaret Hamilton, que liderou o software de voo da Apollo (capítulo 8).

Ao montar o seu museu, escreva uma nota de duas ou três linhas: quem ou o que ficou de fora, e por quê. Não vale dizer "não coube" sem apontar o que você cortou no lugar.

**Erro comum:** tentar compensar a ausência com uma lista de nomes sem causa. Um nome sem uma virada associada vira enfeite; ligue cada pessoa ao marco em que ela atuou.

## Pelo menos 2 marcos brasileiros

A história da computação não é feita apenas em outros países. O projeto exige pelo menos dois marcos brasileiros, e o verificador do exemplo confere isso. No exemplo entraram quatro, todos com fonte nos capítulos 6, 7, 9 e 10: o Zezinho do ITA (1961), o Patinho Feio da Poli-USP (1972), a Lei 7.232 (1984) e o AlterNex (1989).

Cada um tem lugar próprio na história. A Lei 7.232 deu proteção transitória a empresas nacionais por 8 anos, e o AlterNex levou a rede para fora do circuito acadêmico da RNP. Compare com o resto do mundo só com fonte: o livro não afirma que um marco brasileiro "respondeu" a um estrangeiro só porque as datas são próximas.

**Erro comum:** tratar o Brasil como nota de rodapé ou, no sentido oposto, dizer que um marco brasileiro foi "o primeiro do mundo" sem fonte. Fique com o que as fontes dizem: o que foi feito, quando e por quem.

## 🏋️ Pratique

**1. Exemplo resolvido.** Escolha um marco do museu de exemplo e escreva a causa em uma frase, com a fonte.

- Marco: System/360 (1964).
- Causa: oferecer cinco modelos com a mesma programação (capítulo 7).
- Fonte: o capítulo 7 e a fonte citada nele. ✔

**2. Complete.** Ligue cada marco à causa: Altair 8800 → ___; AlterNex → ___; Transistor → ___.

<details>
<summary>Ver resposta</summary>

Altair 8800: chips baratos permitiram um computador em kit. AlterNex: levar a rede para fora da academia. Transistor: trocar a válvula por uma chave sólida. Erro comum: escrever como causa apenas o efeito ("virou um computador pessoal").

</details>

**3. Por conta própria.** Monte o seu museu: 15 marcos com ano, nome, país, causa e capítulo, pelo menos 2 brasileiros, em ordem cronológica. Rode o verificador do capítulo com a sua lista; ele deve imprimir "Erros: nenhum".

<details>
<summary>Ver resposta</summary>

Resposta aberta. Confira com esta rubrica: (1) são 15 marcos e pelo menos 2 são brasileiros; (2) estão em ordem; (3) cada um tem uma causa que é um problema, não só um efeito; (4) cada afirmação vem de uma fonte que você abriu.

</details>

**4. Desafio (checar uma lenda).** Escolha uma lenda sobre computação que você já ouviu e que não está neste livro. Em 5 a 8 linhas: (a) conte a lenda; (b) separe fato, interpretação e lenda; (c) cite a fonte que você abriu e diga quem a escreveu e quando.

<details>
<summary>Ver resposta</summary>

Resposta aberta. Confira com esta rubrica: (1) a lenda está dita com clareza; (2) a parte sustentada pela fonte está separada da que não é; (3) a fonte tem autor e data, e você disse o que ela pode e o que não pode provar; (4) você não concluiu mais do que a fonte permite.

</details>

## 🧠 Revisão rápida

1. O que um marco precisa ter para entrar no museu?
2. O que é "causa" neste projeto?
3. Quais são as três camadas para checar uma lenda?
4. Por que o verificador não prova que um marco causou o outro?
5. (Do capítulo 5) Por que "primeiro computador" depende da definição?

<details>
<summary>Ver respostas</summary>

1. Ano, nome, fonte e uma causa. 2. O problema que alguém queria resolver. 3. Fato, interpretação e lenda. 4. Ele confere só a lista (quantidade, ordem, causas preenchidas), não a verdade de cada causa. 5. Porque cada máquina cumpre uma parte da definição, e a resposta muda conforme a definição escolhida.

</details>

## 🤖 Estude com um tutor de IA

- "Leia meu museu de 15 marcos e, uma pergunta de cada vez, me pergunte a causa de cada virada. Não me dê a resposta antes de eu tentar."
- "Aqui está a lenda que escolhi e minha checagem: [texto]. Aponte onde misturei fato e interpretação, sem reescrever por mim, e me lembre de conferir a fonte."

> ➡️ **Próximo passo:** você terminou a trilha do livro. Veja, no fim, as próximas leituras sugeridas.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| Marco | Acontecimento datado, com fonte, depois do qual algo ficou possível. |
| Causa | O problema que alguém queria resolver, com fonte. |
| Lenda | História repetida como fato que a fonte não sustenta, ou sustenta em parte. |
| Quem ficou de fora | Nota de 2 a 3 linhas sobre o que o museu deixou de lado e por quê. |
| Marcos brasileiros | Pelo menos 2 no museu, com fonte, sem "atraso" nem "milagre". |

## 📚 Fontes

- Este capítulo não traz fatos novos: os marcos vêm das fontes listadas nos capítulos 1 a 11.
- JSTOR Daily, [The Bug in the Computer Bug Story](https://daily.jstor.org/the-bug-in-the-computer-bug-story), consultado em 27/11/2026.
- Computer History Museum, [Ada Lovelace](https://www.computerhistory.org/babbage/adalovelace/), consultado em 27/11/2026, e Prospect, [Debugging the mythology](https://prospectmagazine.co.uk/ideas/technology/38160/debugging-the-mythology-was-ada-lovelace-really-the-first-computer-programmer), consultado em 27/11/2026.

> 🔁 **Revise hoje:** capítulos 5, 9 e 11

<!-- next-steps:start -->
## 🧭 Próximos caminhos

- **Como um computador funciona por dentro**: Para entender na prática os bits, a lógica e a memória que este livro apresentou na história (portas lógicas · binário · CPU e memória)
- **História da internet e da cultura digital**: Para aprofundar redes, web, redes sociais e seus efeitos na sociedade (protocolos · web 2.0 · privacidade)
- **IA para curiosos**: Para entender como funcionam e como usar com critério as IAs de hoje (aprendizado de máquina · modelos de linguagem · limites e riscos)
<!-- next-steps:end -->

<!-- nav:start -->
---

[◀ Capítulo anterior](11-maquinas-que-aprendem-a-longa-estrada.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](13-simulado-final.md)
<!-- nav:end -->
