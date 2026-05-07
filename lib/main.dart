import 'elastic_service.dart';
import 'politica_page.dart';
import 'tecnologias_page.dart';
import 'web_cookie_consent_stub.dart' if (dart.library.html) 'web_cookie_consent_web.dart' as cookie_consent;
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_theme.dart';
import 'seo_meta_stub.dart' if (dart.library.html) 'seo_meta_web.dart' as seo_meta;

/// Loops, parallax e oscilações contínuas — respeita “reduzir movimento” do SO/navegador.
bool allowRichMotion(BuildContext context) {
  if (kIsWeb) return false;
  if (MediaQuery.disableAnimationsOf(context)) return false;
  if (SchedulerBinding.instance.platformDispatcher.accessibilityFeatures.reduceMotion) {
    return false;
  }
  return true;
}

/// Superfícies decorativas estáticas (ex.: gradiente fixo no título) quando animações não foram desligadas pelo ancestral.
bool allowStaticHeroDecor(BuildContext context) => !MediaQuery.disableAnimationsOf(context);

void main() {
  seo_meta.applySeoMetaTags();
  runApp(const PerfectProSiteApp());
}

class PerfectProSiteApp extends StatefulWidget {
  const PerfectProSiteApp({super.key});

  @override
  State<PerfectProSiteApp> createState() => _PerfectProSiteAppState();
}

class _PerfectProSiteAppState extends State<PerfectProSiteApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PerfectGest',
      theme: buildPerfectProLightTheme(),
      darkTheme: buildPerfectProDarkTheme(),
      themeMode: _themeMode,
      home: SiteHomePage(onToggleTheme: _toggleTheme),
    );
  }
}

class SiteHomePage extends StatefulWidget {
  const SiteHomePage({super.key, required this.onToggleTheme});
  final VoidCallback onToggleTheme;

  @override
  State<SiteHomePage> createState() => _SiteHomePageState();
}

class _SiteHomePageState extends State<SiteHomePage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollPixels = ValueNotifier<double>(0);
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _solutionsKey = GlobalKey();
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  static const double _headerHeight = 76;
  int _mobileNavIndex = 0;
  bool _deferHeavySections = true;

  @override
  void initState() {
    super.initState();
    seo_meta.applyHomePageSeoMetaTags();
    _scrollController.addListener(_onScroll);
  }

  void _enableHeavySections() {
    if (!_deferHeavySections || !mounted) return;
    setState(() => _deferHeavySections = false);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    _scrollPixels.value = _scrollController.offset;
    if (_scrollController.offset > 48) {
      _enableHeavySections();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollPixels.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    _enableHeavySections();
    final ctx = key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero).dy + _scrollController.offset - _headerHeight - 12;
    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onMobileNavTap(int index) {
    switch (index) {
      case 0:
        _scrollTo(_homeKey);
      case 1:
        _scrollTo(_solutionsKey);
      case 2:
        _scrollTo(_portfolioKey);
      case 3:
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => SobreNosPage(onToggleTheme: widget.onToggleTheme)),
        );
        return;
      case 4:
        _scrollTo(_contactKey);
    }
    setState(() => _mobileNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isMobileNav = MediaQuery.sizeOf(context).width < 980;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      bottomNavigationBar: isMobileNav
          ? NavigationBar(
              selectedIndex: _mobileNavIndex,
              height: 68,
              onDestinationSelected: _onMobileNavTap,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(
                  icon: Icon(Icons.widgets_outlined),
                  selectedIcon: Icon(Icons.widgets_rounded),
                  label: 'Solucoes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.work_outline_rounded),
                  selectedIcon: Icon(Icons.work_rounded),
                  label: 'Portfolio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.info_outline_rounded),
                  selectedIcon: Icon(Icons.info_rounded),
                  label: 'Sobre',
                ),
                NavigationDestination(
                  icon: Icon(Icons.mail_outline_rounded),
                  selectedIcon: Icon(Icons.mail_rounded),
                  label: 'Contato',
                ),
              ],
            )
          : null,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isMobileNav ? 12 : _headerHeight + 12),
                HeroSection(key: _homeKey, scrollListenable: _scrollPixels),
                if (_deferHeavySections) ...[
                  _DeferredSectionSkeleton(
                    key: _solutionsKey,
                    title: 'Solucoes (App/Web)',
                    estimatedHeight: 500,
                  ),
                  _DeferredSectionSkeleton(
                    key: _portfolioKey,
                    title: 'Portfolio',
                    estimatedHeight: 340,
                  ),
                  _DeferredSectionSkeleton(
                    key: _contactKey,
                    title: 'Contato',
                    estimatedHeight: 320,
                  ),
                  const _DeferredSectionSkeleton(
                    key: ValueKey('sk-footer'),
                    title: 'Privacidade, dados e cookies',
                    estimatedHeight: 250,
                  ),
                ] else ...[
                  SectionCard(
                    key: _solutionsKey,
                    title: 'Solucoes (App/Web)',
                    child: AnimatedSolutionsSectionContent(scrollListenable: _scrollPixels),
                  ),
                  SectionCard(
                    key: _portfolioKey,
                    title: 'Portfolio',
                    child: const PortfolioMotionBlock(),
                  ),
                  SectionCard(
                    key: _contactKey,
                    title: 'Contato',
                    child: const ContactMotionBlock(),
                  ),
                  _HomeComplianceFooter(onToggleTheme: widget.onToggleTheme),
                ],
                SizedBox(height: kIsWeb ? 100 : 24),
              ],
            ),
          ),
          if (!isMobileNav)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SiteHeader(
                height: _headerHeight,
                onToggleTheme: widget.onToggleTheme,
                onHome: () => _scrollTo(_homeKey),
                onSolutions: () => _scrollTo(_solutionsKey),
                onPortfolio: () => _scrollTo(_portfolioKey),
                onAbout: () => Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(builder: (_) => SobreNosPage(onToggleTheme: widget.onToggleTheme)),
                    ),
                onContact: () => _scrollTo(_contactKey),
              ),
            ),
          if (isMobileNav)
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: cs.surface.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: isDark ? 'Tema claro' : 'Tema escuro',
                  onPressed: widget.onToggleTheme,
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: cs.primary,
                  ),
                ),
              ),
            ),
          if (kIsWeb)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _WebCookieConsentBanner(onToggleTheme: widget.onToggleTheme),
            ),
        ],
      ),
    );
  }
}

