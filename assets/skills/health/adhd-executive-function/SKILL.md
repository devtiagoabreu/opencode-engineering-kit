---
provenance:
  source: OpenCode Engineering Kit (community) — padrões adaptados de FreedomIntelligence/OpenClaw-Medical-Skills (adhd-daily-planner), sundial-org/awesome-openclaw-skills e murilonerdx/skill-engineering-tdah
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: adhd-executive-function
description: Estratégias de funções executivas para TDAH — tempo, ativação, memória de trabalho, transições e energia, sem vergonha nem prescrição
category: health
version: 0.1.0
author: devtiagoabreu
tags: [tdah, funcoes-executivas, tempo, foco, hiperfoco, neurodiversidade, produtividade]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Reconhecer que TDAH é diferença de regulação, não falta de esforço
  - Preferência declarada da pessoa por formatos visuais/textuais
provides:
  - Regras de estimativa de tempo e planejamento flexível
  - Menu de estratégias de ativação, transição e externalização
  - Critérios para parar o planejamento e começar a agir
---

# Funções Executivas e TDAH

## Overview

Estratégias de funções executivas para TDAH: percepção de tempo, ativação,
memória de trabalho, transições e energia. Sem vergonha e sem prescrição.

## Prerequisites

- Reconhecer TDAH como diferença de regulação, não falta de esforço
- Preferência declarada por formatos visuais ou textuais
- Encaminhar a profissional quando houver suspeita diagnóstica ou sofrimento agudo

## Filosofia

TDAH não é character flaw nem falta de vontade. É diferença na regulação de dopamina, percepção de tempo e atenção. Planejar **para** o cérebro que existe, não para um ideal neurotípico.

Regras: nunca usar vergonha ou "é só se esforçar"; celebrar **feito > perfeito**; admitir que o que funciona hoje pode não funcionar amanhã; tratar energia como bateria que se esgota.

Se houver sinais de crise ou sofrimento agudo, rodar `mental-health-crisis-protocol` antes de qualquer técnica de produtividade.

## Árvore de decisão rápida

```text
Qual o horizonte?
├─ próximas 2h → brain dump + UMA próxima ação
├─ hoje → 3 coisas + blocos com buffers
├─ semana → temas + reduzir prioridades
├─ mês → meta com proteção anti-overwhelm
└─ mais longo → pedaços de um mês; não sobre-planejar

Pessoa em crise? → SIM: pular planejamento, uma ação mínima
Pessoa hiperfocada em planejar? → SIM: interromper; "planejar não é fazer"
```

## 1. Cegueira temporal

A regra 3x: multiplique por três a primeira estimativa.

```text
"5 minutos" → 15-20 min
"30 minutos" → 1-1,5h
"umas horas" → meio dia
"este fim de semana" → não acontece sem body doubling
```

Tornar o tempo visível: relógio analógico, timer visual, calendário com hora explícita, frases "quando X, então Y". Sempre incluir **buffer de transição** de 10-15 min entre blocos.

## 2. Ativação (a parte mais difícil)

Menu, nunca prescrição única:

- **Início de 2 minutos:** compromisso de abrir o doc/escrever a primeira frase — não de terminar.
- **Body doubling:** trabalhar ao lado de alguém (presencial ou vídeo).
- **Temptation bundling:** tarefa chata + estímulo agradável (podcast, música).
- **Redução de atrito:** deixar o próximo passo visível na mesa/na tela ao encerrar.
- **Contagem regressiva:** 5-4-3-2-1 e começar no 2.

## 3. Memória de trabalho

Externalizar tudo:

```yaml
captura:
  - "notas em todos os lugares (celular, papel, voz)"
  - "instruções escritas mesmo para tarefas simples"
  - "checklists para rotinas repetidas"
  - "lembrete no lugar onde a ação acontece, não só no app"
regra: "se não está escrito/visto, não existe"
```

## 4. Sistema das 3 coisas

```markdown
1. A Coisa — se nada mais sair, essa sai
2. Seria bom — importante, mas não crítico hoje
3. Se eu estiver voando — só se o dia render muito
```

Não colocar 10 itens. Se tudo é prioridade, nada é.

## 5. Decisões e energia

Pré-decidir para economizar bateria: mesma alimentação ou 2 opções, roupa separada na noite anterior, modelos de resposta, regras "se X, então Y". Respeitar o dip da tarde com tarefas de baixo esforço (e-mail, admin).

## Exemplo de plano de dia

```markdown
09:00  A Coisa (bloqueio + timer + body doubling)
10:30  TRANSIÇÃO — água, banheiro, olhar pela janela
10:45  Seria bom / reuniões
12:00  Almoço de verdade (não almoço trabalhando)
12:45  Admin, e-mail, organização leve
14:00  Trabalho colaborativo / variedade
16:00  Encerrar: preparar próximo passo visível + 5 min de "amanhã"
```

## Anti-padrões

| Anti-padrão | Correção |
|---|---|
| "Basta usar Pomodoro" | Oferecer menu; adaptar timer à pessoa |
| Lista com 15 prioridades | Reduzir a 3 |
| Cobrar esquecimento | Reformular sistema, não a pessoa |
| Planejar sem buffer de transição | Inserir 10-15 min explicitamente |
| Hiperfoco no planejamento | Timer e uma ação mínima imediata |
| Medida de sucesso = perfeição | Medida = feito e registrado |
| Diagnóstico ou medicação sugerida | Encaminhar a neuropsicólogo/psiquiatra |

## Quando encaminhar

Suspeita diagnóstica, prejuízo persistente em estudo/trabalho, sofrimento intenso, comorbidades de ansiedade/depressão ou uso de substâncias → avaliação com profissional habilitado. Esta skill não substitui avaliação nem tratamento.

## Referências

- [FreedomIntelligence/OpenClaw-Medical-Skills — ADHD daily planner](https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills)
- [sundial-org/awesome-openclaw-skills — ADHD body doubling](https://github.com/sundial-org/awesome-openclaw-skills)
- [murilonerdx/skill-engineering-tdah](https://github.com/murilonerdx/skill-engineering-tdah)
- [CHADD — Resources about ADHD](https://chadd.org/)
