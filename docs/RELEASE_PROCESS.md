# Release Process - CompraCerta

Este documento define o processo oficial para encerramento de sprint e preparacao de release.

## Fluxo Obrigatorio

```text
Planejamento
  |
Implementacao
  |
Revisao Tecnica
  |
flutter analyze
  |
flutter test
  |
Atualizacao da documentacao
  |
Atualizacao do CHANGELOG
  |
Atualizacao do RELEASE_NOTES
  |
Atualizacao do ROADMAP
  |
Solicitar aprovacao do usuario
  |
Commit
  |
Push
  |
Atualizacao da versao quando aplicavel
  |
Marcar Sprint como concluida
```

## Planejamento

Antes de iniciar uma sprint:

- Confirmar objetivo no `ROADMAP.md`.
- Validar regras em `docs/REGRAS_NEGOCIO.md`.
- Conferir impacto em `docs/MODELO_DADOS.md`.
- Confirmar requisitos nao funcionais em `docs/NON_FUNCTIONAL_REQUIREMENTS.md`.

## Implementacao

Durante a implementacao:

- Manter Clean Architecture.
- Evitar funcionalidades fora do escopo.
- Preservar performance e funcionamento offline.
- Criar ou atualizar testes.
- Registrar decisoes arquiteturais relevantes em `DECISIONS.md`.

## Validacao Tecnica

Comandos obrigatorios antes de concluir sprint com codigo:

```bash
flutter analyze
flutter test
```

Quando houver alteracao Drift:

```bash
dart run build_runner build
```

## Atualizacao da Documentacao

Atualizar os documentos impactados:

- `README.md`
- `AGENTS.md`
- `ROADMAP.md`
- `CHANGELOG.md`
- `RELEASE_NOTES.md`
- `docs/ARQUITETURA.md`
- `docs/MODELO_DADOS.md`
- `docs/REGRAS_NEGOCIO.md`
- `docs/PLANO_TESTES.md`

## Aprovacao

Antes de commit e push, solicitar aprovacao do usuario com:

- resumo da entrega;
- arquivos alterados;
- comandos executados;
- pendencias;
- riscos conhecidos.

## Commit e Push

Usar commits objetivos:

```text
feat: adicionar modulo de estoque
docs: atualizar processo de release
fix: corrigir filtro de produtos
```

Fazer push apenas apos aprovacao.

## Encerramento

A sprint so pode ser marcada como concluida quando:

- escopo foi entregue;
- testes obrigatorios foram executados;
- documentacao foi atualizada;
- changelog e release notes foram atualizados;
- usuario aprovou a entrega;
- commit e push foram realizados quando solicitados.
- versao foi atualizada quando aplicavel.