/// Página institucional: layout legível, blocos semânticos e SEO web (meta + título) via [seo_meta].
class SobreNosPage extends StatefulWidget {
  const SobreNosPage({super.key, this.onToggleTheme});

  final VoidCallback? onToggleTheme;

  static const String _empresaTitulo = 'Codificando o Amanhã, Hoje.';
  static const String _empresaCorpo =
      'Somos uma software house especializada em arquiteturas de alta performance. Unimos o poder do Dart/Flutter à robustez do Java para criar ecossistemas digitais que não apenas funcionam, mas escalam. Nossa missão é transformar lógica complexa em experiências de usuário simplificadas, garantindo que sua infraestrutura técnica seja o alicerce do seu crescimento, e não um gargalo.';

  static const String _appsTitulo = 'Apps Nativos com Performance de Próxima Geração';
  static const String _appsCorpo =
      'Desenvolvemos aplicações móveis utilizando as ferramentas mais avançadas do mercado. Com Flutter, entregamos uma base de código única para iOS e Android sem sacrificar a performance nativa. Dominamos a integração de SDKs proprietários e APIs complexas, garantindo que seu aplicativo tenha acesso total ao hardware e ofereça uma fluidez impecável para o usuário final.';

  static const String _webTitulo = 'Web Apps Rápidos, Responsivos e Indexáveis';
  static const String _webCorpo =
      'Sua presença na web precisa ser instantânea. Criamos plataformas web modernas com foco total em Core Web Vitals. Nossas soluções web são projetadas para carregamento ultra-rápido e total conformidade com os algoritmos de busca do Google. De painéis administrativos complexos a interfaces de consumo, entregamos código limpo, otimizado para conversão e 100% responsivo.';

  static const String _desktopTitulo = 'Software Desktop: Potência Máxima no Windows';
  static const String _desktopCorpo =
      'Levamos a experiência do usuário para o desktop com aplicações Windows robustas. Utilizamos o potencial do ecossistema Dart e integração Java para criar softwares que aproveitam ao máximo o poder de processamento local. Ideal para ferramentas de produtividade, sistemas de gestão offline ou softwares que exigem alta capacidade de resposta e integração profunda com o sistema operacional.';

  static const String _porQueTitulo = 'Por que nós?';
  static const String _porQueCorpo =
      '• Código Limpo: Arquitetura limpa (Clean Architecture) para fácil manutenção.\n'
      '• Segurança: Implementação de protocolos de segurança de nível bancário.\n'
      '• Escalabilidade: Sistemas prontos para suportar de 100 a 1 milhão de usuários.\n'
      '• Suporte Full-Stack: Do design da UI à engenharia de back-end.';

  @override
  State<SobreNosPage> createState() => _SobreNosPageState();
}

class _SobreNosPageState extends State<SobreNosPage> {
  @override
  void initState() {
    super.initState();
    seo_meta.applyAboutPageSeoMetaTags();
  }

  @override
  void dispose() {
    seo_meta.restoreGlobalSeoMetaTags();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Pagina institucional Sobre nos da PerfectGest',
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: cs.surface.withValues(alpha: 0.96),
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: cs.primary),
            tooltip: 'Voltar ao início',
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Sobre nós', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: cs.onSurface)),
          actions: [
            IconButton(
              tooltip: 'WhatsApp',
              onPressed: () {
                _openWhatsApp();
                ElasticService.enviarTeste();
              },
              icon: Icon(Icons.chat_rounded, color: cs.primary, size: 22),
            ),
            IconButton(
              tooltip: 'E-mail SAC',
              onPressed: _openSacEmail,
              icon: Icon(Icons.mail_outline_rounded, color: cs.primary),
            ),
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            'PerfectGest',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Semantics(
                          header: true,
                          child: Text(
                            'Sobre nós',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Software house · Flutter · Java · Mobile, Web e Desktop',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurface.withValues(alpha: 0.72),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Transformação digital e robustez do código. Conteúdo pensado para clareza institucional e boa leitura em qualquer dispositivo.',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: cs.onSurface.withValues(alpha: 0.78),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Divider(height: 1, color: cs.outline.withValues(alpha: 0.35)),
                        const SizedBox(height: 22),
                        _SobreNosSection(
                          icon: Icons.flag_rounded,
                          title: SobreNosPage._empresaTitulo,
                          body: SobreNosPage._empresaCorpo,
                        ),
                        const SizedBox(height: 18),
                        _SobreNosSection(
                          icon: Icons.smartphone_rounded,
                          title: SobreNosPage._appsTitulo,
                          body: SobreNosPage._appsCorpo,
                        ),
                        const SizedBox(height: 18),
                        _SobreNosSection(
                          icon: Icons.language_rounded,
                          title: SobreNosPage._webTitulo,
                          body: SobreNosPage._webCorpo,
                        ),
                        const SizedBox(height: 18),
                        _SobreNosSection(
                          icon: Icons.laptop_windows_rounded,
                          title: SobreNosPage._desktopTitulo,
                          body: SobreNosPage._desktopCorpo,
                        ),
                        const SizedBox(height: 18),
                        _SobreNosSection(
                          icon: Icons.verified_rounded,
                          title: SobreNosPage._porQueTitulo,
                          body: SobreNosPage._porQueCorpo,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const _SobreNosLegalFooter(),
          ],
        ),
      ),
    );
  }
}

