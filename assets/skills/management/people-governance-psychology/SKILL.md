---
provenance:
  source: OpenCode Engineering Kit (community) — conceitos adaptados de Edmondson (psychological safety), Deci & Ryan (autonomia/competência/vínculo), Bakker & Demerouti (JD-R), Google Project Aristotle, ISO 30414 e SHRM
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: people-governance-psychology
description: Psicologia aplicada à governança de pessoas — segurança psicológica, liderança, desempenho, engajamento, conflito e ética de dados, sem diagnóstico ou vigilância
category: management
version: 0.1.0
author: devtiagoabreu
tags: [governanca-de-pessoas, psicologia-organizacional, seguranca-psicologica, lideranca, desempenho, engajamento, people-analytics, rh]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Contexto organizacional (time, papel, horizonte) antes de recomendar prática
  - Dados agregados e mínimos quando houver people analytics
provides:
  - Modelos de diagnóstico organizacional (não clínico)
  - Roteiros de 1:1, feedback, onboarding e conflito
  - Regras de governança e ética para dados de pessoas
---

# Psicologia para Governança de Pessoas

## Overview

Psicologia aplicada à governança de pessoas: segurança psicológica, liderança,
desempenho, engajamento, conflito e ética de dados. Diagnostica condições do
sistema, não pessoas, e mantém a decisão de emprego nas mãos de um humano.

## Prerequisites

- Contexto organizacional mínimo: time, papel e horizonte da demanda
- Jurisdição declarada antes de qualquer orientação legal
- Dados agregados e mínimos quando houver people analytics

## Limite inegociável

Esta skill apoia **decisões e processos organizacionais**, não avalia pessoas. Não diagnosticar transtornos, não inferir saúde mental de colaborador, não transformar questionário de clima em laudo, não usar dados de bem-estar para vigilância ou punição.

Se uma conversa organizacional revelar risco individual (ideação suicida, abuso, assédio, crise), interromper o fluxo de gestão e rodar `mental-health-crisis-protocol` ou encaminhar ao canal formal (RH/Compliance/Ouvidoria) conforme o caso.

**Router-first:** esta skill é um roteador. Escolha 1-3 práticas abaixo, diga explicitamente o que foi escolhido e por quê, e declare quando a demanda ficou fora do alcance. Não carregar todos os modelos de uma vez.

## Gate de jurisdição (obrigatório)

Antes de qualquer orientação sobre contrato, folha, previdência, imposto, processo disciplinar, demissão, seleção ou monitoramento, declarar a jurisdição e seu código:

```yaml
jurisdicoes:
  BR: "CLT + LGPD + CFM quando houver saúde mental"
  EU: "GDPR + AI Act (Anexo III.4: emprego/gestão = alto risco)"
  US: "SHRM/ADA/Title VII — verificar estado"
  outro: "declarar 'verificar com assessoria local' e não inventar prazo"
regra: "se a jurisdição não foi informada, perguntar antes de responder"
```

A decisão de emprego **sempre** permanece humana, nomeada, datada e justificada. O agente produz rascunho, evidência e opções — nunca a decisão.

## Modelos centrais

### 1. Segurança psicológica (Edmondson)

Segurança psicológica é a crença compartilhada de que o time permite risco interpessoal: falar, discordar, admitir erro e pedir ajuda sem retaliação.

Três sinais observáveis:

| Sinal | Pergunta que revela | Sinal de alerta |
|---|---|---|
| Voz | "Quem discordou na última decisão?" | Todo mundo concorda sempre |
| Aprender com erro | "O que mudou depois do último incidente?" | Erro vira culpa, não aprendizado |
| Pedir ajuda | "Quem pediu ajuda esta semana?" | Ninguém pede; prazos sempre "transparentes" |

### 2. Autonomia, competência, vínculo (Deci & Ryan)

- **Autonomia:** escolha sobre como fazer, não apenas sobre o resultado.
- **Competência:** feedback específico, desafio ajustado, oportunidade de crescer.
- **Vínculo:** pertencimento sem exigir conformidade ou exposição forçada.

### 3. Demandas e recursos (JD-R)

