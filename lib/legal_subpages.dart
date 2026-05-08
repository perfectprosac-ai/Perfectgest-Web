import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliticaPrivacidadePerfectGestIPage extends StatelessWidget {
  const PoliticaPrivacidadePerfectGestIPage({super.key});

  static const String title = 'Política de Privacidade PerfectGest I';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final padH = w < 400 ? 16.0 : 24.0;
    final selfUri = kIsWeb ? Uri.base : null;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(padH, 16, padH, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: w < 400 ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Última atualização: Maio de 2026',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface.withValues(alpha: 0.72)),
                ),
                const SizedBox(height: 16),
                const _LegalSection(
                  heading: '1. Identificação do Controlador',
                  body:
                      'A PerfectGest, sob responsabilidade de Marcos Leandro dos Santos, estabelece esta Política de Privacidade '
                      'em conformidade com a Lei Geral de Proteção de Dados (LGPD - Lei 13.709/18) e com as políticas para desenvolvedores da Google Play Store. '
                      'Para exercício de direitos de acesso, retificação ou exclusão, contacte: sac.perfectgest@gmail.com.',
                ),
                const _LegalSection(
                  heading: '2. Armazenamento local e natureza dos dados',
                  body:
                      'O aplicativo opera em modelo local-first. Os dados de gestão comercial (clientes, orçamentos, fluxos de caixa e projetos) '
                      'são armazenados exclusivamente no dispositivo do utilizador. Não há recolha, acesso ou transferência desses dados sensíveis para servidores. '
                      'A saída de dados ocorre apenas por ação deliberada do utilizador, como backups e exportação de PDFs.',
                ),
                const _LegalSection(
                  heading: '3. Serviços de terceiros e recolha mínima',
                  body:
                      'Para integridade técnica e licenciamento, podem ser utilizados serviços Google/Firebase com recolha estritamente necessária: '
                      'Google Analytics para Firebase (eventos de uso e erros críticos), Firebase Remote Config (parâmetros de segurança), '
                      'Cloud Firestore (metadados técnicos e controlo de período de avaliação com identificador pseudónimo) '
                      'e Google Play Billing (processamento financeiro pela infraestrutura Google).',
                ),
                const _LegalSection(
                  heading: '4. Segurança e transparência',
                  body:
                      'Todos os dados em trânsito (telemetria e metadados técnicos) utilizam HTTPS/TLS. '
                      'A PerfectGest declara não vender ou partilhar dados técnicos/de uso para publicidade. '
                      'Identificadores de dispositivo são utilizados exclusivamente para validação de período gratuito e segurança do software.',
                ),
                const _LegalSection(
                  heading: '5. Retenção e exclusão',
                  body:
                      'Dados comerciais locais podem ser eliminados pelo utilizador ao limpar dados do app ou desinstalar. '
                      'Registos de telemetria/suporte podem ser solicitados para exclusão por e-mail, com prazo de atendimento de até 15 dias úteis.',
                ),
                const _LegalSection(
                  heading: '6. Permissões de sistema',
                  body:
                      'O aplicativo solicita armazenamento apenas para importar logótipos e salvar ficheiros gerados pelo utilizador '
                      '(PDFs, backups e relatórios exportados).',
                ),
                const _LegalSection(
                  heading: '7. Elegibilidade, foro e links externos',
                  body:
                      'O aplicativo destina-se a maiores de 18 anos. Esta política é regida pelas leis da República Federativa do Brasil, '
                      'com foro da comarca de Caxias do Sul/RS. Referência externa atual: google.com.',
                ),
                const SizedBox(height: 32),
                Divider(color: cs.outline.withValues(alpha: 0.6)),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: selfUri == null
                        ? null
                        : () {
                            launchUrl(
                              selfUri,
                              mode: LaunchMode.platformDefault,
                              webOnlyWindowName: kIsWeb ? '_self' : null,
                            );
                          },
                    child: const Text(title, textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PoliticaExclusaoDadosPerfectGestIPage extends StatelessWidget {
  const PoliticaExclusaoDadosPerfectGestIPage({super.key});

  static const String title = 'Política de exclusão de Dados PerfectGest I';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    final padH = w < 400 ? 16.0 : 24.0;
    final selfUri = kIsWeb ? Uri.base : null;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(padH, 16, padH, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: w < 400 ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Última atualização: Maio de 2026',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: cs.onSurface.withValues(alpha: 0.72)),
                ),
                const SizedBox(height: 16),
                const _LegalSection(
                  heading: '1. Eliminação de dados de gestão (locais)',
                  body:
                      'Os dados de clientes, orçamentos e finanças residem exclusivamente no dispositivo. '
                      'Para eliminar: abrir PerfectGest I > Configurações > Dados no dispositivo > Eliminar todos os dados. '
                      'Atenção: processo irreversível, com remoção permanente da base interna.',
                ),
                const _LegalSection(
                  heading: '2. Eliminação de ficheiros exportados',
                  body:
                      'PDFs, backups manuais e relatórios exportados por WhatsApp/E-mail não permanecem vinculados à base do app após a exportação. '
                      'A remoção deve ser feita manualmente nas pastas locais ou serviços de nuvem utilizados pelo utilizador.',
                ),
                const _LegalSection(
                  heading: '3. Eliminação de dados técnicos (Firebase/Nuvem)',
                  body:
                      'O app utiliza dados técnicos mínimos (ID pseudónimo e marco temporal) em Firebase/Firestore para gestão de trial. '
                      'Não são recolhidos dados nominais ou financeiros em nuvem. '
                      'Solicitações de exclusão definitiva podem ser enviadas para sac.perfectgest@gmail.com '
                      'com o assunto "Exclusão de Dados – [ID do Dispositivo]". '
                      'Prazo de processamento: até 15 dias úteis.',
                ),
                const _LegalSection(
                  heading: '4. Assinaturas e Google Play',
                  body:
                      'Excluir dados do app ou desinstalar não cancela assinaturas ativas. '
                      'Pagamentos, cancelamentos e histórico de compras devem ser geridos diretamente na Conta Google > Pagamentos e Assinaturas.',
                ),
                const SizedBox(height: 32),
                Divider(color: cs.outline.withValues(alpha: 0.6)),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: selfUri == null
                        ? null
                        : () {
                            launchUrl(
                              selfUri,
                              mode: LaunchMode.platformDefault,
                              webOnlyWindowName: kIsWeb ? '_self' : null,
                            );
                          },
                    child: const Text(title, textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  const _LegalSection({required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: cs.primary),
              ),
              const SizedBox(height: 6),
              Text(
                body,
                style: GoogleFonts.inter(fontSize: 13.5, height: 1.5, color: cs.onSurface.withValues(alpha: 0.88)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