class _SobreNosSection extends StatelessWidget {
  const _SobreNosSection({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      label: title,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withValues(alpha: 0.45)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: cs.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                body,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.55,
                  color: cs.onSurface.withValues(alpha: 0.86),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SobreNosLegalFooter extends StatelessWidget {
  const _SobreNosLegalFooter();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final year = DateTime.now().year;
    return Semantics(
      label: 'Rodape legal e direitos autorais',
      child: ColoredBox(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.92),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '© $year PerfectGest. Todos os direitos reservados.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withValues(alpha: 0.88),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Marca, logotipos, textos e ilustrações deste site são de uso exclusivo da PerfectGest, salvo indicação em contrário. '
                      'É proibida a reprodução total ou parcial para fins comerciais sem autorização prévia por escrito.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        height: 1.45,
                        color: cs.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _policyLinkButton(String label, String url, {required double fontSize}) {
  return TextButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      alignment: Alignment.center,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    onPressed: () => launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: kIsWeb ? '_blank' : null,
    ),
    child: Text(label, style: GoogleFonts.inter(fontSize: fontSize), textAlign: TextAlign.center),
  );
}

class SolucoesNuvemPage extends StatelessWidget {
  const SolucoesNuvemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soluções em Nuvem'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _CloudHeader(),
            SizedBox(height: 14),
            _CloudItem(
              title: 'Desenvolvimento e Deploy Gerenciado',
              body:
                  'Eu projeto e coloco seu serviço web no ar via Cloud Run, cuidando de toda a infraestrutura técnica para sua empresa focar no negócio.',
            ),
            _CloudItem(
              title: 'Escalabilidade de Infraestrutura',
              body:
                  'Implemento clusters de computação de alta performance no Compute Engine, dimensionando o poder de processamento conforme a sua demanda cresce.',
            ),
            _CloudItem(
              title: 'Gestão Estratégica de Dados',
              body:
                  'Configuro e gerencio o armazenamento de grandes volumes de informações no Cloud Storage, garantindo segurança e acesso rápido aos seus ativos digitais.',
            ),
            _CloudItem(
              title: 'Arquitetura de Big Data',
              body:
                  'Intermedio a análise de dados complexos com BigQuery, entregando dashboards e insights prontos para apoiar suas decisões comerciais.',
            ),
            _CloudItem(
              title: 'Bancos de Dados Prontos para Uso',
              body:
                  'Cuido da configuração e manutenção de instâncias MySQL no Cloud SQL, assegurando que seus dados estejam sempre disponíveis e protegidos.',
            ),
            _CloudItem(
              title: 'Integração e Autenticação com Firebase',
              body:
                  'Desenvolvo aplicações modernas utilizando o ecossistema Firebase para entregas rápidas, notificações push e autenticação segura de usuários.',
            ),
          ],
        ),
      ),
    );
  }
}

class _CloudHeader extends StatelessWidget {
  const _CloudHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline),
      ),
      child: const Text(
        'Soluções em Nuvem com Implementação Especializada',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.15),
      ),
    );
  }
}

class _CloudItem extends StatelessWidget {
  const _CloudItem({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(body, style: TextStyle(fontSize: 13.3, color: cs.onSurface.withValues(alpha: 0.82), height: 1.35)),
          ],
        ),
      ),
    );
  }
}

