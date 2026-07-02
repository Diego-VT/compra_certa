# Contribuindo com o CompraCerta

Obrigado por contribuir com o CompraCerta. Este projeto segue desenvolvimento incremental, com foco em qualidade, arquitetura clara e testes.

## Fluxo de desenvolvimento

1. Atualize sua branch local.
2. Crie uma branch a partir de `master`.
3. Implemente apenas o escopo planejado.
4. Rode formatacao, analise e testes.
5. Abra pull request com resumo e evidencias.

## Padrao de branches

Use nomes curtos e descritivos:

```text
feature/estoque
feature/lista-compras
fix/filtro-produtos
docs/arquitetura
test/produtos
```

## Commits

Use mensagens no formato:

```text
tipo: descricao curta
```

Tipos recomendados:

- `feat`: nova funcionalidade.
- `fix`: correcao.
- `docs`: documentacao.
- `test`: testes.
- `refactor`: reorganizacao sem mudar comportamento.
- `chore`: tarefas auxiliares.

Exemplos:

```text
feat: adicionar filtros de produtos
docs: criar plano de testes
test: cobrir cadastro de produtos
```

## Testes obrigatorios

Antes de abrir PR:

```bash
flutter analyze
flutter test
```

Se alterar banco Drift, tambem rode:

```bash
dart run build_runner build
```

## Padrao de revisao

Toda revisao deve verificar:

- aderencia a Clean Architecture;
- ausencia de acesso direto ao banco na UI;
- uso correto de Riverpod;
- regras de negocio testadas;
- nomes claros;
- ausencia de funcionalidades fora do escopo;
- documentacao atualizada.

## Banco de dados

Mudancas em tabelas exigem:

- atualizar `schemaVersion`;
- criar migration;
- regenerar arquivos Drift;
- atualizar `docs/MODELO_DADOS.md`;
- criar ou atualizar testes.

## UI

A UI deve seguir Material Design 3 e ser simples, responsiva e objetiva.

Evite criar telas decorativas ou fluxos sem necessidade. Priorize clareza operacional.

## Pull requests

Todo PR deve conter:

- resumo do que foi feito;
- comandos executados;
- testes adicionados ou atualizados;
- riscos conhecidos;
- prints ou evidencias quando houver UI.

## Fluxo oficial de contribuicao

O CompraCerta segue um fluxo incremental orientado por sprint, documentacao e validacao tecnica.

Fluxo recomendado:

1. Verificar `ROADMAP.md` e confirmar a sprint atual.
2. Ler `docs/ARQUITETURA.md`, `docs/REGRAS_NEGOCIO.md` e `docs/NON_FUNCTIONAL_REQUIREMENTS.md`.
3. Criar branch a partir de `master`.
4. Implementar apenas o escopo da tarefa aprovada.
5. Manter Clean Architecture, Repository Pattern, Riverpod e Go Router.
6. Atualizar testes quando houver regra de negocio, banco, provider, usecase ou UI relevante.
7. Executar `flutter analyze`.
8. Executar `flutter test`.
9. Atualizar documentacao impactada.
10. Atualizar `CHANGELOG.md`, `RELEASE_NOTES.md` e `ROADMAP.md` quando a entrega mudar o estado do produto.
11. Solicitar revisao e aprovacao.
12. Realizar commit com mensagem objetiva.
13. Fazer push para o repositorio remoto.

Contribuicoes que adicionem dependencias, alterem banco, mudem arquitetura ou introduzam IA externa devem ser acompanhadas de justificativa tecnica e registro em `DECISIONS.md`.
