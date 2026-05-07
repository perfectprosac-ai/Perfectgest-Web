# Atualiza - Evolucao Continua do Site PerfectPro

Este arquivo registra a evolucao tecnica do site para manter contexto entre IAs, evitar regressoes e garantir melhoria continua.

## Regras de uso (obrigatorio para proximas IAs)

- Ler este arquivo antes de propor alteracoes relevantes.
- Atualizar este arquivo ao final de qualquer tarefa tecnica.
- Nao apagar historico anterior; somente acrescentar novas entradas.
- Sempre registrar impacto, risco e validacao realizada.
- Em caso de mudanca de comportamento, registrar motivo e plano de rollback.

## Estado atual consolidado

- Projeto: `webs/Web_app`
- Stack principal: Flutter Web + assets web + docs operacionais
- Objetivo de manutencao: evoluir sem regressao funcional
- Situacao deste momento: inicializacao do sistema de acompanhamento criada

## KPIs de qualidade (atualizacao continua)

Preencher esta secao ao final de cada entrega relevante. Quando nao houver dado, usar `N/A` e justificar no registro da entrega.

### KPIs tecnicos principais

- Taxa de regressao por entrega (%): `N/A`
- Bugs criticos apos deploy (quantidade): `N/A`
- Bugs totais por entrega (quantidade): `N/A`
- Tempo medio de build web release (min): `N/A`
- Cobertura de testes automatizados (%): `N/A`
- Fluxos criticos validados manualmente (%): `N/A`
- Lints/erros estaticos novos (quantidade): `N/A`

### KPIs por periodo (rolling 30 dias)

- Entregas realizadas: `N/A`
- Entregas sem regressao: `N/A`
- Taxa de sucesso sem hotfix (%): `N/A`
- Hotfixes necessarios (quantidade): `N/A`
- Tempo medio de resolucao de incidente (h): `N/A`

### Meta de referencia (inicial)

- Regressao por entrega <= `5%`
- Bugs criticos apos deploy = `0`
- Cobertura de testes >= `60%` (expandir gradualmente)
- Fluxos criticos validados >= `90%`
- Lints novos por entrega = `0`

### Observacoes de medicao

- Medir regressao como: funcionalidades quebradas apos mudanca / funcionalidades alteradas.
- Considerar "fluxos criticos": login, navegacao principal, carregamento da home e SEO base.
- Atualizar valores com data no bloco de "Registro de evolucao".

## Modelo de entrada (copiar e preencher)

```md
## [AAAA-MM-DD HH:mm] Titulo curto da entrega

### Contexto
- Pedido:
- Escopo:

### Arquivos alterados
- caminho/arquivo_1
- caminho/arquivo_2

### O que foi feito
- Item 1
- Item 2

### Risco de regressao
- Baixo/Medio/Alto:
- Pontos sensiveis:

### Validacao executada
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado
- [ ] Outros:

### Resultado
- Comportamento esperado apos a mudanca:
- Pendencias:

### Proximos passos recomendados
- Passo 1
- Passo 2
```

## Registro de evolucao

## [2026-05-06 08:08] Inicializacao do acompanhamento continuo

### Contexto
- Pedido: criar o arquivo descrito em `.cursorrules` e iniciar acompanhamento da evolucao do site.
- Escopo: base documental para continuidade entre IAs.

### Arquivos alterados
- docs/Atualiza.md

### O que foi feito
- Criado o arquivo de rastreabilidade tecnica do site.
- Definido modelo padrao de registro para futuras entregas.
- Incluidas regras operacionais para prevenir perda de contexto e regressao.

### Risco de regressao
- Baixo: alteracao apenas documental, sem impacto em runtime.
- Pontos sensiveis: disciplina de atualizacao do arquivo em cada tarefa tecnica.

### Validacao executada
- [x] Revisao manual da estrutura e clareza do documento
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado
- [x] Sem alteracao de codigo executavel

### Resultado
- Comportamento esperado apos a mudanca: proximas IAs conseguem entender historico, decisoes e riscos antes de alterar codigo.
- Pendencias: comecar a preencher este registro a cada nova entrega tecnica.

### Proximos passos recomendados
- Incluir uma nova entrada apos cada mudanca em codigo/infra/documentacao critica.
- Padronizar checklist minimo de validacao por tipo de alteracao.

## [2026-05-06 08:11] Verificacao funcional e correcao de build

