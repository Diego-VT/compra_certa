# Roadmap - CompraCerta

## Status oficiais

Cada sprint deve usar um dos status abaixo:

- Planejada: sprint definida no roadmap, ainda nao iniciada.
- Em andamento: sprint em desenvolvimento ativo.
- Em revisao: sprint implementada, aguardando validacao, documentacao, aprovacao ou ajustes finais.
- Concluida: sprint validada, documentada e registrada no historico do projeto.

## Diretriz transversal de performance

Todas as sprints devem preservar o objetivo de manter o app leve e fluido em smartphones simples e intermediarios.

Diretrizes obrigatorias:

- Evitar carregar listas grandes inteiras na memoria.
- Usar paginacao, filtros ou busca sob demanda.
- Evitar widgets gigantes e logica pesada na UI.
- Manter consultas Drift/SQLite otimizadas.
- Criar indices quando filtros frequentes exigirem.
- Evitar imagens e dependencias desnecessarias.
- Manter funcoes principais offline.
- Nao executar IA local pesada.
- IA externa deve ser opcional e sob demanda.
- Historico, dashboards e relatorios devem carregar dados sob demanda.
- Validar com `flutter analyze`, `flutter test` e, quando possivel, dispositivo fisico.

## Sprint 1 - Ambiente

### Objetivo

Criar base profissional do projeto.

### Entregas

- Projeto Flutter `compra_certa`.
- Clean Architecture.
- Riverpod.
- Go Router.
- Drift/SQLite.
- Material Design 3.
- README inicial.
- Base preparada para app local-first e leve.

### Status

Concluida.

## Sprint 2 - Categorias

### Objetivo

Criar base de categorias do sistema.

### Entregas

- Tabela `categorias`.
- Seed JSON.
- Tabela `seed_executions`.
- Repository, datasource, usecases e providers.
- Tela de listagem.
- Testes.

### Status

Concluida.

## Sprint 3 - Produtos

### Objetivo

Permitir cadastro e edicao de produtos.

### Entregas

- Tabela `produtos`.
- Relacionamento com categorias.
- Cadastro e edicao.
- Repository, datasource, usecases e providers.
- Testes.

### Status

Concluida.

## Sprint 4 - Melhorias em Produtos

### Objetivo

Melhorar usabilidade da listagem.

### Entregas

- Busca por nome.
- Filtro por categoria.
- Filtro por status.
- Ativar/desativar produto.
- Preparacao visual para estoque.
- Busca sem travar a interface.

### Status

Concluida.

## Sprint 5 - Estoque

### Status

Concluida.

### Objetivo

Controlar quantidade atual de produtos.

### Entregas previstas

- Tabela `estoques`.
- Tabela `movimentacoes_estoque`.
- Status calculado por minimo e ideal.
- Ajuste rapido de estoque.
- Consultas otimizadas para produtos abaixo do minimo.

## Sprint 6 - Historico de Compras

### Status

Concluida.

### Objetivo

Registrar compras realizadas.

### Entregas previstas

- Tabela `compras`.
- Tabela `itens_compra`.
- Tela de historico.
- Tela de detalhe da compra.
- Tela de registro de compra.
- Consulta por periodo.
- Carregamento incremental ou filtrado do historico.
- Indices para consultas por data e itens por compra/produto.

## Sprint 7 - Lista de Compras

### Status

Concluida.

### Objetivo

Criar listas planejadas de compras.

### Entregas previstas

- Tabela `listas_compras`.
- Tabela `itens_lista_compras`.
- Adicionar produtos a lista.
- Marcar itens comprados.
- Gerar lista a partir de estoque baixo.
- Funcionamento offline.
- Indices para consultas por status, lista e produto.

## Sprint 8 - Dashboard

### Status

Concluida.

### Objetivo

Exibir resumo operacional do app.

### Entregas previstas

- Produtos abaixo do minimo.
- Listas abertas.
- Ultimas compras.
- Indicadores basicos.
- Carregamento sob demanda dos indicadores.

## Sprint 9 - Motor Inteligente Local

### Status

Concluida.

### Objetivo

Gerar sugestoes sem IA externa, usando regras locais.

### Entregas previstas

- Sugestao por estoque baixo.
- Sugestao por consumo recorrente.
- Explicacao da regra aplicada.
- Regras locais leves, sem processamento pesado.

## Sprint 10 - Integracao com IA

### Status

Concluida.

### Objetivo

Adicionar camada opcional de IA externa.

### Entregas previstas

- Contrato de servico de IA.
- Prompts versionados.
- Fallback sem IA.
- Controle de dados enviados.
- IA opcional e acionada sob demanda.

## Sprint 11 - Relatorios

### Status

Concluida.

### Objetivo

Permitir analise de produtos, compras e consumo.

### Entregas previstas

- Relatorio por categoria.
- Produtos mais comprados.
- Consumo por periodo.
- Exportacao futura.
- Consultas agregadas e sob demanda.

## Sprint 12 - Notificacoes

### Status

Concluida.

### Objetivo

Alertar usuario sobre reposicao e listas pendentes.

### Entregas previstas

- Notificacoes locais.
- Preferencias de usuario.
- Eventos de estoque baixo.

## Sprint 12.2 - Relatorio da Lista de Compras

### Status

Concluida.

### Objetivo

Visualizar e compartilhar o relatorio individual de uma lista em PDF.

### Entregas previstas

- Resumo e progresso da lista.
- Itens planejados, comprados e pendentes.
- Pre-visualizacao no app.
- Compartilhamento de PDF offline.

## Sprint 13 - Release APK/AAB

### Status

Planejada.

### Objetivo

Preparar distribuicao.

### Entregas previstas

- Assinatura Android.
- APK release.
- AAB.
- Checklist de publicacao.
- Teste em dispositivo real.
