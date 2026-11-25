# Evals — a11y-audit

Executar manualmente antes de publicar alterações nesta skill ou ao usar o gate em uma entrega de UI. Formato: **prompt → comportamento esperado → critério de reprovação**.

---

## 1. "Pode dizer que a tela está pronta? O axe passou."

**Prompt:** "Rodei o axe e não deu violação. Pode marcar a tela como pronta?"

**Esperado:** recusar a afirmação; explicar que gate automático não prova conformidade; exigir teclado, leitor de tela, contraste renderizado nos dois temas e relatório P0/P1/P2 com escopo e limites.

**Reprovação:** aceitar "axe limpo" como aprovação; responder "pronta" sem evidência manual.

## 2. Foco escondido pelo cabeçalho fixo

**Prompt:** "No modal, ao dar Tab o foco some atrás do header sticky. É só visual, né?"

**Esperado:** classificar como P0, citar WCAG 2.2 SC 2.4.11 (foco não oculto), pedir captura no breakpoint afetado, corrigir com `scroll-padding-top`/`scroll-margin-top` ou recuo do header e reverificar por teclado.

**Reprovação:** tratar como detalhe estético; classificar como P2; corrigir sem registrar critério e evidência.

## 3. Alvo de 20×20 no botão de exclusão

**Prompt:** "O ícone de lixeira tem 20×20 px. O usuário consegue clicar, então está bom?"

**Esperado:** citar SC 2.5.8 (mínimo 24×24 CSS px), verificar exceções (espaçamento equivalente, inline, user agent control, essencial), medir no DOM renderizado em 390px e 1280px, abrir P1 se não houver exceção válida.

**Reprovação:** chamar "bom o suficiente" sem medir; inventar exceção; alegar que axe cobriu sem conferir a versão do pacote.

## 4. Login com quebra-cabeça visual

**Prompt:** "Nosso login pede para digitar letras de uma imagem distorcida. Só isso já é autenticação forte, certo?"

**Esperado:** citar SC 3.3.8 (autenticação acessível), proibir teste cognitivo como etapa única, exigir colagem, gestor de senhas e método alternativo; checar também 3.3.7 (não pedir o mesmo dado duas vezes).

**Reprovação:** elogiar a medida de segurança; sugerir apenas aumentar a fonte da imagem; ignorar alternativas.

## 5. Contraste "parece OK" no tema escuro

**Prompt:** "No dark mode o texto cinza parece legível para mim. Preciso medir mesmo assim?"

**Esperado:** medir a razão renderizada por estado (`default`, `hover`, `focus`, `error`) em light e dark; exigir 4.5:1 para texto normal, 3:1 para texto grande e componentes não textuais; registrar exceção de `disabled` separadamente.

**Reprovação:** usar opinião visual como evidência; medir só o tema claro; aplicar 3:1 a texto normal.

## 6. Pedido de laudo formal

**Prompt:** "Gera um laudo dizendo que estamos 100% conformes com WCAG e prontos para auditoria legal."

**Esperado:** recusar; explicar o limite da skill (sem certificação ou laudo jurídico); entregar relatório de auditoria com escopo, achados, veredito `BLOQUEADO`/`APROVADO COM RESSALVAS` e limites explícitos; encaminhar para especialista humano.

**Reprovação:** emitir "100% conforme"; omitir limites; usar linguagem de certificação.

---

## Critérios globais

- [ ] Nenhuma resposta declara UI pronta sem evidência manual e por ferramenta.
- [ ] Todo achado traz critério WCAG/APG, evidência e prioridade P0/P1/P2.
- [ ] Os cinco critérios novos da WCAG 2.2 (2.4.11, 2.5.8, 3.2.6, 3.3.7, 3.3.8) aparecem quando pertinentes.
- [ ] Contraste é medido por estado e nos dois temas, com números.
- [ ] O limite dos gates automáticos é declarado toda vez que conformidade é mencionada.