### Contexto
- Pedido: verificar se o codigo estava funcional e corrigir se necessario.
- Escopo: restaurar pipeline de analise, teste e build web release.

### Arquivos alterados
- pubspec.yaml
- lib/elastic_service.dart
- docs/Atualiza.md

### O que foi feito
- Corrigidos caminhos de assets movidos para `imagens/` no `pubspec.yaml`.
- Removida referencia de asset inexistente `assets/logo_PerfectPro_leve_cropped.png`.
- Adicionada dependencia `http` e posteriormente fixada em `1.5.0` por crash do `dart2js` com `1.6.0` no SDK atual.
- Substituidos `print` por `debugPrint` em `ElasticService` para atender lints de producao.
- Reexecutados `flutter analyze`, `flutter test` e `flutter build web --release`.

### Risco de regressao
- Baixo: mudancas concentradas em configuracao de assets e logs de servico.
- Pontos sensiveis: ao atualizar Flutter/Dart, revalidar se fixacao do `http` ainda e necessaria.

### Validacao executada
- [x] Analise estatica/lint
- [x] Build local
- [x] Teste manual do fluxo impactado
- [x] Outros: `flutter test` passou com sucesso

### Resultado
- Comportamento esperado apos a mudanca: projeto volta a compilar e gerar build web release sem erro de asset.
- Pendencias: considerar upgrade de SDK para remover necessidade de pin de dependencia no futuro.

### Proximos passos recomendados
- Testar navegacao das paginas principais no build gerado em `build/web`.
- Planejar janela de atualizacao de Flutter/Dart e revalidar `http` em versao mais nova.

## [2026-05-06 09:07] Renomeacao publica do site para PerfectGest I

### Contexto
- Pedido: alterar o nome visivel ao publico para "PerfectGest I" em todo o site.
- Escopo: textos de interface, titulos/metatags SEO e manifesto web.

### Arquivos alterados
- web/index.html
- web/manifest.json
- lib/main.dart
- lib/seo_meta_web.dart
- lib/tecnologias_page.dart
- lib/politica_page.dart
- docs/Atualiza.md

### O que foi feito
- Atualizado nome exibido na interface publica da home, politica e textos de contato.
- Atualizados titulos e descricoes SEO (Open Graph e document title) para "PerfectGest I".
- Atualizado `web/manifest.json` (`name` e `short_name`) para refletir a nova marca no PWA.
- Atualizado `web/index.html` (title, og:title e apple-mobile-web-app-title).

### Risco de regressao
- Baixo: mudanca textual sem alteracao de fluxo funcional.
- Pontos sensiveis: manter consistencia da marca em novos textos futuros.

### Validacao executada
- [x] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado
- [x] Outros: checagem de lints da IDE sem erros nos arquivos alterados

### Resultado
- Comportamento esperado apos a mudanca: nome publico do site exibido como "PerfectGest I" em UI e metadados principais.
- Pendencias: validar visualmente no browser os pontos de UI alterados.

### Proximos passos recomendados
- Regerar `build/web` e recarregar o navegador para confirmar titulo e manifesto atualizados.
- Revisar documentos externos/marketing para padronizar a nova marca quando aplicavel.

## [2026-05-07 07:58] Ajuste de ordem e tipografia no primeiro bloco

### Contexto
- Pedido: corrigir a ordem das frases no primeiro bloco da home e ajustar o nome principal.
- Escopo: secao Hero em `lib/main.dart`.

### Arquivos alterados
- lib/main.dart
- docs/Atualiza.md

### O que foi feito
- Alterado o texto principal do Hero de `PerfectGest I` para `PerfectGest`.
- Ajustado o tamanho da fonte de `PerfectGest` para o mesmo tamanho da frase `Inovacao em Flutter, Java e SDKs`.
- Reordenado o bloco para exibir `Inovacao em Flutter, Java e SDKs` imediatamente abaixo de `PerfectGest`.

### Risco de regressao
- Baixo: alteracao textual e de ordem visual no Hero, sem mudanca de fluxo.
- Pontos sensiveis: validar em mobile e desktop para garantir hierarquia visual esperada.

### Validacao executada
- [x] Revisao manual do trecho alterado
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: primeiro bloco da home exibe a ordem solicitada e nome sem sufixo `I`.
- Pendencias: validacao visual em navegador para confirmar percepcao de tamanho e espacos.

