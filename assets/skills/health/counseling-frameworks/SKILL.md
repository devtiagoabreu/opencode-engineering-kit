---
provenance:
  source: OpenCode Engineering Kit (community) — padrões adaptados de ironyjk/counsel-frameworks, dralexlup/therapy-skill e theneoai/awesome-skills
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: counseling-frameworks
description: Roteador de frameworks de psicoeducação (TCC, ACT, SFBT, MI, DBT-skills, PPT, narrativa) para autoexploração estruturada, sem psicoterapia nem diagnóstico
category: health
version: 0.1.0
author: devtiagoabreu
tags: [tcc, act, dbt, sfbt, mi, psicoeducacao, autoexploracao, frameworks]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Ter rodado mental-health-crisis-protocol antes de qualquer exercício
provides:
  - Regras de seleção de 1-3 frameworks por situação
  - Roteiros de exercícios e pipelines multi-framework
  - Matriz de anti-padrões e critérios de encaminhamento
---

# Frameworks de Autoexploração (Psicoeducação)

## Overview

Roteador de frameworks de psicoeducação (TCC, ACT, SFBT, MI, DBT-skills e
outros) para autoexploração estruturada. Não é psicoterapia, não diagnostica
e nunca substitui profissional.

## Prerequisites

- Ter rodado `mental-health-crisis-protocol` antes de qualquer exercício
- Uma situação concreta relatada pela pessoa
- Disposição para escolher 1 framework principal e no máximo 2 de apoio

## Limite inegociável

Isto é **aprendizado de frameworks e exercícios de autoexploração**, não psicoterapia. Não produzir diagnóstico, não conduzir sessão terapêutica, não processar trauma, não substituir profissional. Se houver qualquer sinal de risco, rodar `mental-health-crisis-protocol` **antes** de continuar.

## Roteador: como escolher

```text
Situação relatada
├─ crise / risco → PARAR → mental-health-crisis-protocol
├─ pensamentos automáticos, ansiedade, preocupação → TCC (+ MBCT se ruminação)
├─ evitamento, valores confusos, rigidez → ACT
├─ meta concreta, baixa motivação, "não sei por onde começar" → SFBT
├─ ambivalência, resistência à mudança → MI
├─ regulação emocional intensa, impulsividade → DBT-skills (só habilidades)
├─ esgotamento, falta de sentido, forças → PPT (PERMA)
├─ culpa, identidade, estigma, luto → Narrativa / Worden
└─ relacionamento → comunicação não violenta + MI (sem "terapia de casal")
```

Escolher **1 framework principal** e no máximo **2 de apoio**. Nomear a escolha e o motivo em uma frase antes de aplicar.

## Catálogo resumido

| Framework | Ideia central | Melhor uso | O que NÃO fazer |
|---|---|---|---|
| **TCC (Beck)** | pensamento → emoção → comportamento | ansiedade, pensamentos automáticos | Não rotular "distorção" como ataque |
| **REBT (Ellis)** | A-B-C-D-E, crenças "deveria" | perfeccionismo, raiva | Não disputar com tom superior |
| **ACT (Hayes)** | flexibilidade psicológica, aceitação + valores | evitamento, ruminação, dor crônica | Não forçar aceitação de situação abusiva |
| **SFBT (de Shazer/Berg)** | exceções, pergunta milagre, escalas | metas pequenas, baixa motivação | Não negar a dificuldade relatada |
| **MI (Miller/Rollnick)** | ambivalência, change talk, OARS | resistência, mudança de hábito | Não confrontar ou "vender" a mudança |
| **DBT-skills (Linehan)** | mindfulness, tolerância ao estresse, regulação, eficácia interpessoal | picos emocionais, impulsividade | Não oferecer therapy completa nem coaching por telefone |
| **PPT (Seligman)** | PERMA: emoção positiva, engajamento, relações, sentido, realização | burnout, forças, sentido | Não substituir tratamento de depressão |
| **MBCT/MBSR** | decentrar, atenção plena | ruminação, estresse, prevenção de recaída | Não usar em crise aguda sem estabilização |
| **Narrativa / Worden** | externalizar problema, reautoria; tarefas do luto | identidade, estigma, perda | Não interpretar trauma sem formação |
| **PCT (Rogers)** | escuta empática, consideração positiva incondicional | acolhimento | Não fingir que a relação terapêutica foi estabelecida |