/// Rodapé da home: página própria PerfectPro + referências oficiais Google (medição).
class _HomeComplianceFooter extends StatelessWidget {
  const _HomeComplianceFooter({required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final padH = w < 400 ? 12.0 : 24.0;
        final innerPad = w < 400 ? 14.0 : 18.0;
        final maxCard = (w < 720 ? w - padH * 2 : 720.0).clamp(200.0, 720.0);
        final stackLinks = w < 440;
        return Semantics(
          label: 'Privacidade, dados, cookies e termos PerfectGest',
          child: Padding(
            padding: EdgeInsets.fromLTRB(padH, 20, padH, 8),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxCard.clamp(0, 720)),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(innerPad, 16, innerPad, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Privacidade, dados e cookies',
                          style: GoogleFonts.inter(
                            fontSize: w < 360 ? 13 : 14,
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                          ),
                          textAlign: w < 480 ? TextAlign.center : TextAlign.start,
                        ),
                        SizedBox(height: w < 360 ? 6 : 8),
                        Text(
                          'Leia a política completa da PerfectGest (privacidade, dados, cookies e termos). '
                          'Para serviços Google (ex.: Analytics), aplicam-se também as políticas oficiais do Google.',
                          style: GoogleFonts.inter(
                            fontSize: w < 360 ? 12 : 12.5,
                            height: 1.5,
                            color: cs.onSurface.withValues(alpha: 0.78),
                          ),
                          textAlign: w < 480 ? TextAlign.center : TextAlign.start,
                        ),
                        SizedBox(height: w < 360 ? 10 : 12),
                        SizedBox(
                          width: stackLinks ? double.infinity : null,
                          child: FilledButton.tonalIcon(
                            onPressed: () {
                              Navigator.of(context).push<void>(
                                MaterialPageRoute<void>(
                                  builder: (_) => PoliticaPrivacidadePage(onToggleTheme: onToggleTheme),
                                ),
                              );
                            },
                            icon: const Icon(Icons.policy_outlined, size: 20),
                            label: Text(
                              w < 340 ? 'Política completa' : 'Ver política completa',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: w < 360 ? 13 : 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: w < 360 ? 10 : 12),
                        if (stackLinks)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _policyLinkButton(
                                'Privacidade Google',
                                'https://policies.google.com/privacy',
                                fontSize: w < 360 ? 12 : 12.5,
                              ),
                              const SizedBox(height: 4),
                              _policyLinkButton(
                                'Cookies Google',
                                'https://policies.google.com/technologies/cookies',
                                fontSize: w < 360 ? 12 : 12.5,
                              ),
                              const SizedBox(height: 4),
                              _policyLinkButton(
                                'Termos Google',
                                'https://policies.google.com/terms',
                                fontSize: w < 360 ? 12 : 12.5,
                              ),
                            ],
                          )
                        else
                          Wrap(
                            alignment: w < 520 ? WrapAlignment.center : WrapAlignment.start,
                            spacing: 4,
                            runSpacing: 6,
                            children: [
                              TextButton(
                                onPressed: () => launchUrl(
                                  Uri.parse('https://policies.google.com/privacy'),
                                  mode: LaunchMode.externalApplication,
                                  webOnlyWindowName: kIsWeb ? '_blank' : null,
                                ),
                                child: Text('Privacidade Google', style: GoogleFonts.inter(fontSize: 12.5)),
                              ),
                              TextButton(
                                onPressed: () => launchUrl(
                                  Uri.parse('https://policies.google.com/technologies/cookies'),
                                  mode: LaunchMode.externalApplication,
                                  webOnlyWindowName: kIsWeb ? '_blank' : null,
                                ),
                                child: Text('Cookies Google', style: GoogleFonts.inter(fontSize: 12.5)),
                              ),
                              TextButton(
                                onPressed: () => launchUrl(
                                  Uri.parse('https://policies.google.com/terms'),
                                  mode: LaunchMode.externalApplication,
                                  webOnlyWindowName: kIsWeb ? '_blank' : null,
                                ),
                                child: Text('Termos Google', style: GoogleFonts.inter(fontSize: 12.5)),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Barra inferior (só web): Consent Mode alinhado ao `index.html`, sem alterar hero nem secções.
class _WebCookieConsentBanner extends StatefulWidget {
  const _WebCookieConsentBanner({required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<_WebCookieConsentBanner> createState() => _WebCookieConsentBannerState();
}

class _WebCookieConsentBannerState extends State<_WebCookieConsentBanner> {
  late bool _visible;

  @override
  void initState() {
    super.initState();
    _visible = kIsWeb && !cookie_consent.isCookieChoiceStored();
  }

  void _snackReload() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferência gravada. Recarregue a página (F5 ou ícone atualizar) para aplicar a medição.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final narrow = w < 520;
    return Material(
      elevation: 12,
      color: cs.surface.withValues(alpha: 0.97),
      shadowColor: Colors.black45,
      child: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: cs.primary.withValues(alpha: 0.45), width: 1)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(narrow ? 12 : 16, 10, narrow ? 12 : 16, 10),
            child: narrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Cookies de medição (Google). Pode aceitar, recusar ou ler a política.',
                        style: GoogleFonts.inter(fontSize: 12.5, height: 1.35, color: cs.onSurface.withValues(alpha: 0.88)),
                      ),
                      const SizedBox(height: 10),
                      _cookieActions(context, cs, narrow: true),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Utilizamos cookies de medição (Google Analytics) conforme a nossa política e o Consent Mode.',
                          style: GoogleFonts.inter(fontSize: 13, height: 1.35, color: cs.onSurface.withValues(alpha: 0.88)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _cookieActions(context, cs, narrow: false),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _cookieActions(BuildContext context, ColorScheme cs, {required bool narrow}) {
    Widget row = Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: narrow ? WrapAlignment.start : WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => PoliticaPrivacidadePage(onToggleTheme: widget.onToggleTheme),
              ),
            );
          },
          child: Text('Política', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () {
            cookie_consent.denyAnalyticsMeasurementConsent();
            setState(() => _visible = false);
            _snackReload();
          },
          child: Text('Recusar', style: GoogleFonts.inter(fontSize: 13)),
        ),
        FilledButton(
          onPressed: () {
            cookie_consent.grantAnalyticsMeasurementConsent();
            setState(() => _visible = false);
            _snackReload();
          },
          child: Text('Aceitar', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
    return row;
  }
}

Future<void> _openWhatsApp({String? prefilledBody}) async {
  final uri = prefilledBody == null || prefilledBody.isEmpty
      ? Uri.parse('https://wa.me/$kWhatsAppDigits')
      : Uri.parse('https://wa.me/$kWhatsAppDigits').replace(
          queryParameters: <String, String>{'text': prefilledBody},
        );
  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: kIsWeb ? '_blank' : null,
  );
}

Future<void> _openSacEmail() async {
  if (kIsWeb) {
    final gmailCompose = Uri.https('mail.google.com', '/mail/', <String, String>{
      'view': 'cm',
      'fs': '1',
      'to': kEmailSac,
      'su': 'Contato PerfectGest',
    });
    await launchUrl(
      gmailCompose,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
    return;
  }
  final uri = Uri(
    scheme: 'mailto',
    path: kEmailSac,
    queryParameters: const {'subject': 'Contato PerfectGest'},
  );
  await launchUrl(uri, mode: LaunchMode.platformDefault);
}

Future<void> _openSiteUrl() async {
  final uri = Uri.parse('https://perfectpro-webpageoficial.onrender.com/');
  await launchUrl(
    uri,
    mode: LaunchMode.platformDefault,
    webOnlyWindowName: kIsWeb ? '_self' : null,
  );
}

class SiteHeader extends StatelessWidget {
  const SiteHeader({
    super.key,
    required this.height,
    required this.onToggleTheme,
    required this.onHome,
    required this.onSolutions,
    required this.onPortfolio,
    required this.onAbout,
    required this.onContact,
  });

  final double height;
  final VoidCallback onToggleTheme;
  final VoidCallback onHome;
  final VoidCallback onSolutions;
  final VoidCallback onPortfolio;
  final VoidCallback onAbout;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompact = MediaQuery.sizeOf(context).width < 980;
    return Semantics(
      label: 'Cabecalho fixo com navegacao principal',
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.94),
          border: Border(bottom: BorderSide(color: cs.primary.withValues(alpha: isDark ? 0.22 : 0.35))),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 34,
              width: 34,
              child: Image.asset(
                'IMAGENS_APP/PerfectPro_Logo_Transparente.png',
                fit: BoxFit.contain,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
                    Icon(Icons.circle_outlined, color: cs.primary, size: 24),
              ),
            ),
            const SizedBox(width: 6),
            if (isCompact)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6)),
                    onPressed: _openSiteUrl,
                    child: Text(
                      'PerfectGest',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              )
            else
              TextButton(
                onPressed: _openSiteUrl,
                child: Text(
                  'PerfectGest',
                  style: TextStyle(
                    color: cs.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            if (!isCompact) const SizedBox(width: 4),
            if (!isCompact)
              IconButton(
                tooltip: 'WhatsApp',
                onPressed: _openWhatsApp,
                icon: Icon(Icons.chat_rounded, color: cs.primary, size: 22),
              ),
            if (!isCompact)
              IconButton(
                tooltip: 'E-mail SAC',
                onPressed: _openSacEmail,
                icon: Icon(Icons.mail_outline_rounded, color: cs.primary, size: 22),
              ),
            if (!isCompact)
              IconButton(
                tooltip: isDark ? 'Tema claro' : 'Tema escuro',
                onPressed: onToggleTheme,
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: cs.primary, size: 22),
              ),
            if (!isCompact) const Spacer(),
            if (isCompact)
              IconButton(
                tooltip: isDark ? 'Tema claro' : 'Tema escuro',
                onPressed: onToggleTheme,
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: cs.primary, size: 22),
              ),
            if (isCompact)
              PopupMenuButton<String>(
                tooltip: 'Abrir menu',
                icon: Icon(Icons.menu_rounded, color: cs.primary, size: 24),
                onSelected: (value) {
                  switch (value) {
                    case 'home':
                      onHome();
                    case 'solutions':
                      onSolutions();
                    case 'portfolio':
                      onPortfolio();
                    case 'about':
                      onAbout();
                    case 'contact':
                      onContact();
                    case 'whatsapp':
                      _openWhatsApp();
                    case 'email':
                      _openSacEmail();
                    case 'theme':
                      onToggleTheme();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'home', child: Text('Home')),
                  PopupMenuItem(value: 'solutions', child: Text('Solucoes (App/Web)')),
                  PopupMenuItem(value: 'portfolio', child: Text('Portfolio')),
                  PopupMenuItem(value: 'about', child: Text('Sobre nós')),
                  PopupMenuItem(value: 'contact', child: Text('Contato')),
                  PopupMenuDivider(),
                  PopupMenuItem(value: 'theme', child: Text('Alternar tema')),
                  PopupMenuItem(value: 'whatsapp', child: Text('WhatsApp')),
                  PopupMenuItem(value: 'email', child: Text('E-mail SAC')),
                ],
              )
            else
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _HeaderBtn(label: 'Home', onTap: onHome),
                      _HeaderBtn(label: 'Solucoes (App/Web)', onTap: onSolutions),
                      _HeaderBtn(label: 'Portfolio', onTap: onPortfolio),
                      _HeaderBtn(label: 'Sobre nós', onTap: onAbout),
                      _HeaderBtn(label: 'Contato', onTap: onContact),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  const _HeaderBtn({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: TextButton(
        onPressed: onTap,
        child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13)),
      ),
    );
  }
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key, required this.scrollListenable});
  final ValueListenable<double> scrollListenable;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _ambient = AnimationController(vsync: this, duration: const Duration(seconds: 4));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (allowRichMotion(context)) {
        _ambient.repeat();
      } else {
        _ambient.value = 0;
      }
    });
  }

  @override
  void dispose() {
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = allowRichMotion(context);
    final staticDecor = allowStaticHeroDecor(context);
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Secao principal de apresentacao',
      child: ValueListenableBuilder<double>(
        valueListenable: widget.scrollListenable,
        builder: (context, scroll, _) {
          final parallaxY = motion ? -scroll * 0.07 : 0.0;
          return Transform.translate(
            offset: Offset(0, parallaxY),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
              child: AnimatedBuilder(
                animation: _ambient,
                builder: (context, _) {
                  final screenWidth = MediaQuery.sizeOf(context).width;
                  final isCompactHero = screenWidth < 760;
                  final heroTitleSize = isCompactHero ? 28.0 : 36.0;
                  final heroSubtitleSize = isCompactHero ? 15.0 : 18.0;
                  final pulse = motion ? (0.45 + 0.55 * (0.5 + 0.5 * math.sin(_ambient.value * math.pi * 2))) : 0.55;
                  final beat = motion ? (0.5 + 0.5 * math.sin(_ambient.value * math.pi * 6)) : 0.5;
                  final borderColor = Color.lerp(cs.outline, cs.primary, pulse * 0.55)!;
                  final neonPhase = (_ambient.value * 3) % 1;
                  final neonIndex = (_ambient.value * 3).floor() % 3;
                  final neonPalette = <Color>[
                    const Color(0xFF00F5FF),
                    const Color(0xFFFF2BD6),
                    const Color(0xFF39FF14),
                  ];
                  final neonColor = Color.lerp(
                    neonPalette[neonIndex],
                    neonPalette[(neonIndex + 1) % neonPalette.length],
                    neonPhase,
                  )!;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 1),
                      boxShadow: motion
                          ? [
                              BoxShadow(
                                color: neonColor.withValues(alpha: 0.30 + (beat * 0.14)),
                                blurRadius: 28 + (beat * 18),
                                spreadRadius: 1.2 + (beat * 2.0),
                              ),
                              BoxShadow(
                                color: const Color(0xFF00E1FF).withValues(alpha: 0.10 + (beat * 0.10)),
                                blurRadius: 44 + (beat * 20),
                                spreadRadius: 0.6 + (beat * 1.4),
                              ),
                              BoxShadow(
                                color: const Color(0xFFFF2BD6).withValues(alpha: 0.08 + ((1 - beat) * 0.10)),
                                blurRadius: 38 + ((1 - beat) * 16),
                                spreadRadius: 0.4 + ((1 - beat) * 1.2),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: cs.primary.withValues(alpha: 0.08),
                                blurRadius: 22,
                                spreadRadius: 0,
                              ),
                            ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            'PerfectGest',
                            style: GoogleFonts.inter(
                              fontSize: heroSubtitleSize,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w800,
                              color: cs.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Semantics(
                          header: true,
                          label: 'Inovacao em Flutter, Java e SDKs',
                          child: staticDecor
                              ? ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) {
                                    final angle = motion ? _ambient.value * math.pi * 1.25 : 0.0;
                                    return LinearGradient(
                                      colors: [
                                        cs.onSurface.withValues(alpha: 0.55),
                                        cs.primary,
                                        cs.onSurface.withValues(alpha: 0.85),
                                      ],
                                      stops: const [0.15, 0.5, 0.85],
                                      transform: GradientRotation(angle),
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    'Inovacao em Flutter, Java e SDKs',
                                    style: TextStyle(
                                      fontSize: heroSubtitleSize,
                                      fontWeight: FontWeight.w800,
                                      height: 1.15,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Inovacao em Flutter, Java e SDKs',
                                  style: TextStyle(
                                    fontSize: heroSubtitleSize,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                    color: cs.onSurface,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        staticDecor
                            ? ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  final angle = motion ? _ambient.value * math.pi * 1.25 : 0.0;
                                  return LinearGradient(
                                    colors: [
                                      cs.onSurface.withValues(alpha: 0.55),
                                      cs.primary,
                                      cs.onSurface.withValues(alpha: 0.85),
                                    ],
                                    stops: const [0.15, 0.5, 0.85],
                                    transform: GradientRotation(angle),
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'Criamos apps Flutter, sistemas web e integrações Java/SDK com foco em performance, segurança e escalabilidade para o seu negócio.',
                                  style: GoogleFonts.inter(
                                    fontSize: heroSubtitleSize,
                                    height: 1.45,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Criamos apps Flutter, sistemas web e integrações Java/SDK com foco em performance, segurança e escalabilidade para o seu negócio.',
                                style: GoogleFonts.inter(
                                  fontSize: heroSubtitleSize,
                                  height: 1.45,
                                  color: cs.onSurface,
                                ),
                              ),
                        const SizedBox(height: 12),
                        Text(
                          'Software house especializada em aplicativo mobile, plataforma web rápida (Core Web Vitals) e SEO técnico para crescer no Google.',
                          style: GoogleFonts.inter(
                            fontSize: heroSubtitleSize,
                            height: 1.45,
                            color: cs.onSurface.withValues(alpha: 0.72),
                          ),
                        ),
                        const SizedBox(height: 12),
                        staticDecor
                            ? ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  final angle = motion ? _ambient.value * math.pi * 1.25 : 0.0;
                                  return LinearGradient(
                                    colors: [
                                      cs.onSurface.withValues(alpha: 0.55),
                                      cs.primary,
                                      cs.onSurface.withValues(alpha: 0.85),
                                    ],
                                    stops: const [0.15, 0.5, 0.85],
                                    transform: GradientRotation(angle),
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'Soluções digitais com arquitetura robusta, código limpo e resultados mensuráveis.',
                                  style: TextStyle(
                                    fontSize: heroSubtitleSize,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Soluções digitais com arquitetura robusta, código limpo e resultados mensuráveis.',
                                style: TextStyle(
                                  fontSize: heroSubtitleSize,
                                  fontWeight: FontWeight.w800,
                                  height: 1.15,
                                  color: cs.onSurface.withValues(alpha: 0.78),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Vitrine com movimento suave (flutuação) e leve resposta ao hover no web/desktop.
class AnimatedSolutionsSectionContent extends StatefulWidget {
  const AnimatedSolutionsSectionContent({super.key, required this.scrollListenable});
  final ValueListenable<double> scrollListenable;

  @override
  State<AnimatedSolutionsSectionContent> createState() => _AnimatedSolutionsSectionContentState();
}

class _AnimatedSolutionsSectionContentState extends State<AnimatedSolutionsSectionContent> with TickerProviderStateMixin {
  late final AnimationController _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 5));
  late final AnimationController _enterCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (allowRichMotion(context)) {
        _floatCtrl.repeat();
      } else {
        _floatCtrl.value = 0;
      }
      _enterCtrl.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _enterCtrl.dispose();
    super.dispose();
  }

  Animation<double> _fadeIn(double begin, double end) {
    return CurvedAnimation(parent: _enterCtrl, curve: Interval(begin, end, curve: Curves.easeOutCubic));
  }

  Animation<Offset> _slideIn(double begin, double end) {
    return Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Interval(begin, end, curve: Curves.easeOutCubic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _fadeIn(0.0, 0.35),
          child: SlideTransition(
            position: _slideIn(0.0, 0.35),
            child: AnimatedBuilder(
              animation: Listenable.merge([_floatCtrl, widget.scrollListenable]),
              builder: (context, _) {
                return Semantics(
                  label: 'Vitrine de projetos em mockups de dispositivos',
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _floatedDevice(0, const DeviceFrame(title: 'Android 14', width: 190, height: 338, radius: 34, imageAsset: 'IMAGENS_APP/Screenshot/PerfectGest (2).png', fallbackImageAsset: 'IMAGENS_APP/Screenshot_20260423-120800.jpg', imageLeft: 27, imageTop: 20, imageWidth: 136, imageHeight: 297)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeTransition(
          opacity: _fadeIn(0.12, 0.55),
          child: SlideTransition(
            position: _slideIn(0.12, 0.55),
            child: const SectionText(
              title: 'Apps Nativos com Performance de Proxima Geracao',
              body: 'Com Flutter, entregamos uma base unica para iOS e Android sem sacrificar performance nativa, com integracao de SDKs e APIs complexas.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        FadeTransition(
          opacity: _fadeIn(0.28, 0.85),
          child: SlideTransition(
            position: _slideIn(0.28, 0.85),
            child: const SectionText(
              title: 'Web Apps Rapidos, Responsivos e Indexaveis',
              body: 'Solucoes com foco em Core Web Vitals e Google Search Console, orientadas para carregamento rapido e conversao.',
            ),
          ),
        ),
      ],
    );
  }

  Widget _floatedDevice(int index, Widget child) {
    final motion = allowRichMotion(context);
    final t = _floatCtrl.value;
    final scroll = widget.scrollListenable.value;
    final dy = motion ? 5.0 * math.sin(2 * math.pi * t + index * 1.05) : 0.0;
    final px = motion ? scroll * 0.012 * (index - 1.5) : 0.0;
    final rotY = motion ? 0.055 * math.sin(2 * math.pi * t * 0.65 + index * 0.9) : 0.0;
    return RepaintBoundary(
      child: _HoverLift(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(rotY),
          child: Transform.translate(offset: Offset(px, dy), child: child),
        ),
      ),
    );
  }
}

/// Portfolio: entrada escalonada + ícones de competências com micro-animação.
class PortfolioMotionBlock extends StatefulWidget {
  const PortfolioMotionBlock({super.key});

  @override
  State<PortfolioMotionBlock> createState() => _PortfolioMotionBlockState();
}

class _PortfolioMotionBlockState extends State<PortfolioMotionBlock> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic)),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
              CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic)),
            ),
            child: const SectionText(
              title: 'Diferenciais',
              body: '- Codigo Limpo\n- Seguranca\n- Escalabilidade\n- Suporte Full-Stack',
            ),
          ),
        ),
        const SizedBox(height: 18),
        AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _demoChip(context, Icons.architecture, 'Clean Arch', 0, TecnologiasPage.topicCleanArch),
                _demoChip(context, Icons.security, 'Seguranca', 1, TecnologiasPage.topicSeguranca),
                _demoChip(context, Icons.trending_up, 'Escala', 2, TecnologiasPage.topicEscala),
                _demoChip(context, Icons.hub, 'Full-Stack', 3, TecnologiasPage.topicFullStack),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ActionChip(
              avatar: Icon(Icons.memory_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
              label: const Text('Parceiros tecnológicos'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const TecnologiasPage(),
                ),
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            ActionChip(
              avatar: Icon(Icons.cloud_done_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
              label: const Text('Soluções em nuvem'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SolucoesNuvemPage(),
                ),
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.outline),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
          ],
        ),
      ],
    );
  }

  Widget _demoChip(BuildContext context, IconData icon, String label, int index, String topicId) {
    final cs = Theme.of(context).colorScheme;
    final start = 0.35 + index * 0.12;
    final end = (start + 0.35).clamp(0.0, 1.0);
    final v = CurvedAnimation(parent: _c, curve: Interval(start, end, curve: Curves.elasticOut)).value;
    return Opacity(
      opacity: v.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: 0.85 + 0.15 * v,
        child: ActionChip(
          avatar: Icon(icon, size: 18, color: cs.primary),
          label: Text(label, style: const TextStyle(fontSize: 12)),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TecnologiasPage(initialTopic: topicId),
            ),
          ),
          side: BorderSide(color: cs.outline),
          backgroundColor: cs.surface,
        ),
      ),
    );
  }
}

/// Contato: entrada + CTA com pulse; botão principal abre WhatsApp com texto inicial.
class ContactMotionBlock extends StatefulWidget {
  const ContactMotionBlock({super.key});

  @override
  State<ContactMotionBlock> createState() => _ContactMotionBlockState();
}

class _ContactMotionBlockState extends State<ContactMotionBlock> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _enter.forward();
      if (allowRichMotion(context)) _pulse.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _enter.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motion = allowRichMotion(context);
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Contacto WhatsApp e e-mail',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ActionChip(
                avatar: Icon(Icons.chat_rounded, size: 18, color: cs.primary),
                label: const Text('+55 51 989045442'),
                onPressed: _openWhatsApp,
                side: BorderSide(color: cs.outline),
                backgroundColor: cs.surface,
              ),
              ActionChip(
                avatar: Icon(Icons.alternate_email_rounded, size: 18, color: cs.primary),
                label: Text(kEmailSac, style: const TextStyle(fontSize: 12.5)),
                onPressed: _openSacEmail,
                side: BorderSide(color: cs.outline),
                backgroundColor: cs.surface,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        FadeTransition(
          opacity: CurvedAnimation(parent: _enter, curve: const Interval(0.0, 0.55, curve: Curves.easeOut)),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
              CurvedAnimation(parent: _enter, curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic)),
            ),
            child: const SectionText(
              title: 'Vamos construir seu proximo produto',
              body: 'Foco em eficiencia, estabilidade e entrega continua para mobile, web e desktop.',
            ),
          ),
        ),
        const SizedBox(height: 18),
        FadeTransition(
          opacity: CurvedAnimation(parent: _enter, curve: const Interval(0.35, 1.0, curve: Curves.easeOut)),
          child: ScaleTransition(
            scale: motion
                ? Tween<double>(begin: 1.0, end: 1.045).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut))
                : const AlwaysStoppedAnimation<double>(1.0),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              ),
              onPressed: () => _openWhatsApp(
                    prefilledBody:
                        'Olá! Gostaria de falar com a PerfectGest sobre um projeto.\n\n',
                  ),
              icon: const Icon(Icons.send_rounded),
              label: const Text('Enviar mensagem (WhatsApp)'),
            ),
          ),
        ),
      ],
    );
  }
}