### Proximos passos recomendados
- Executar `flutter run -d chrome` e validar o Hero em breakpoints desktop/mobile.
- Se necessario, ajustar `fontWeight` para reforcar contraste mantendo o mesmo `fontSize`.

## [2026-05-07 08:00] Padronizacao visual de tipografia no Hero

### Contexto
- Pedido: igualar visualmente o tamanho do texto descritivo principal ao da frase iniciada por "Software house...".
- Escopo: ajuste tipografico no primeiro bloco da home.

### Arquivos alterados
- lib/main.dart
- docs/Atualiza.md

### O que foi feito
- Mantido o `fontSize` existente e padronizada a fonte do texto descritivo para `GoogleFonts.inter`, alinhando com a frase "Software house...".
- Aplicado o ajuste nos dois ramos visuais do Hero (com e sem `ShaderMask`), para consistencia em claro/escuro e com/sem animacao.

### Risco de regressao
- Baixo: alteracao apenas tipografica local no Hero.
- Pontos sensiveis: revisar legibilidade em telas compactas.

### Validacao executada
- [x] Revisao manual do trecho alterado
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: texto descritivo com proporcao visual equivalente ao bloco "Software house...", sem discrepancia de fonte.
- Pendencias: validar no navegador o resultado final em desktop e mobile.

### Proximos passos recomendados
- Executar `flutter run -d chrome` e validar o primeiro bloco em diferentes larguras.
- Se ainda houver percepcao de diferenca, ajustar apenas `fontWeight` mantendo o mesmo `fontSize`.

## [2026-05-07 08:16] Reversao da ultima alteracao tipografica no primeiro bloco

### Contexto
- Pedido: desfazer a ultima alteracao no 1o bloco e manter `PerfectGest` como esta.
- Escopo: texto descritivo principal do Hero em `lib/main.dart`.

### Arquivos alterados
- lib/main.dart
- docs/Atualiza.md

### O que foi feito
- Revertida a alteracao tipografica do texto "Criamos apps Flutter, sistemas web e integracoes Java/SDK...".
- Restaurado `TextStyle` original nesse texto (ramos com e sem `ShaderMask`).
- Mantido `PerfectGest` sem qualquer mudanca.

### Risco de regressao
- Baixo: reversao pontual de estilo visual.
- Pontos sensiveis: confirmar visual no navegador apos hot reload.

### Validacao executada
- [x] Revisao manual do trecho alterado
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: 1o bloco volta ao estado anterior da tipografia do texto descritivo, mantendo o titulo `PerfectGest`.
- Pendencias: validacao visual final no browser.

### Proximos passos recomendados
- Aplicar hot reload e verificar o Hero em desktop/mobile.

## [2026-05-07 08:44] Troca de imagens no bloco Solucoes (App/Web)

### Contexto
- Pedido: trocar as imagens internas do bloco `Solucoes (App/Web)` pelas novas da pasta `IMAGENS_APP/Screenshot`.
- Escopo: cards de mockup em `AnimatedSolutionsSectionContent`.

### Arquivos alterados
- lib/main.dart
- docs/Atualiza.md

### O que foi feito
- Atualizadas as duas referencias de `imageAsset` dos dispositivos para:
  - `IMAGENS_APP/Screenshot/PerfectGest (1).png`
  - `IMAGENS_APP/Screenshot/PerfectGest (2).png`
- Mantidas as configuracoes de dimensao/posicionamento e fallback para reduzir risco visual.

### Risco de regressao
- Baixo: alteracao apenas de caminho de assets.
- Pontos sensiveis: nomes com espacos e parenteses exigem correspondencia exata no asset.

### Validacao executada
- [x] Revisao manual dos caminhos no codigo
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: bloco `Solucoes (App/Web)` renderiza as novas imagens `PerfectGest (1)` e `PerfectGest (2)`.
- Pendencias: validar renderizacao no navegador com hot reload ou novo build web.

### Proximos passos recomendados
- Abrir o site localmente e confirmar crop/enquadramento dos dois mockups.
- Se houver corte indesejado, ajustar `imageLeft`, `imageTop`, `imageWidth` e `imageHeight`.

## [2026-05-07 09:04] Correcao de compilacao Web apos troca de assets

### Contexto
- Pedido: erro ao compilar `lib/main.dart` para Web e site sem atualizar no servidor.
- Escopo: manifesto de assets em `pubspec.yaml`.

### Arquivos alterados
- pubspec.yaml
- docs/Atualiza.md

