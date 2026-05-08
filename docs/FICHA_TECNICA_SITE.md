# Ficha técnica — Site PerfectPro (Web_app)

## 1. Identificação

| Campo | Valor |
|--------|--------|
| Nome do pacote | `perfectpro_web` |
| Descrição | Site promocional PerfectPro — Flutter Web |
| Versão | `1.0.0+1` (pubspec) |
| Raiz do projeto | `PerfectPro/webs/Web_app` |
| Repositório | Privado (`publish_to: none`) |

## 2. Stack e ambiente

| Item | Detalhe |
|------|---------|
| Framework | Flutter (Material 3) |
| Linguagem | Dart |
| SDK Dart | `^3.11.4` |
| Alvos relevantes | **Web**, Android (mesmo código; site focado em web) |
| UI | `MaterialApp`, temas claro/escuro (`ThemeMode`) |

## 3. Dependências principais (pubspec)

| Pacote | Uso típico no projeto |
|--------|------------------------|
| `google_fonts` | Tipografia (ex.: Inter, JetBrains Mono) |
| `url_launcher` | WhatsApp, site, e-mail / Gmail na web |
| `go_router` | Declarado; roteamento principal da home é `Navigator` + página “Sobre nós” |
| `fl_chart` | Gráficos (seção/portfolio conforme layout) |
| `qr_flutter` | QR codes |
| `particles_flutter` | Efeitos de partículas (hero/decor) |
| `web` | Integração DOM em `seo_meta_web.dart` |
| `flutter_localizations` | Suporte a localização Material |
| `cupertino_icons` | Ícones iOS-style quando necessário |

## 4. Estrutura de código (`lib/`)

| Ficheiro | Função |
|----------|--------|
| `main.dart` | Entrada: `main()` → SEO meta → `PerfectProSiteApp`. Home com scroll, cabeçalho fixo, secções (Hero, Soluções, Portfolio, Contato), navegação “Sobre nós”, animações e contactos |
| `app_theme.dart` | Temas claro/escuro; constantes `kWhatsAppDigits`, `kEmailSac` |
| `seo_meta_web.dart` | Web: injeta/atualiza meta tags no `<head>` |
| `seo_meta_stub.dart` | Não-web: no-op |
| `elastic_service.dart` | Cliente HTTP de teste (endpoint configurável); usado a partir de certas ações (ex.: ícone WhatsApp em “Sobre nós”) |

## 5. Web estático e PWA

| Recurso | Local / notas |
|---------|----------------|
| Entrada HTML | `web/index.html` — carrega `flutter_bootstrap.js`, meta SEO, canonical, Google Analytics (placeholder `G-XXXXXXXXXX`) |
| Manifest PWA | `web/manifest.json` — nome, cores, ícones 192/512, maskable, `display: standalone` |
| Build web | Saída: `build/web/` após `flutter build web` |

## 6. Assets

Registados em `pubspec.yaml` (raiz do app e pastas):

- Logos na raiz: `logo_icone.png`, `logo_retangulo.png`, `logopixel+.png`
- Pasta `assets/`: variantes de logo PerfectPro (PNG/WebP)
- Pasta `IMAGENS_APP/`: imagens do site (logo transparente, screenshots, etc.)

## 7. Funcionalidades resumidas

| Área | Comportamento |
|------|----------------|
| Cabeçalho | Logo + nome PerfectPro, WhatsApp, e-mail, alternância de tema, menu com scroll para secções + “Sobre nós” (nova rota) |
| Home | `SingleChildScrollView` + `GlobalKey` para âncoras; altura reservada para header fixo (~76 px) |
| Soluções (App/Web) | `AnimatedSolutionsSectionContent`: mockups `DeviceFrame`, textos Apps/Web, animações e parallax (respeita “reduzir movimento”) |
| Portfolio | `PortfolioMotionBlock`: texto e chips animados |
| Contato | Chips telefone/e-mail; botão “Enviar mensagem (WhatsApp)” abre `wa.me` com texto pré-preenchido |
| WhatsApp | `https://wa.me/<kWhatsAppDigits>`; opcional `?text=` para mensagem inicial |
| E-mail | **Web:** composição Gmail (`mail.google.com`…). **Nativo:** `mailto:` com assunto “Contato PerfectPro” |
| Site externo | Link `https://perfectpro-webpageoficial.onrender.com/` no nome da marca |
| Acessibilidade | `Semantics` em blocos principais; animações reduzidas quando o SO pede |

## 8. Constantes de contacto (código)

Definidas em `lib/app_theme.dart` (revisar em produção se mudarem):

- WhatsApp (E.164 sem símbolos): `5551989045442`
- E-mail SAC: `perfectpro.sac@gmail.com`

## 9. Android (mesmo repositório)

- `AndroidManifest.xml`: `queries` para `https`, `http` e `mailto` / intents de texto (visibilidade de pacotes Android 11+).
- Label da app: “PerfectPro Web”.

## 10. Scripts Node (opcional)

Na raiz `Web_app` existe `package.json` com dependências para integração/teste (ex.: `@elastic/elasticsearch`, `express`) e scripts em `scripts/` para diagnóstico de backend — **não fazem parte do bundle Flutter** servido ao browser.

## 11. Comandos úteis

```text
flutter pub get
flutter analyze
flutter run -d chrome
flutter run -d web-server --web-hostname=127.0.0.1 --web-port=<porta>
flutter build web --release
```

Nota: em Windows, se a porta do servidor web já estiver em uso, o `flutter run` falha com erro de socket; use outra porta ou encerre o processo que escuta na porta.

## 12. Testes

- `test/widget_test.dart` — testes Flutter de widget (conforme projeto).

---

*Documento gerado a partir da estrutura do repositório `PerfectPro/webs/Web_app`. Atualizar quando mudarem dependências, URLs oficiais ou fluxos de contacto.*
