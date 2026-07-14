# Versioning - CompraCerta

O CompraCerta utiliza Semantic Versioning como referencia para evolucao de versoes.

Formato:

```text
MAJOR.MINOR.PATCH
```

Exemplo:

```text
1.4.2
```

## MAJOR

Incrementado quando ha mudancas incompativeis, quebras relevantes de comportamento, alteracoes profundas de arquitetura ou migracoes que exigem atencao especial.

Exemplo:

```text
1.0.0 -> 2.0.0
```

## MINOR

Incrementado quando novas funcionalidades sao adicionadas de forma compativel com a versao atual.

Exemplo:

```text
1.1.0 -> 1.2.0
```

## PATCH

Incrementado para correcoes, ajustes pequenos, documentacao, melhorias internas e mudancas que nao alteram funcionalidades principais.

Exemplo:

```text
1.2.0 -> 1.2.1
```

## Canais de Release

### Alpha

Versao inicial para validacao tecnica. Pode conter funcionalidades incompletas e instabilidade.

Formato sugerido:

```text
0.2.0-alpha.1
```

### Beta

Versao funcional para validacao ampliada. Deve ter fluxos principais usaveis, mas ainda pode receber ajustes de experiencia e estabilidade.

Formato sugerido:

```text
0.5.0-beta.1
```

### Release Candidate

Versao candidata a producao. Deve conter escopo fechado, documentacao atualizada e validacao completa.

Formato sugerido:

```text
1.0.0-rc.1
```

### Producao

Versao publicada para usuarios finais. Deve ter release notes, changelog, testes e pacote Android validado.

Formato sugerido:

```text
1.0.0
```

## Mapa de Versoes do Roadmap

O CompraCerta usa versoes pre-1.0 para representar a conclusao incremental das sprints principais.

```text
0.1.0 - Fundacao do projeto
0.2.0 - Categorias
0.3.0 - Produtos
0.4.0 - Melhorias em Produtos
0.5.0 - Estoque
0.6.0 - Historico de Compras
0.7.0 - Lista de Compras
0.8.0 - Dashboard
0.9.0 - Motor Inteligente Local
0.10.0 - Integracao com IA externa opcional
1.0.0 - MVP pronto para release
```

Observacao: `1.0.0` permanece reservado para o release tecnico/MVP conforme `MVP.md` e Sprint 13. Entregas compativeis posteriores a `0.9.0` podem usar a sequencia pre-1.0, como `0.10.0`, ate o fechamento formal do MVP.

## Regras do Projeto

- Toda release deve atualizar `CHANGELOG.md`.
- Toda release publicavel deve atualizar `RELEASE_NOTES.md`.
- Alteracoes de banco devem ser documentadas em `docs/MODELO_DADOS.md`.
- Mudancas arquiteturais devem ser registradas em `DECISIONS.md`.
- Releases devem seguir `docs/RELEASE_PROCESS.md`.