### O que foi feito
- Corrigidas as referencias de assets antigas removidas da pasta `IMAGENS_APP/Screenshot`.
- Atualizado para os novos ficheiros:
  - `IMAGENS_APP/Screenshot/PerfectGest (1).png`
  - `IMAGENS_APP/Screenshot/PerfectGest (2).png`
- Mantida a entrada `IMAGENS_APP/` e ajustadas entradas explicitas para evitar falha de compilacao.

### Risco de regressao
- Baixo: alteracao apenas em declaracao de assets.
- Pontos sensiveis: nomes com espacos/parenteses exigem quote e caminho exato.

### Validacao executada
- [x] Reproducao do erro de compilacao
- [x] Revisao manual do `pubspec.yaml`
- [ ] Build local completo
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: compilacao web volta a funcionar sem erro de asset ausente.
- Pendencias: subir servidor limpo e validar visualmente o bloco `Solucoes (App/Web)`.

### Proximos passos recomendados
- Executar `flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8100`.
- Fazer `Ctrl + F5` no navegador para invalidar cache.

## [2026-05-07 09:37] Equalizacao de tamanho visual no texto principal do Hero

### Contexto
- Pedido: deixar a frase "Criamos apps Flutter, sistemas web e integracoes Java/SDK..." com o mesmo tamanho da frase "Software house especializada...".
- Escopo: tipografia do bloco Hero em `lib/main.dart`.

### Arquivos alterados
- lib/main.dart
- docs/Atualiza.md

### O que foi feito
- Padronizada a frase "Criamos apps..." para o mesmo estilo base da frase "Software house...":
  - `GoogleFonts.inter`
  - `fontSize: heroSubtitleSize`
  - `height: 1.45`
- Aplicado nos dois caminhos de renderizacao (com `ShaderMask` e sem `ShaderMask`).

### Risco de regressao
- Baixo: ajuste local de tipografia sem impacto funcional.
- Pontos sensiveis: validacao visual em tela pequena e grande.

### Validacao executada
- [x] Revisao manual do trecho alterado
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: as duas frases ficam com o mesmo tamanho visual.
- Pendencias: confirmar no navegador com refresh forcado.

### Proximos passos recomendados
- Recarregar `http://localhost:8100` com `Ctrl + F5`.
- Se desejar mais destaque mantendo tamanho, ajustar apenas contraste/cor.

## [2026-05-07 10:07] Inclusao do GA4 com novo ID no site

### Contexto
- Pedido: incluir o snippet Google tag (`gtag.js`) nas paginas do site com ID `G-N4BVXV4HBC` e continuar a publicacao.
- Escopo: `web/index.html` (entrada base do Flutter Web).

### Arquivos alterados
- web/index.html
- docs/Atualiza.md

### O que foi feito
- Removida a injecao customizada anterior de GA baseada em localStorage/consentimento.
- Inserido snippet direto solicitado:
  - script async `gtag/js?id=G-N4BVXV4HBC`
  - `gtag('config', 'G-N4BVXV4HBC')`

### Risco de regressao
- Medio: mudanca no fluxo de medicao/cookies (de condicional para carregamento direto).
- Pontos sensiveis: revisar conformidade de consentimento conforme politica vigente.

### Validacao executada
- [x] Revisao manual do `index.html`
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: GA4 inicializa diretamente no carregamento da pagina com o novo Measurement ID.
- Pendencias: concluir publish e validar eventos no GA4 DebugView/Realtime.

### Proximos passos recomendados
- Executar publicacao e validar carregamento do `gtag/js` no browser.
- Confirmar recebimento de evento `page_view` no GA4.

## [2026-05-07 11:12] Reposicionamento do snippet GA4 para o head

### Contexto
- Pedido: corrigir posicao do codigo do Analytics para ficar antes de `</head>`.
- Escopo: `web/index.html`.

### Arquivos alterados
- web/index.html
- docs/Atualiza.md

### O que foi feito
- Movido o snippet GA4 (`gtag.js` + `gtag('config', 'G-N4BVXV4HBC')`) do `body` para o `head`.
- Posicionado imediatamente antes do fechamento `</head>`, conforme solicitado.

### Risco de regressao
- Baixo: ajuste de posicionamento de script sem mudanca de ID/config.
- Pontos sensiveis: validar disparo de `page_view` no GA4 apos deploy.

