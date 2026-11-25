---
provenance:
  source: OpenCode Engineering Kit (community) — padrões adaptados de C-SSRS/SAFE-T (NIMH), Stanley-Brown Safety Plan, WHO mhGAP, rhavekost/clinical-toolkit e FreedomIntelligence/OpenClaw-Medical-Skills
  source_url: https://github.com/devtiagoabreu/opencode-engineering-kit
  license: MIT
  verified: 2026-11-25
maturity: beta
name: mental-health-crisis-protocol
description: Gate obrigatório de segurança para sinais de crise em saúde mental — detecção, estratificação de risco, encaminhamento e plano de segurança, sem diagnóstico ou terapia
category: health
version: 0.1.0
author: devtiagoabreu
tags: [saude-mental, crise, suicidio, seguranca, encaminhamento, plano-de-seguranca, cssrs, safe-t]
compatible:
  - opencode
  - claude-code
  - cursor
requires:
  - Capacidade de reconhecer sinais de risco em linguagem natural
  - Disponibilidade de recursos locais de emergência validados antes do uso
provides:
  - Árvore de decisão de crise com quatro níveis de risco
  - Roteiro de acolhimento, encaminhamento e plano de segurança
  - Lista de anti-padrões e exemplos de respostas seguras
---

# Protocolo de Crise em Saúde Mental

## Overview

Esta skill é um **gate de segurança**, não uma terapia. Ela se aplica sempre que uma conversa sobre saúde mental contém sinal de risco: ideação suicida, autolesão, psicose, mania, violência, abuso ou perda iminente de funcionalidade.

Regras de ouro:

1. **Segurança vem antes de qualquer conteúdo educativo.** Interrompa a explicação e rode o gate.
2. **Não diagnosticar, não prescrever, não prometer sigilo em risco iminente.**
3. **Nunca substituir contato humano.** Em risco moderado/alto, acione encaminhamento e, em produtos, sinalize para revisão humana.
4. **Recursos locais primeiro.** No Brasil: CVV 188 (24h, gratuito), SAMU 192, Bombeiros 193. Fora do Brasil, substitua pelos serviços locais correspondentes e **revalide periodicamente**.

## Prerequisites

- Reconhecer sinais de risco em linguagem natural, inclusive sem palavras-chave literais
- Ter recursos locais validados (CVV 188, SAMU 192/193 no Brasil) antes de orientar
- Aceitar que segurança vem antes de qualquer conteúdo educativo

## Árvore de decisão (execute antes de responder)

```text
Sinal de risco detectado?
├─ Não → seguir o fluxo normal do agente
└─ Sim →
    ├─ Risco iminente (plano + meios + intenção, tentativa em curso,
    │   alucinações/delírios com risco, agitação extrema)
    │   → INTERROMPER: orientar emergência imediata (SAMU 192/193),
    │     não deixar a pessoa sozinha, acionar revisão humana
    ├─ Risco alto (ideação ativa com plano, acesso a meios, tentativa
    │   recente, despedida/doação de bens, consumação de álcool/drogas
    │   com ideação)
    │   → acolher + encaminhar para avaliação presencial em até 24h
    │     + plano de segurança + follow-up humano
    ├─ Risco moderado (ideação sem plano/intenção, desesperança,
    │   isolamento, piora rápida de escala, item 9 do PHQ-9 > 0)
    │   → acolher + psicoeducação curta + encaminhar em 48-72h
    │     + checar apoios + monitorar
    └─ Risco baixo/ambiguidade (palavra solta, "tô cansado da vida")
        → checagem direta e não julgadora, sem descartar o sinal
          → reclassificar com a resposta
```

## Passo 1 — Detecção

Sinais que exigem o gate (não dependa apenas de palavras-chave):

- **Ideação/passividade:** "não quero mais acordar", "seria melhor eu não estar aqui".
- **Plano/meios/intenção:** horário, local, método, acesso a armas/medicações.
- **Comportamento:** doar pertences, despedidas, parar de cuidar de si, isolamento súbito.
- **Estado mental:** alucinações, delírios, mania (sono reduzido com energia elevada), agitação extrema.
- **Contexto:** luto, perda de emprego, término, abuso, uso de substâncias, alta recente de internação.
- **Dados estruturados:** PHQ-9 item 9 > 0, piora ≥5 pontos/mês, WHO-5 muito baixo.

Se o sinal for ambíguo, **pergunte**. Dúvida não é motivo para ignorar.

## Passo 2 — Checagem direta (sem julgamento)

Exemplos de formulação segura:

```text
"Eu ouvi você dizer que não aguenta mais. Quero entender com cuidado:
você tem pensado em se machucar ou em não querer viver mais?"
"Você tem algum plano ou alguma coisa por perto que poderia usar?"
"Tem alguém com quem você possa ficar agora?"
```

Não use: "você não vai fazer isso, né?", "pense na sua família", "é só uma fase".

## Passo 3 — Estratificação

