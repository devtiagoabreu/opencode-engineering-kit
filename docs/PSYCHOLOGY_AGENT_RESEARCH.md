# Pesquisa — Agentes e Skills de Psicologia

**Data da verificação:** 2026-11-25  
**Escopo:** psicologia clínica/psicoeducação, neurodiversidade (TEA/TDAH), crise/suicídio e psicologia organizacional/governança de pessoas.  
**Método:** busca na web + GitHub API (stars, licença, `pushed_at`) e leitura direta de `SKILL.md`/READMEs. Nenhum texto integral de upstream foi copiado; tudo foi reescrito no formato do kit.

## 1. Repositórios com skills/agents aproveitáveis

| Repositório | Stars | Licença | Ativo(s) / conteúdo | O que aproveitamos | Ressalva |
|---|---:|---|---|---|---|
| [FreedomIntelligence/OpenClaw-Medical-Skills](https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills) | 3.128 | não declarada | `mental-health-analyzer`, `crisis-detection-intervention-ai`, `adhd-daily-planner`, `jungian-psychologist` (869 skills) | Gate de crise em níveis, regra 3x, sistema das 3 coisas, externalização de memória | Licença ausente → **somente ideias**; nunca copiar texto |
| [theneoai/awesome-skills](https://github.com/theneoai/awesome-skills) | 206 | NOASSERTION | `skills/persona/healthcare/psychologist/SKILL.md` | Safety screen, disclaimers, tabela de anti-padrões, limites de escopo e integração entre personas | Licença ambígua no nível do repositório |
| [safety-quotient-lab/psychology-agent](https://github.com/safety-quotient-lab/psychology-agent) | 23 | Apache-2.0 | arquitetura cognitiva, hooks, flags epistêmicas, avaliador adversarial | *Epistemic flags*, anti-sycophancy, stance socrático | **Alpha**; README recomenda `dangerouslySkipPermissions` — não adotar a arquitetura |
| [ironyjk/counsel-frameworks](https://github.com/ironyjk/counsel-frameworks) | 4 | MIT | 14 frameworks (CBT, REBT, ACT, SFBT, MI, PPT, MBSR, MBCT, narrativa, IFS, Worden, DBT, Gottman, PCT) + roteador `/counsel` | Roteador 1–3 frameworks, pipelines sequenciais, detecção de crise, anti-padrões | Pequeno, mas muito bem delimitado |
| [dralexlup/therapy-skill](https://github.com/dralexlup/therapy-skill) | 4 | MIT | thought record, TIPP, DEAR MAN, chain analysis, não-sycophancy | Técnicas de regulação e análise multifatorial | Postura de "terapeuta" — incompatível com o limite do kit; só o mecanismo de crise |
| [xiaoye-hua/psychotherapist_agent](https://github.com/xiaoye-hua/psychotherapist_agent) | 5 | MIT | "living case file", crise rígida | Checagem direta e continuidade de contexto | Terapia longitudinal real — **fora do escopo** do kit |
| [alexclowe/awesome-claude-cowork-plugins](https://github.com/alexclowe/awesome-claude-cowork-plugins) | 31 | MIT | `clinical-mental-health`, `suicide-risk-assessment-protocol`, `trauma-informed-language-guardrails` | C-SSRS/SAFE-T, linguagem trauma-informed, separação de papéis | Foco em documentação clínica (EUA) |
| [rhavekost/clinical-toolkit](https://github.com/rhavekost/clinical-toolkit) | 3 | NOASSERTION | PHQ-2/9, GAD-7/2, PCL-5, C-SSRS, AUDIT-C, WHO-5 | Pontuação, faixas de corte e níveis de risco | Licença dos instrumentos precisa ser conferida antes de uso comercial |
| [salikkhann/openmedskills](https://github.com/salikkhann/openmedskills) | 5 | NOASSERTION | 83 skills governadas, classes de risco clínico | `risk_class`, `phi_allowed`, `diagnosis: false`, revisão humana | Melhor modelo de governança; sem licença clara |
| [robcushard-nth/autism_skills_suite](https://github.com/robcushard-nth/autism_skills_suite) | 6 | MIT | `autism-knowledge-core`, `autism-self-coach`, `autism-parent-coach`, `autism-scholarly-bibliography` | Checklist de revisão por adultos autistas e clínicos; CAA/PECS; 41 arquivos de referência | Verificar divergência de nome em relação a `nth-ai-dynamics/autism-skills-suite` |
| [murilonerdx/skill-engineering-tdah](https://github.com/murilonerdx/skill-engineering-tdah) | 3 | MIT | 26 skills de produtividade neurodivergente | Menus de estratégia em vez de prescrição única | — |
| [sundial-org/awesome-openclaw-skills](https://github.com/sundial-org/awesome-openclaw-skills) | 676 | não declarada | `therapy-mode`, `adhd-body-doubling`, `adhd-daily-planner` | Body doubling e adaptação de timer | Somente ideias |
| [K-Dense-AI/scientific-agents](https://github.com/K-Dense-AI/scientific-agents) | 259 | MIT | perfis "expert-thinking", inclui *Developmental Psychologist* | Estrutura de perfil e rigor de fontes | Não é conteúdo clínico |

## 2. Psicologia organizacional / governança de pessoas

| Repositório | Stars | Licença | Conteúdo | O que aproveitamos | Ressalva |
|---|---:|---|---|---|---|
| [tuanductran/hr-skills](https://github.com/tuanductran/hr-skills) | 92 | MIT | 146 skills: onboarding, performance, conflict, DEI, wellbeing, people analytics, AI governance | Router-first, gate de jurisdição, GOVERNANCE com `[Proposed]`, cobertura por tarefa | `hr-wellbeing` normaliza monitoramento contínuo — **rejeitado** |
| [polar-bear-org/claude-skills](https://github.com/polar-bear-org/claude-skills) | 72 | custom (`NOASSERTION`) | `hr-dashboard`, `hr-complaint-intake`, `hr-workplace-investigation`, `hr-pay-equity-audit`, `adopt-speak-up-practice`, `adopt-concern-response-log` | ISO 30414, n≥5, checagem por subtração, linha "o que isto não pode dizer", concern log em duas passagens, cláusula de segurança no speak-up | Licença veta revenda/redistribuição; somente ideias |
| [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) | ~170k | MIT | `organizational-psychologist.md`, `hr-onboarding.md` | "Diagnosticar condições, não caracteres"; evidência > pop psicologia; confiança antes de conflito | Exige instrumentos cadastrados — nunca inventar escores |
| [borghei/Claude-Skills](https://github.com/borghei/Claude-Skills) | 1.211 | MIT + Commons Clause (`NOASSERTION`) | `people-analytics`, `hr-business-partner`, `talent-acquisition` | Clarify-first, k-anonymity ≥5, SBI-E, ER em 5 etapas | Tratar como não comercializável até revisão jurídica |
| [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | 37.535 | MIT | índice de skills oficiais/community | Separação oficial vs. comunidade, compatibilidade por harness | É catálogo, não conteúdo clínico |

## 3. Base científica e normativa (fundamentação, não prompts)

| Fonte | Uso no kit |
|---|---|
| [C-SSRS](https://cssrs.columbia.edu/) e SAFE-T/NIMH | estratificação de risco e checagem direta |
| [Stanley-Brown Safety Plan](https://www.hopkinsmedicine.org/psychiatry/specialty-areas/suicide-prevention) | plano de segurança em 6 passos |
| [WHO mhGAP](https://www.who.int/publications/i/item/9789241549790) | gate de crise e rastreios em contextos de baixos recursos |
| [Emo-gml/Awesome-Mental-Health-LLMs](https://github.com/Emo-gml/Awesome-Mental-Health-LLMs) (146★, MIT, survey revisado por pares) | evidências sobre LLMs em saúde mental; riscos de dependência e viés |
| [Edmondson (1999)](https://doi.org/10.2307/2666999) e [Google Project Aristotle](https://rework.withgoogle.com/en/guides/understanding-team-effectiveness) | segurança psicológica |
| [Deci & Ryan](https://selfdeterminationtheory.org/) e [JD-R (Bakker & Demerouti)](https://www.sciencedirect.com/science/article/abs/pii/S037877530700509X) | autonomia/competência/vínculo; demandas vs. recursos |
| [WHO — mental health at work (2022)](https://www.who.int/publications/i/item/9789240053052) e [NICE NG212](https://www.nice.org.uk/guidance/ng212) | intervenções organizacionais e retorno ao trabalho |
| [ISO 30414:2025](https://www.iso.org/standard/30414.html), [SHRM Code of Ethics](https://www.shrm.org/legal/bylaws-and-code-of-ethics/code-of-ethics), [SIOP/APA](https://www.apa.org/ed/accreditation/personnel-selection-procedures.pdf) | métricas de capital humano, ética e validação de seleção |
| [EU AI Act — Anexo III.4](https://eur-lex.europa.eu/eli/reg/2024/1689/oj) e [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework) | IA para emprego/gestão como alto risco; mapear-medir-gerenciar |
| [LGPD — Lei 13.709/2018](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm) | consentimento, finalidade, mínimo necessário e direito de revisão |

## 4. Padrões que entraram no kit

1. **Gate de crise obrigatório:** detecção → 4 níveis → CVV 188/SAMU 192 → plano de segurança → sinalização humana (`mental-health-crisis-protocol`).
2. **Escalas como sinal, nunca diagnóstico:** PHQ-9/2, GAD-7, WHO-5, PCL-5, C-SSRS com faixas, tendência mínima e item 9 como gatilho (`evidence-based-scales`).
3. **Roteador de frameworks:** 1 principal + até 2 de apoio, micro-exploração de 5–10 min e critérios de encaminhamento (`counseling-frameworks`).
4. **Neurodiversidade afirmativa:** regra 3x, sistema das 3 coisas, buffers de transição, externalização e "feito > perfeito" (`adhd-executive-function`, `neurodiversity-support`).
5. **Governança de pessoas:** router-first, gate de jurisdição (BR/CLT/LGPD, EU/GDPR+AI Act, US), diagnóstico sistêmico (AMO/JD-R), n≥5, checagem por subtração, linha "o que estes dados não permitem dizer" e decisão de emprego sempre humana (`people-governance-psychology`, `psicologo-organizacional`).
6. **Anti-sycophancy e anti-padrões:** validar antes de aconselhar, uma pergunta por turno, nunca "vai ficar tudo bem", nunca abrir trauma em crise, nunca transformar escala em veredito.
7. **Evals de segurança:** 8 prompts com comportamento esperado e critério de reprovação em `assets/skills/health/mental-health-crisis-protocol/evals/evals.md`.

## 5. O que foi deliberadamente **não** adotado

- Postura de "terapeuta" / caso longitudinal / sessão terapêutica contínua.
- Arquitetura com `dangerouslySkipPermissions`, avaliadores adversarialmente agressivos e hooks que executam permissões amplas.
- Monitoramento contínuo de bem-estar por sinais comportamentais, flight-risk, pontuação individual de saúde mental ou "culture fit" oculto.
- Redação automática de demissão/PIP sem dono humano e sem gate de jurisdição.
- Números de emergência de outros países (988 etc.) — o kit usa CVV 188 / SAMU 192 / Bombeiros 193 e revalida antes de publicar.
- Texto integral de repositórios com licença ausente, `NOASSERTION`, Commons Clause ou condições de não revenda.