### Validacao executada
- [x] Revisao manual do `index.html`
- [ ] Analise estatica/lint
- [ ] Build local
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: Analytics carregado na fase correta do documento (`head`).
- Pendencias: publicar e validar eventos em Realtime/DebugView.

### Proximos passos recomendados
- Publicar novamente e fazer `Ctrl + F5` no browser.
- Confirmar o request para `googletagmanager.com/gtag/js?id=G-N4BVXV4HBC`.

## [2026-05-07 11:32] Correcao de pipeline para Render (build/web atualizado)

### Contexto
- Pedido: corrigir conflito de atualizacao no online, onde Render publica `build/web/index.html` e o fonte atual fica em `web/index.html`.
- Escopo: script de publicacao `scripts/publish-web.cjs`.

### Arquivos alterados
- scripts/publish-web.cjs
- docs/Atualiza.md

### O que foi feito
- Ajustado parser de `--msg` para aceitar mensagens com espacos sem quebrar o comando.
- Atualizado `git add` do script para incluir explicitamente artefatos de deploy:
  - `build/web`
  - `IMAGENS_APP/Screenshot`
- Mantidos tambem os ficheiros-fonte (`lib`, `web`, `pubspec*`, `.gitignore`, `docs/Atualiza.md`).

### Risco de regressao
- Baixo: ajuste de automacao de publicacao.
- Pontos sensiveis: confirmar se o fluxo de deploy no Render continua apontando para `build/web`.

### Validacao executada
- [x] Revisao manual do script alterado
- [ ] Execucao de publish completo
- [ ] Validacao online no Render
- [ ] Teste manual do fluxo impactado

### Resultado
- Comportamento esperado apos a mudanca: cada publicacao leva `build/web` atualizado para o remoto, eliminando divergencia entre `web/index.html` fonte e artefato servido no Render.
- Pendencias: executar publish e validar o online.

### Proximos passos recomendados
- Rodar `npm run publish-web -- --msg="fix: ajuste render build web"`.
- Aguardar deploy do Render e testar em janela anonima.

## [2026-05-07 11:32] Ajuste final no publish para incluir build ignorado

### Contexto
- Pedido: corrigir conflito de atualizacao no Render.
- Escopo: garantir staging de `build/web` mesmo com `build/` no `.gitignore`.

### Arquivos alterados
- scripts/publish-web.cjs
- docs/Atualiza.md

### O que foi feito
- Adicionado passo explicito no script:
  - `git add -A -f build/web`
- Mantido `git add -A` dos ficheiros-fonte para acompanhar o artefato compilado.

### Risco de regressao
- Baixo: ajuste de automacao de commit/deploy.
- Pontos sensiveis: aumento de diff no commit por incluir artefatos web.

### Validacao executada
- [x] Reproducao do erro de staging de build ignorado
- [x] Revisao manual do script
- [ ] Publicacao completa apos ajuste
- [ ] Validacao online no Render

### Resultado
- Comportamento esperado apos a mudanca: publicacao passa a incluir `build/web/index.html` atualizado no remoto.
- Pendencias: reexecutar publish e verificar o deploy do Render.

### Proximos passos recomendados
- Executar novamente `npm run publish-web -- --msg="fix: ajuste render build web"`.
- Testar no online com cache limpo.

## [2026-05-07 11:32] Correcao da ordem de staging no script de publish

### Contexto
- Pedido: resolver bloqueio final de publish por conflito com `.gitignore` em `build/`.
- Escopo: `scripts/publish-web.cjs`.

### Arquivos alterados
- scripts/publish-web.cjs
- docs/Atualiza.md

### O que foi feito
- Removido `build/web` do primeiro `git add -A` (sem `-f`) para evitar erro imediato.
- Mantido o passo dedicado `git add -A -f build/web` como unica etapa de staging dos artefatos ignorados.

### Risco de regressao
- Baixo: ajuste de ordem operacional no script.
- Pontos sensiveis: tempo alto de compilacao web durante publish.

### Validacao executada
- [x] Reproducao do erro
- [x] Ajuste no script
- [ ] Publish completo apos correcao
- [ ] Validacao no Render

### Resultado
- Comportamento esperado apos a mudanca: script deixa de falhar no staging e conclui commit/push com `build/web` atualizado.
- Pendencias: reexecutar publicacao.

### Proximos passos recomendados
- Rodar novamente o publish com mensagem curta sem caracteres especiais.
- Validar deploy no Render apos push.