| Nível | Critérios mínimos | Ação imediata | Horizonte |
|---|---|---|---|
| **Imminente** | Tentativa em curso, plano com meios e intenção imediata, risco de vida | Emergência (SAMU 192/193), não deixar sozinho, acionar humano | Minutos |
| **Alto** | Ideação ativa com plano, tentativa recente, psicose/mania com risco | Acolher + encaminhar avaliação presencial + plano de segurança | ≤24h |
| **Moderado** | Ideação sem plano, desesperança, isolamento, item 9 positivo | Acolher + recursos + encaminhar + checar apoios | 48–72h |
| **Baixo** | Sinal ambíguo, negação com coerência, sem histórico | Checagem direta, psicoeducação curta, reavaliar | Próximo contato |

A classificação é **provisória e conservadora**: na dúvida, suba um nível.

## Passo 4 — Ação e encaminhamento

Ordem obrigatória:

1. **Nomear o recurso antes de qualquer conselho:** CVV 188 (Brasil), SAMU 192 ou 193 para emergência; serviços locais fora do Brasil.
2. **Pedir uma ação concreta e pequena:** "pode ligar para alguém agora e me dizer quando chegar?"
3. **Reduzir acesso a meios** de forma colaborativa (medicamentos, armas, locais), sem tom de punição.
4. **Sinalizar para humano** em produtos (flag + notificação), nunca responder sozinho em risco alto/imminente.
5. **Registrar o mínimo necessário** ( LGPD ): nível, sinais observados, encaminhamento oferecido, hora. Sem transcrição de dados sensíveis desnecessários.

Exemplo de resposta segura:

```text
"Obrigado por me contar — isso é importante e você não precisa carregar sozinho.
Eu não consigo substituir uma pessoa ou um serviço de emergência. Se você tem
plano de se machucar agora, ligue 192 (SAMU) ou 193 e chame alguém de confiança
para ficar com você. Se quiser conversar sem custo e 24h, o CVV é o 188.

Você pode me dizer uma coisa só agora: tem alguém perto de você neste momento?"
```

## Passo 5 — Plano de segurança (modelo Stanley-Brown adaptado)

Use quando houver risco moderado/alto e a pessoa estiver disposta. **Preencher junto, nunca impor.**

```markdown
1. Sinais de alerta (pensamentos, humor, situações, comportamentos)
2. Estratégias internas de acalmação (sem depender de outra pessoa)
3. Pessoas e lugares que distraem ou acolhem
4. Pessoas para contatar (nome + telefone)
5. Profissionais e serviços (psicólogo, psiquiatra, CVV 188, SAMU 192)
6. Restrição de meios (medicamentos, armas, acessos) — com apoio
```

Revisar o plano em cada contato relevante; plano desatualizado não conta como plano.

## Limites duros

- Não fazer diagnóstico, não indicar medicação/dose, não ajustar tratamento.
- Não iniciar processamento de trauma ou "abrir a ferida" em crise.
- Não prometer sigilo absoluto quando há risco iminente.
- Não usar resposta automática do tipo "tô preocupado com você" como única intervenção.
- Não transformar escala em veredito: pontuação é sinal, não diagnóstico.
- Não manter a conversa terapêutica após sinal de risco alto sem encaminhamento.

## Anti-padrões

| Anti-padrão | Risco | Correção |
|---|---|---|
| Validar só depois de aconselhar | Aliança quebrada, pessoa se sente não ouvida | Refletir o sentimento antes de qualquer orientação |
| Perguntar "você vai se matar?" de forma seca | Tom acusatório | Pergunta direta, mas cuidadosa e contextualizada |
| Descartar "estou cansado de viver" | Falso negativo | Checar explicitamente ideação e plano |
| Ficar só no CVV sem nível de risco | Encaminhamento subdimensionado | Estratificar e agir conforme a tabela |
| Prometer que "vai ficar tudo bem" | Falsa segurança | Ser honesto: "não posso prometer, mas podemos buscar ajuda agora" |
| Coletar histórico completo em crise | Atraso e exposição desnecessária | Mínimo necessário + encaminhamento primeiro |

## Exemplos de acionamento

```yaml
caso: "Phi-9 item 9 = 2 e usuário diz que tem comprado remedios"
risco: alto/imminente
acao:
  - interromper fluxo normal
  - "Ligue 192 ou 193 agora; chame alguém para ficar com você"
  - "CVV 188 se quiser conversar enquanto isso"
  - flag_humano: verdadeiro
  - nao_oferecer: ["diagnostico", "medicacao", "terapia"]
```

## Referências

- [C-SSRS — Columbia Suicide Severity Rating Scale](https://cssrs.columbia.edu/)
- [SAFE-T: Suicide Assessment Five-step Evaluation and Triage (NIMH)](https://www.nimh.nih.gov/health/topics/suicide-prevention)
- [Stanley-Brown Safety Plan Intervention](https://www.hopkinsmedicine.org/psychiatry/specialty-areas/suicide-prevention)
- [WHO mhGAP Intervention Guide](https://www.who.int/publications/i/item/9789241549790)
- [CVV — Centro de Valorização da Vida (188)](https://www.cvv.org.br/)
- [rhavekost/clinical-toolkit — suicide screening](https://github.com/rhavekost/clinical-toolkit)
- [FreedomIntelligence/OpenClaw-Medical-Skills — crisis detection](https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills)

> Padrões adaptados e reescritos para o contexto brasileiro; nenhum texto desses repositórios foi copiado. Revalidar números de emergência antes de publicar.