class _HoverLift extends StatefulWidget {
  const _HoverLift({required this.child});
  final Widget child;

  @override
  State<_HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<_HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class DeviceFrame extends StatelessWidget {
  const DeviceFrame({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.radius,
    required this.imageAsset,
    this.fallbackImageAsset,
    required this.imageLeft,
    required this.imageTop,
    required this.imageWidth,
    required this.imageHeight,
    this.withDesktopBar = false,
  });

  final String title;
  final double width;
  final double height;
  final double radius;
  final String imageAsset;
  final String? fallbackImageAsset;
  final double imageLeft;
  final double imageTop;
  final double imageWidth;
  final double imageHeight;
  final bool withDesktopBar;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final codeStyle = GoogleFonts.jetBrainsMono(textStyle: TextStyle(color: cs.primary, fontSize: 11));
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final safeW = math.max(maxW, 1.0);
        final scale = math.min(1.0, safeW / width);
        return SizedBox(
          width: width * scale,
          height: height * scale,
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: width,
              height: height,
              child: Builder(
                builder: (context) {
                  final dpr = MediaQuery.devicePixelRatioOf(context);
                  final decodeW = (imageWidth * dpr).round().clamp(1, 4096);
                  final decodeH = (imageHeight * dpr).round().clamp(1, 4096);
                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF181818) : const Color(0xFFF2F4F5),
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(color: cs.primary.withValues(alpha: 0.45)),
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        if (withDesktopBar)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
                              child: SizedBox(height: 28, child: ColoredBox(color: cs.surfaceContainerHigh)),
                            ),
                          ),
                        Positioned(
                          left: imageLeft,
                          top: imageTop,
                          width: imageWidth,
                          height: imageHeight,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ColoredBox(
                              color: isDark ? const Color(0xFF0C0C0C) : const Color(0xFFE4E7EA),
                              child: Image.asset(
                                imageAsset,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                cacheWidth: decodeW,
                                cacheHeight: decodeH,
                                errorBuilder: (context, error, stackTrace) {
                                  if (fallbackImageAsset != null) {
                                    return Image.asset(
                                      fallbackImageAsset!,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                      cacheWidth: decodeW,
                                      cacheHeight: decodeH,
                                      errorBuilder: (context, error, stackTrace) =>
                                          ColoredBox(color: cs.surfaceContainerHigh),
                                    );
                                  }
                                  return ColoredBox(color: cs.surfaceContainerHigh);
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(left: 10, bottom: 8, child: Text(title, style: codeStyle)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Secao $title',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.65)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _DeferredSectionSkeleton extends StatelessWidget {
  const _DeferredSectionSkeleton({required this.title, required this.estimatedHeight, super.key});

  final String title;
  final double estimatedHeight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withValues(alpha: 0.45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: cs.onSurface.withValues(alpha: 0.72)),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: estimatedHeight,
              decoration: BoxDecoration(
                color: cs.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  const SectionText({super.key, required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: cs.primary)),
          const SizedBox(height: 8),
          Text(body, style: TextStyle(fontSize: 15, color: cs.onSurface.withValues(alpha: 0.78), height: 1.45)),
        ],
      ),
    );
  }
}

