import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_theme.dart';
import 'seo_meta_stub.dart' if (dart.library.html) 'seo_meta_web.dart' as seo_meta;
import 'tecnologias_page.dart';
import 'web_cookie_consent_stub.dart' if (dart.library.html) 'web_cookie_consent_web.dart' as cookie_consent;

/// Política própria PerfectGest: privacidade, dados, cookies e termos (alinhado a boas práticas Google para sites e medição).
class PoliticaPrivacidadePage extends StatefulWidget {
  const PoliticaPrivacidadePage({super.key, this.onToggleTheme});

  final VoidCallback? onToggleTheme;

  @override
  State<PoliticaPrivacidadePage> createState() => _PoliticaPrivacidadePageState();
}

class _PoliticaPrivacidadePageState extends State<PoliticaPrivacidadePage> {
  @override
  void initState() {
    super.initState();
    seo_meta.applyPoliticaSeoMetaTags();
  }

  @override
  void dispose() {
    seo_meta.restoreGlobalSeoMetaTags();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final padH = w < 400 ? 16.0 : 24.0;
    return Semantics(
      label: 'Politica de privacidade, dados, cookies e termos PerfectGest',
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: cs.surface.withValues(alpha: 0.96),
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: cs.primary),
            tooltip: 'Voltar',
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Privacidade e termos',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: cs.onSurface),
          ),
          actions: [
            if (widget.onToggleTheme != null)
              IconButton(
                tooltip: Theme.of(context).brightness == Brightness.dark ? 'Tema claro' : 'Tema escuro',
                onPressed: widget.onToggleTheme,
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: cs.primary,
                ),
              ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bodyW = constraints.hasBoundedWidth && constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final maxW = (bodyW < 720 ? bodyW : 720.0).clamp(200.0, 720.0);
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(padH, 16, padH, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PerfectGest',
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: cs.primary, letterSpacing: 0.4),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Política de privacidade, dados pessoais, cookies e termos de uso',
                        style: GoogleFonts.inter(
                          fontSize: w < 400 ? 18 : 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Última atualização: documento institucional. Em caso de dúvida sobre tratamento de dados, contacte: $kEmailSac.',
                        style: GoogleFonts.inter(fontSize: 13, height: 1.45, color: cs.onSurface.withValues(alpha: 0.72)),
                      ),
                      const SizedBox(height: 22),
                      _PoliticaSection(
                        title: '1. Quem somos',
                        body:
                            'O presente site é operado pela PerfectGest (“nós”, “nossa”). Somos uma software house focada em desenvolvimento de software (mobile, web e desktop), '
                            'consultoria técnica e conteúdo institucional. O domínio de referência do projeto é perfectpro-webpageoficial.onrender.com.',
                      ),
                      _PoliticaSection(
                        title: '2. Que dados podemos recolher',
                        body:
                            '• Dados técnicos de navegação: endereço IP (muitas vezes truncado ou agregado pelo fornecedor de analytics), tipo de navegador, idioma, páginas visitadas e horários aproximados.\n'
                            '• Dados que nos enviar voluntariamente: por exemplo, se nos contactar por WhatsApp ou e-mail, o conteúdo da mensagem e os metadados necessários à comunicação.\n'
                            'Não vendemos listas de contactos nem dados pessoais a terceiros para fins comerciais independentes.',
                      ),
                      _PoliticaSection(
                        title: '3. Cookies e tecnologias similares',
                        body:
                            'Utilizamos cookies e armazenamento local estritamente necessários ao funcionamento do site e, quando ativado, cookies de medição de audiência (Google Analytics / gtag) '
                            'para compreender de forma agregada como o site é utilizado. Pode gerir ou apagar cookies nas definições do seu navegador. '
                            'Se recusar cookies de medição, limitamos o envio de sinais de analytics conforme a configuração do seu browser e as nossas definições de consentimento.',
                      ),
                      _PoliticaSection(
                        title: '4. Google Analytics e serviços Google',
                        body:
                            'Quando o Google Analytics está configurado neste site, o tratamento de dados associado segue as políticas do Google. '
                            'Recomendamos a leitura das páginas oficiais do Google sobre privacidade, cookies e parceiros tecnológicos.',
                        links: [
                          const _PoliticaLink('Privacidade Google', url: 'https://policies.google.com/privacy'),
                          const _PoliticaLink('Cookies Google', url: 'https://policies.google.com/technologies/cookies'),
                          _PoliticaLink(
                            'Parceiros tecnológicos',
                            onTap: () {
                              Navigator.of(context).push<void>(
                                MaterialPageRoute<void>(builder: (_) => const TecnologiasPage()),
                              );
                            },
                          ),
                        ],
                      ),
                      _PoliticaSection(
                        title: '5. Base legal e retenção',
                        body:
                            'O tratamento de dados técnicos e de medição pode basear-se no interesse legítimo em melhorar o site e na execução de medidas pré-contratuais ou contratuais quando nos contacta. '
                            'Conservamos mensagens de contacto apenas pelo tempo necessário a responder e a cumprir obrigações legais aplicáveis.',
                      ),
                      _PoliticaSection(
                        title: '6. Os seus direitos',
                        body:
                            'Dependendo da lei aplicável (por exemplo RGPD na UE), poderá solicitar acesso, retificação, apagamento, limitação, portabilidade ou oposição ao tratamento dos seus dados pessoais. '
                            'Para exercer direitos ou questões de privacidade, escreva para $kEmailSac.',
                      ),
                      _PoliticaSection(
                        title: '7. Termos de uso do site',
                        body:
                            'O conteúdo deste site (textos, identidade visual e materiais) destina-se a informação sobre a PerfectGest. A reprodução não autorizada para fins comerciais pode ser proibida. '
                            'Os links externos são fornecidos por conveniência; não controlamos sites de terceiros. O uso do site é por sua conta e risco, na medida permitida pela lei.',
                      ),
                      const SizedBox(height: 20),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: cs.primaryContainer.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: cs.outline.withValues(alpha: 0.45)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(w < 400 ? 14 : 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Cookies de medição (Google)',
                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: cs.onSurface),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Se aceitar, gravamos a sua escolha no navegador e, na próxima carga da página, o script de medição poderá operar conforme as regras do Google (Consent Mode). '
                                'Pode revogar apagando os dados do site nas definições do browser.',
                                style: GoogleFonts.inter(fontSize: 12.5, height: 1.45, color: cs.onSurface.withValues(alpha: 0.8)),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: w < 480 ? double.infinity : null,
                                child: FilledButton.icon(
                                  onPressed: () {
                                    cookie_consent.grantAnalyticsMeasurementConsent();
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Preferência gravada. Recarregue a página uma vez para aplicar a medição.'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.check_circle_outline, size: 20),
                                  label: Text(
                                    w < 360 ? 'Aceitar medição' : 'Aceitar cookies de medição',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '© ${DateTime.now().year} PerfectGest. Todos os direitos reservados.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.65)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PoliticaLink {
  const _PoliticaLink(this.label, {this.url, this.onTap})
      : assert(url != null || onTap != null, 'Informe url ou ação interna.');
  final String label;
  final String? url;
  final VoidCallback? onTap;
}

class _PoliticaSection extends StatelessWidget {
  const _PoliticaSection({required this.title, required this.body, this.links = const []});

  final String title;
  final String body;
  final List<_PoliticaLink> links;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mqW = MediaQuery.sizeOf(context).width;
    final padH = mqW < 400 ? 12.0 : 16.0;
    final stackLinks = mqW < 440;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Semantics(
        container: true,
        label: title,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(padH, 16, padH, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: mqW < 360 ? 15 : 16,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: mqW < 360 ? 13 : 14,
                    height: 1.55,
                    color: cs.onSurface.withValues(alpha: 0.88),
                  ),
                ),
                if (links.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  if (stackLinks)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < links.length; i++) ...[
                          if (i > 0) const SizedBox(height: 4),
                          TextButton(
                            style: TextButton.styleFrom(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              final onTap = links[i].onTap;
                              final url = links[i].url;
                              if (onTap != null) {
                                onTap();
                                return;
                              }
                              if (url == null) return;
                              launchUrl(
                                Uri.parse(url),
                                mode: LaunchMode.externalApplication,
                                webOnlyWindowName: kIsWeb ? '_blank' : null,
                              );
                            },
                            child: Text(
                              links[i].label,
                              style: GoogleFonts.inter(fontSize: mqW < 360 ? 12.5 : 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: links
                          .map(
                            (l) => TextButton(
                              onPressed: () {
                                final onTap = l.onTap;
                                final url = l.url;
                                if (onTap != null) {
                                  onTap();
                                  return;
                                }
                                if (url == null) return;
                                launchUrl(
                                  Uri.parse(url),
                                  mode: LaunchMode.externalApplication,
                                  webOnlyWindowName: kIsWeb ? '_blank' : null,
                                );
                              },
                              child: Text(l.label, style: GoogleFonts.inter(fontSize: 13)),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