## Pipelines úteis

```yaml
ansiedade_ruminacao: [TCC: registro de pensamento, MBCT: descentramento, ACT: ação valorosa]
desanimacao_apatia: [TCC: ativação comportamental, PPT: forças, SFBT: menor passo]
conflito_interno: [IFS-lite: reconhecer partes, ACT: aceitação, PPT: autocompaixão]
luto: [PCT: escuta, Worden: tarefas do luto, Narrativa: continuidade do vínculo]
baixa_motivacao: [MI: ambivalência, SFBT: exceções, ACT: valores]
desregulacao: [DBT: STOP/TIPP, MBSR: estabilizar, TCC: analisar gatilhos depois]
```

Use o pipeline como **sequência**, não como lista de opções simultâneas.

## Roteiro de uma micro-exploração (5-10 minutos)

```markdown
1. VALIDAR (1-2 frases): "Faz sentido você se sentir assim diante disso."
2. ESCOLHER framework + motivo (1 frase)
3. PERGUNTAR (uma pergunta por vez, esperar resposta)
4. EXERCÍCIO (registro de pensamento, escala, pergunta milagre, STOP...)
5. SÍNTESE (o que a pessoa descobriu, com as palavras dela)
6. PRÁTICA PEQUENA (uma ação de baixo atrito para os próximos dias)
7. ENCERRAR com limite: "Isto é psicoeducação; se piorar, procure profissional."
```

Exemplo de registro TCC:

```yaml
situacao: "Reunião com o gestor na quinta"
pensamento_automatico: "Vou errar e vão me achar incompetente"
emocao: "ansiedade 8/10"
evidencias_a_favor: ["já travei antes"]
evidencias_contra: ["preparei o material", "recebi feedback positivo no mês passado"]
pensamento_alternativo: "Posso estar nervoso e ainda assim apresentar bem"
acao_pequena: "Ensaie os primeiros 3 minutos com um colega"
```

## Anti-padrões

| Anti-padrão | Risco | Correção |
|---|---|---|
| Conselho antes de validar | Pessoa se sente não ouvida | Validar primeiro, perguntar depois |
| "Você tem dependência/pensamento distorcido" | Rotulagem | Descrever o padrão, não a pessoa |
| Muitas perguntas de uma vez | Sobrecarga | Uma pergunta por turno |
| Tranquilização repetida | Reforça ansiedade/OCD | Redirecionar para tolerância à incerteza |
| Abrir trauma sem container | Reativação | Estabilizar primeiro e encaminhar |
| Usar DBT/PCT como "terapia completa" | Falsa promessa | nomear como habilidades/princípios apenas |
| Encerrar sem critério de procura de ajuda | Piora sem rede | Sempre dizer quando procurar profissional |

## Critérios de encaminhamento

Encaminhar a profissional habilitado quando houver: ideação ou autolesão, sintomas persistentes >2 semanas com prejuízo funcional, piora rápida, uso de substâncias, sintomas psicóticos/maníacos, trauma não processado ou dúvida diagnóstica.

## Referências

- [ironyjk/counsel-frameworks — 14 frameworks + roteador](https://github.com/ironyjk/counsel-frameworks)
- [dralexlup/therapy-skill — análise multi-nível e anti-padrões](https://github.com/dralexlup/therapy-skill)
- [theneoai/awesome-skills — psychologist persona](https://github.com/theneoai/awesome-skills)
- [APA — Psychotherapy / evidence-based practice](https://www.apa.org/topics/psychotherapy)
- [NICE — Depression and anxiety guidelines](https://www.nice.org.uk/guidance/cg90)
