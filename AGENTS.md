# AGENTS - CompraCerta

Este documento orienta agentes de IA e automacoes que atuarem no projeto CompraCerta.

## Objetivo

Garantir que qualquer agente trabalhe de forma previsivel, segura e consistente com a arquitetura atual do projeto.

## Contexto do projeto

CompraCerta e um aplicativo Flutter para organizacao de compras, categorias e produtos.

Tecnologias atuais:

- Flutter e Dart.
- Clean Architecture.
- Riverpod.
- Go Router.
- Drift/SQLite.
- Material Design 3.
- Testes com `flutter_test`.

Modulos atuais:

- Categorias com seed JSON.
- Produtos com cadastro, edicao, busca, filtros e ativacao/desativacao logica.

## Regras para agentes

- Nao alterar o projeto `gestao_emprestimos_mobile`.
- Trabalhar apenas em `compra_certa`, salvo orientacao explicita.
- Nao implementar funcionalidades fora do escopo solicitado.
- Nao alterar banco de dados sem atualizar migrations, testes e documentacao.
- Nao remover dados fisicamente quando a regra pedir exclusao logica.
- Nao misturar responsabilidades de UI, dominio e dados.
- Nao acessar Drift diretamente na camada de presentation.
- Sempre preservar Clean Architecture e Repository Pattern.

## Diretriz obrigatoria de performance

O CompraCerta deve continuar leve e utilizavel em smartphones simples e intermediarios. Toda implementacao deve considerar custo de memoria, processamento, banco local e renderizacao.

Agentes devem seguir obrigatoriamente:

- Evitar carregar listas grandes inteiras na memoria.
- Usar paginacao, filtros ou busca sob demanda quando houver muitos registros.
- Evitar widgets gigantes; dividir telas complexas em widgets menores.
- Evitar logica pesada na camada de interface.
- Manter consultas ao Drift/SQLite objetivas e filtradas.
- Criar indices no banco quando filtros frequentes exigirem otimizacao.
- Evitar uso excessivo de imagens e assets pesados.
- Evitar dependencias desnecessarias.
- Garantir que cadastro, estoque e lista de compras funcionem offline.
- Nao executar IA local pesada no dispositivo.
- Recursos de IA externa devem ser opcionais e acionados sob demanda.
- Dashboards, relatorios e historico devem carregar dados sob demanda.

Critérios minimos:

- Tela inicial deve abrir rapidamente.
- Produtos devem permitir busca sem travar a interface.
- Categorias devem ser carregadas por nivel, busca ou filtro quando o volume crescer.
- Banco local deve evitar duplicidades e consultas desnecessarias.
- Mudancas relevantes devem ser testadas com `flutter analyze`, `flutter test` e, quando possivel, em dispositivo fisico.

## Padrao de implementacao

Toda feature deve seguir:

```text
features/nome_feature/
  application/
  data/
    datasources/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    pages/
    widgets/
```

## Testes obrigatorios

Antes de finalizar mudancas em codigo, executar:

```bash
flutter analyze
flutter test
```

Novas regras de negocio devem ter testes. Novos formularios devem ter validacoes cobertas ao menos por testes de datasource/usecase ou widget quando aplicavel.

## Commits

Usar mensagens objetivas no estilo:

```text
feat: adicionar modulo de estoque
fix: corrigir filtro de produtos
docs: atualizar modelo de dados
test: cobrir seed de categorias
refactor: reorganizar providers de produtos
```

## Limites de atuacao

Agentes nao devem:

- criar APK/AAB sem pedido explicito;
- publicar em loja sem pedido explicito;
- adicionar IA externa sem decisao arquitetural;
- alterar credenciais, tokens, keystores ou secrets;
- executar comandos destrutivos sem autorizacao.

## Checklist antes de finalizar

- Escopo atendido.
- Arquitetura preservada.
- Impacto de performance avaliado.
- Testes executados.
- Documentacao atualizada quando necessario.
- Nenhuma alteracao acidental em projeto externo.

## Política de Consulta Automática da Documentação

Esta política deve ser seguida obrigatoriamente por qualquer agente de IA (ChatGPT, Codex, GitHub Copilot, Gemini, Claude ou qualquer outro) que participe do desenvolvimento do projeto CompraCerta.

### 1. Fonte oficial do projeto

Toda a documentacao oficial do projeto deve ser considerada a Single Source of Truth (SSOT).

Antes de responder qualquer solicitacao do usuario ou iniciar qualquer implementacao, o agente deve identificar automaticamente toda a documentacao relacionada ao contexto da solicitacao.

### 2. Consulta automática

Sempre que receber uma nova solicitacao, o agente deve localizar e consultar automaticamente toda a documentacao pertinente.

Exemplos de documentos que podem ser consultados:

#### Raiz do projeto

- README.md
- AGENTS.md
- CONTRIBUTING.md
- CHANGELOG.md
- ROADMAP.md
- DECISIONS.md
- PRODUCT_VISION.md
- PRODUCT_BACKLOG.md
- USER_STORIES.md
- MVP.md
- PROJECT_BOARD.md
- MILESTONES.md
- SECURITY.md
- TECH_DEBT.md
- UI_UX_GUIDELINES.md
- CODE_STYLE.md
- VERSIONING.md
- RELEASE_NOTES.md

