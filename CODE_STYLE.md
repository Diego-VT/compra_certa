# Code Style - CompraCerta

## Nomenclatura

- Arquivos Dart em `snake_case`.
- Classes, entidades e usecases em `PascalCase`.
- Variaveis, metodos e providers em `camelCase`.
- Nomes devem expressar regra de negocio, nao apenas detalhe tecnico.

## Organizacao de Pastas

Cada feature deve seguir:

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

## Widgets

- Manter widgets pequenos e reutilizaveis quando houver complexidade real.
- Evitar logica pesada na camada de presentation.
- Formularios devem centralizar validacoes de UI sem misturar persistencia.

## Providers

- Providers devem orquestrar dependencias e estado.
- Evitar regras de negocio complexas diretamente em providers.
- Datasources e repositories devem ser injetados via Riverpod.

## Repositories

- Domain define contratos.
- Data implementa contratos.
- Presentation nunca acessa Drift diretamente.
- Repositories devem proteger a aplicacao de detalhes do banco.

## Entidades

- Entidades representam conceitos de negocio.
- Evitar dependencia de Drift ou Flutter nas entidades de domain.
- Campos devem refletir linguagem do produto.

## Usecases

- Usecases representam acoes de negocio.
- Devem ser pequenos, testaveis e objetivos.
- Nao devem depender de widgets ou contexto de UI.

## Testes

- Testes devem cobrir regras de negocio.
- Datasources devem ser testados com banco temporario quando aplicavel.
- Widget tests devem validar fluxos visiveis importantes.
- Seeds e migrations devem ter validacao.

## Comentarios

- Preferir codigo claro a comentarios extensos.
- Comentar apenas decisoes nao obvias.
- Documentar regras importantes nos arquivos oficiais.

## Documentacao do Codigo

- Mudancas arquiteturais exigem atualizacao em `docs/ARQUITETURA.md`.
- Mudancas de banco exigem atualizacao em `docs/MODELO_DADOS.md`.
- Mudancas de regra exigem atualizacao em `docs/REGRAS_NEGOCIO.md`.