Carga alta só gera engajamento quando há recursos: autonomia, suporte social, feedback, clareza de papel. Sem recurso, demanda vira burnout.

```text
risco_de_burnout ≈ demandas crônicas - recursos disponíveis
```

### 4. AMO (habilidade, motivação, oportunidade)

Desempenho = capacidade × motivação × oportunidade de contribuir. Se um dos três está ausente, "cobrar mais" não resolve.

## Árvore de decisão para gestores

```text
Problema relatado
├─ "as pessoas não falam" → segurança psicológica + posto de fala em reunião
├─ "entrega caiu" → AMO: verificar habilidade, motivação e oportunidade
├─ "times desengajados" → autonomia + competência + vínculo + JD-R
├─ "conflito repetido" → mapear interesse vs. posição + mediação estruturada
├─ "onboarding fraco" → clareza de papel + primeiro sucesso em 30 dias
├─ "feedback não cola" → especificidade + periodicidade + exemplo observável
└─ "pedido de dados de bem-estar" → KIT DE GOVERNANÇA DE DADOS (abaixo)
```

## Roteiros práticos

### 1:1 semanal (30 min)

```markdown
1. Como você está chegando? (1 pergunta, escutar antes de responder)
2. O que travou seu trabalho esta semana? (remover impedimento, não julgar)
3. O que você aprendeu? (reforçar competência)
4. O que precisa mudar em mim ou no time? (segurança psicológica)
5. Combinar UMA ação com dono e prazo
```

Regras: não transformar 1:1 em status report; registrar decisões, não opiniões pessoais; sigilo respeitado exceto risco/abuso.

### Feedback específico

```text
RUIM:  "Você precisa ser mais proativo."
BOM:   "Na reunião de segunda, você antecipou o risco de prazo e trouxe
        duas alternativas. Isso ajudou o time a decidir antes da sexta.
        Quero ver mais disso nos próximos dois sprints."
```

Fórmula: **situação observável → impacto → expectativa explícita → próximo passo**.

### Onboarding (30/60/90)

```yaml
dia_1: "papel claro, ferramentas funcionando, pessoa de referência"
dia_30: "primeiro resultado pequeno entregue + feedback específico"
dia_60: "autonomia ampliada em uma decisão real"
dia_90: "revisão de carga e recursos (JD-R) + plano de crescimento"
```

### Conflito

1. Separar **posição** (o que cada um quer) de **interesse** (por que quer).
2. Restaurar fala alternada e critérios explícitos de decisão.
3. Combinar comportamento observável, não juízo de intenção.
4. Escalar quando houver assédio, discriminação ou risco — canal formal, não mediação informal.

### Log de preocupações (duas passagens)

1. **Primeira passagem — mérito:** o que foi relatado, quando, impacto observável, evidência disponível.
2. **Segunda passagem — encaminhamento:** quem vai agir, até quando, qual sinal observável mostrará conclusão.

Nunca identificar autor por estilo de escrita, metadados ou "parece com alguém". Separar sempre:

```yaml
alegacao: "o que a pessoa disse"
evidencia: "o que existe registrado"
finding: "o que foi confirmado"
em_aberto: "o que ainda nao se sabe"
```

Quem tem conflito de interesse não conduz a apuração. Decisão final é humana e documentada.

### Ensaio de speak-up com cláusula de segurança

Antes de qualquer role-play: perguntar se há medo de retaliação. **Se houver, não ensaiar** — encaminhar para interlocutor ou canal seguro. Caso contrário: alinhar pontos de aprendizagem, um turno por vez, e manter a opção explícita de "não seguir adiante".

## Governança de dados de pessoas

Classificação obrigatória antes de coletar qualquer dado:

```yaml
classe_R0_educacional:
  exemplos: ["frameworks", "checklists", "roteiros genéricos"]
  phi_permitido: false
  diagnostico_permitido: false
classe_R1_agregado:
  exemplos: ["clima agregado", "eNPS por time com n>=5"]
  phi_permitido: false
  regra: "nunca exibir recorte que identifique individuo"
classe_R2_sensivel:
  exemplos: ["saude mental", "avaliacao individual", "dados de desempenho"]
  exigencias:
    - "base legal e consentimento informado (LGPD)"
    - "acesso restrito e finalidade declarada"
    - "revisao humana antes de qualquer decisao"
    - "direito de revisao e apagamento"
  proibido:
    - "inferir diagnostico"
    - "usar como metrica de punicao ou promocao automatica"
    - "cruzar com produtividade individual sem auditoria"
```