#### Pasta docs/

- PRD.md
- ARQUITETURA.md
- MODELO_DADOS.md
- REGRAS_NEGOCIO.md
- PLANO_TESTES.md
- PRODUCT_STRATEGY.md
- NON_FUNCTIONAL_REQUIREMENTS.md
- RELEASE_PROCESS.md

#### Pasta docs/sprints/

Sempre consultar automaticamente a documentacao da Sprint correspondente antes de qualquer implementacao.

### 3. Não solicitar informações já documentadas

O agente nao deve solicitar ao usuario informacoes que ja estejam registradas na documentacao oficial do projeto.

Sempre utilizar a documentacao existente como contexto principal antes de fazer perguntas.

### 4. Identificação de conflitos

Caso existam informacoes conflitantes entre documentos, o agente deve:

- identificar claramente o conflito;
- explicar o impacto tecnico ou funcional;
- sugerir a melhor solucao;
- aguardar aprovacao do usuario antes de prosseguir.

Nunca assumir uma interpretacao quando houver conflito.

### 5. Ausência de documentação

Caso alguma informacao necessaria nao exista na documentacao, o agente deve:

- identificar exatamente qual informacao esta faltando;
- sugerir qual documento deveria ser atualizado;
- somente então solicitar esclarecimentos ao usuario.

### 6. Validação antes da implementação

Antes de iniciar qualquer implementacao, o agente deve verificar automaticamente se:

- existe Sprint planejada para a funcionalidade;
- existe User Story correspondente;
- existe item no Product Backlog;
- a funcionalidade esta prevista no Roadmap;
- as Regras de Negocio estao documentadas;
- o Modelo de Dados suporta a implementacao;
- a arquitetura permite a alteracao;
- nao existem conflitos com funcionalidades ja implementadas.

Caso alguma dessas validacoes falhe, o agente deve apresentar um relatorio tecnico antes de iniciar qualquer implementacao.

### 7. Hierarquia oficial da documentação

Quando existir conflito entre documentos, seguir obrigatoriamente a seguinte ordem de prioridade:

1. Solicitacao atual do usuario (quando altera ou complementa o escopo).
2. AGENTS.md.
3. Documento da Sprint atual.
4. PRODUCT_BACKLOG.md.
5. USER_STORIES.md.
6. ROADMAP.md.
7. PRD.md.
8. REGRAS_NEGOCIO.md.
9. MODELO_DADOS.md.
10. Demais documentos do projeto.

Nunca ignorar essa hierarquia.

### 8. Fluxo obrigatório

Antes de qualquer implementacao:

1. Identificar automaticamente a documentacao relacionada.
2. Validar consistencia entre os documentos.
3. Identificar conflitos.
4. Identificar dependencias.
5. Explicar resumidamente o plano de implementacao.
6. Somente entao iniciar o desenvolvimento.

### 9. Objetivo da política

Esta politica tem como objetivos:

- transformar a documentacao na referencia oficial do projeto;
- reduzir prompts repetitivos;
- evitar retrabalho;
- evitar inconsistencias entre documentacao e codigo;
- garantir rastreabilidade das decisoes;
- manter alinhamento entre arquitetura, regras de negocio e implementacao;
- facilitar a colaboracao entre diferentes agentes de IA e desenvolvedores.

### Resultado esperado

Apos esta atualizacao, qualquer agente de IA deve conseguir iniciar uma Sprint apenas com um comando simples, como:

- "Iniciar Sprint 05"
- "Revisar Sprint 06"
- "Finalizar Sprint 07"
- "Preparar proxima Release"

Utilizando automaticamente toda a documentacao oficial do projeto como contexto, sem necessidade de o usuario repetir regras, padroes ou processos ja documentados.

## Governanca do Projeto

Todo agente de IA ou automacao que atuar no CompraCerta deve tratar a documentacao oficial como fonte de verdade do produto e da engenharia.

Diretrizes obrigatorias:

- Seguir `PRODUCT_VISION.md`, `ROADMAP.md`, `DECISIONS.md`, `VERSIONING.md` e os documentos em `docs/`.
- Nunca quebrar a arquitetura definida em `docs/ARQUITETURA.md`.
- Nunca iniciar uma sprint futura sem concluir, revisar ou registrar a situacao da sprint anterior.
- Nunca implementar funcionalidades fora do roadmap aprovado.
- Sempre atualizar documentacao quando uma decisao, regra, fluxo, banco ou comportamento for alterado.
- Registrar mudancas relevantes em `CHANGELOG.md` e `RELEASE_NOTES.md`.
- Sempre executar `flutter analyze` antes de concluir entregas.
- Sempre executar `flutter test` antes de concluir entregas.
- Solicitar aprovacao do usuario antes de commit, push, release ou publicacao.
- Preservar funcionamento offline, performance e privacidade como requisitos de primeira classe.

Antes de finalizar uma etapa, o agente deve validar se os documentos impactados foram atualizados e se o escopo executado permanece coerente com a sprint atual.
