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
