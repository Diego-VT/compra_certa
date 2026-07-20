# Sprint 13 - Release APK/AAB

## Objetivo

Preparar distribuicao Android e base para publicacao futura.

## Escopo

- APK release.
- AAB.
- Assinatura Android.
- Checklist de publicacao.
- Teste em dispositivo fisico.

## Fora do Escopo

- Publicacao automatica sem aprovacao.
- iOS.
- Sincronizacao.

## Regras de Negocio

- Release so ocorre com aprovacao do usuario.
- Secrets e keystores nao devem ser versionados.
- Changelog e release notes devem estar atualizados.

## Arquitetura Envolvida

Processo de build e release, sem mudanca de arquitetura.

## Modulos Envolvidos

- Android build.
- Documentacao de release.

## Tabelas Afetadas

- Nenhuma.

## Providers

- Nenhum.

## Repositories

- Nenhum.

## Usecases

- Nenhum.

## Telas Previstas

- Nenhuma nova.

## Testes Necessarios

- `flutter analyze`.
- `flutter test`.
- Teste manual em dispositivo fisico.
- Instalar APK gerado.

## Pre-requisitos Recebidos da Sprint 12

- [x] Sincronizacao de notificacoes na abertura e retomada do aplicativo.
- [x] Cancelamento de notificacoes obsoletas antes do novo agendamento.
- [x] Fonte Unicode Roboto incorporada ao PDF.
- [x] Documentacao de produto e governanca consolidada.
- [x] Versao pos-0.12.0 definida como `0.13.0+13`.
- [x] `flutter analyze` aprovado.
- [x] 75 testes automatizados aprovados.
- [x] Instalacao e inicializacao da versao de desenvolvimento no moto g20.
- [ ] Validacao manual de notificacoes e compartilhamento do PDF no moto g20.

### Roteiro da Validacao Android Pendente

- [x] Instalar e abrir o aplicativo no aparelho.
- Conceder a permissao de notificacoes quando solicitada.
- Ativar alertas, colocar produto abaixo do estoque minimo e manter lista pendente.
- Fechar e reabrir o aplicativo, conferindo o acionamento e a ausencia de duplicatas.
- Concluir ou remover o evento e conferir o cancelamento da notificacao obsoleta.
- Gerar e compartilhar um PDF contendo acentos, cedilha e simbolos.

## Criterios de Aceite

- APK gerado.
- AAB gerado.
- App instalado e aberto em dispositivo real.
- Documentacao de release atualizada.

## Riscos

- Configuracao de assinatura.
- Diferencas entre debug e release.
- Falta de evidencias de teste real.

## Checklist de Conclusao

- Analyze OK.
- Testes OK.
- APK/AAB gerados.
- Release notes atualizadas.
- Aprovacao do usuario.
- Push realizado quando solicitado.
