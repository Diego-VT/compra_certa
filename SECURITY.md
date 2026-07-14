# Security - CompraCerta

## Principios

- Privacidade por padrao.
- Dados locais sempre que possivel.
- Minimo compartilhamento de informacoes.
- Nenhum secret no repositorio.
- Integracoes externas opcionais e controladas.

## LGPD

O CompraCerta deve respeitar principios da LGPD:

- coletar somente dados necessarios;
- informar finalidade de uso;
- permitir controle do usuario sobre seus dados;
- evitar envio automatico para terceiros;
- documentar qualquer integracao externa futura.

## Privacidade

As funcoes principais devem funcionar offline, com dados persistidos localmente em SQLite via Drift.

Dados de produtos, compras e consumo devem ser tratados como informacoes privadas do usuario.

## Armazenamento Local

- O banco local e a fonte primaria das funcoes principais.
- Backups futuros devem ser opcionais.
- Dados sensiveis nao devem ser gravados em logs.
- Migrations devem preservar dados existentes.

## Autenticacao Futura

Autenticacao nao faz parte do MVP. Caso seja adicionada:

- deve ser opcional para uso local;
- deve proteger sincronizacao e backups;
- deve ser registrada em `DECISIONS.md`;
- deve ter plano de seguranca e privacidade.

## Sincronizacao Futura

Sincronizacao nao deve ser requisito para uso basico. Se implementada:

- deve usar conexao segura;
- deve ter consentimento do usuario;
- deve lidar com conflitos;
- deve permitir uso offline.

## Backups

Backups futuros devem:

- ser opcionais;
- informar conteudo exportado;
- permitir restauracao segura;
- evitar exposicao de dados pessoais.

## Protecao de Dados

- Nao salvar tokens em arquivos versionados.
- Nao expor banco ou backups publicamente.
- Revisar dependencias novas.
- Tratar erros sem revelar dados sensiveis.

## IA externa

- IA externa deve ser acionada manualmente pelo usuario.
- O app nao deve enviar dados automaticamente para terceiros.
- O contexto enviado deve ser minimizado e sanitizado.
- Tokens, chaves de API e configuracoes sensiveis nao devem ser versionados.
- Falhas de IA devem usar fallback local sem bloquear funcoes principais.
- A Sprint 10 inicia com cliente externo desativado por padrao ate existir decisao sobre provedor, credenciais e armazenamento seguro.
