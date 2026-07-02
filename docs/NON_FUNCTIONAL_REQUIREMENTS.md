# Non-Functional Requirements - CompraCerta

## Performance

- O aplicativo deve abrir rapidamente em smartphones simples e intermediarios.
- Listagens devem evitar carregar grandes volumes inteiros na memoria.
- Busca, filtros e paginacao devem ser usados quando houver crescimento de dados.
- Consultas Drift/SQLite devem ser filtradas, objetivas e indexadas quando necessario.
- Dashboards, historicos e relatorios devem carregar dados sob demanda.
- Widgets grandes devem ser divididos para facilitar manutencao e reduzir custo de rebuild.

## Escalabilidade

- A arquitetura deve permitir inclusao de novas features sem quebrar modulos existentes.
- Cada feature deve manter camadas de domain, data, application e presentation.
- Regras compartilhadas devem ficar em `core/` ou `shared/` quando fizer sentido.
- Dependencias externas devem ser avaliadas por valor, manutencao e impacto no tamanho do app.

## Seguranca

- O projeto nao deve armazenar secrets, tokens ou chaves no repositorio.
- Dados sensiveis devem ser tratados com minimo acesso necessario.
- Integracoes externas futuras devem ter contratos claros e tratamento de falhas.
- Releases devem usar processo controlado de assinatura e distribuicao.

## LGPD

- O app deve coletar apenas dados necessarios ao funcionamento.
- Dados devem permanecer locais por padrao.
- Qualquer envio para IA externa ou servico remoto deve ser opcional e transparente.
- O usuario deve manter controle sobre dados pessoais e historicos.

## Offline First

- Cadastro de produtos, categorias, estoque e lista de compras devem funcionar sem internet.
- O banco local Drift/SQLite e a fonte primaria das funcoes principais.
- Recursos online futuros devem ser complementares, nunca obrigatorios para o uso basico.

## Inteligencia Artificial

- IA externa sera opcional e acionada sob demanda.
- O funcionamento basico nunca deve depender de IA.
- Nao executar modelos locais pesados no dispositivo.
- Prompts, dados enviados e respostas devem ser tratados com privacidade e rastreabilidade.
- O motor inteligente local deve priorizar regras leves e explicaveis.

## Compatibilidade

- Plataforma inicial: Android.
- O projeto deve preservar caminhos para expansao futura para iOS.
- UI e arquitetura devem evitar dependencias especificas de Android quando houver alternativa multiplataforma.

## Testabilidade

- Regras de negocio devem ser cobertas por testes unitarios.
- Repositories, datasources e usecases devem ter testes quando houver comportamento relevante.
- Seeds e migrations devem ser testados.
- Formularios devem validar campos obrigatorios e limites.
- Fluxos criticos devem ser testados antes de release.

## Acessibilidade e Usabilidade

- A interface deve ser clara, objetiva e legivel.
- Cores devem respeitar contraste adequado nos temas claro e escuro.
- Textos devem ser simples e orientados a acao.
- Fluxos principais devem exigir poucos passos.

## Observabilidade Local

- Erros devem ser tratados de forma previsivel.
- Falhas de seed, banco ou migracao devem ser diagnosticaveis durante desenvolvimento.
- Logs de desenvolvimento nao devem expor dados sensiveis.
