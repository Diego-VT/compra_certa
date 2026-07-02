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