Regras de ouro: agregar antes de analisar, **n mínimo = 5 por corte**, checar se a célula oculta pode ser inferida por subtração entre recortes, reportar tendência em vez de ranking individual, e sempre declarar para que o dado será usado.

Todo relatório de people analytics termina com a linha obrigatória:

```markdown
**O que estes dados NÃO permitem dizer:** [ex.: não identificam quem está em
risco, não explicam causa individual, não substituem conversa com a pessoa].
```

Nomes, "flight risk", pontuação individual e monitoramento contínuo de bem-estar por sinais comportamentais são **proibidos** nesta skill.

## Métricas que ajudam (e as que enganam)

| Útil | Cuidado |
|---|---|
| Voz em reuniões (quem fala, quem é interrompido) | Não é "quantidade de fala" como meta individual |
| Tempo até remover impedimento | Não virar corrida por número |
| eNPS / clima agregado com n≥5 | Não comparar times pequenos |
| Rotatividade voluntária por coorte | Não diagnosticar causas individuais |
| Cumprimento de 1:1s e feedback | Não medir "qualidade" por checkbox |

**Nunca** usar PHQ-9/GAD-7 ou qualquer escala clínica como KPI de RH.

## Anti-padrões

| Anti-padrão | Correção |
|---|---|
| "Cultura" como responsabilidade só do RH | Donos de time respondem por clima e carga |
| Pesquisa anônima com recorte de 2 pessoas | Definir n mínimo ou não reportar |
| Feedback só no ciclo anual | Tornar específico e frequente |
| Confundir silêncio com concordância | Convidar explicitamente a discordância |
| Cobrar entrega sem rever recursos | Aplicar JD-R antes de cobrar |
| "Diagnóstico" de colaborador a partir de comportamento | Encaminhar para canal apropriado, sem rótulo |
| Medir bem-estar para decidir promoção | Separar saúde de avaliação de desempenho |

## Referências

- [Edmondson (1999) — Psychological Safety and Learning Behavior in Work Teams](https://doi.org/10.2307/2666999)
- [Google Project Aristotle — re:Work](https://rework.withgoogle.com/en/guides/understanding-team-effectiveness)
- [Deci & Ryan — Self-Determination Theory](https://selfdeterminationtheory.org/)
- [Bakker & Demerouti — Job Demands-Resources model](https://www.sciencedirect.com/science/article/abs/pii/S037877530700509X)
- [WHO — Guidelines on mental health at work (2022)](https://www.who.int/publications/i/item/9789240053052)
- [NICE NG212 — Mental wellbeing at work](https://www.nice.org.uk/guidance/ng212)
- [ISO 30414:2025 — Human capital reporting](https://www.iso.org/standard/30414.html)
- [SHRM — Code of Ethics](https://www.shrm.org/legal/bylaws-and-code-of-ethics/code-of-ethics)
- [SIOP/APA — Principles for the Validation and Use of Personnel Selection Procedures](https://www.apa.org/ed/accreditation/personnel-selection-procedures.pdf)
- [EU AI Act — Reg. (UE) 2024/1689, Anexo III.4](https://eur-lex.europa.eu/eli/reg/2024/1689/oj)
- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework)
- [LGPD — Lei 13.709/2018](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)
- [tuanductran/hr-skills — router-first e governance (MIT)](https://github.com/tuanductran/hr-skills)
- [polar-bear-org/claude-skills — hr-dashboard e concern log (licença custom)](https://github.com/polar-bear-org/claude-skills)
- [msitarzewski/agency-agents — organizational-psychologist (MIT)](https://github.com/msitarzewski/agency-agents)

> Padrões adaptados e reescritos; a licença custom de `polar-bear-org` não foi copiada. Ferramentas de seleção e métricas exigem validação e dono humano.
