# Decisoes Arquiteturais - CompraCerta

Este documento registra as principais decisoes tomadas no projeto.

## 1. Flutter como framework

### Decisao

Usar Flutter para o desenvolvimento mobile.

### Motivo

- Entrega multiplataforma.
- Boa produtividade.
- Ecossistema maduro.
- Material Design integrado.
- Testabilidade adequada para app mobile.

### Consequencias

- O app pode evoluir para Android, iOS, Web e Desktop.
- Builds nativos dependem da configuracao de cada plataforma.

## 2. Dart como linguagem

### Decisao

Usar Dart, linguagem padrao do Flutter.

### Motivo

- Integracao nativa com Flutter.
- Tipagem estatica.
- Boa experiencia com async/await.

## 3. Clean Architecture

### Decisao

Organizar o projeto em camadas por feature.

### Motivo

- Separar regras de negocio da UI.
- Facilitar testes.
- Reduzir acoplamento.
- Permitir evolucao modular.

### Consequencias

- Mais arquivos por feature.
- Maior clareza de responsabilidades.

## 4. Repository Pattern

### Decisao

Usar contratos de repositorio no dominio e implementacoes na camada data.

### Motivo

- Evitar que UI conheca detalhes de banco.
- Facilitar mocks e testes.
- Permitir trocar fonte de dados futuramente.

## 5. Riverpod para estado e injecao de dependencia

### Decisao

Usar Riverpod como ferramenta de estado e DI.

### Motivo

- Providers testaveis.
- Sobrescrita simples em testes.
- Baixo acoplamento com widgets.
- Bom suporte a estado assincrono.

## 6. Go Router para navegacao

### Decisao

Usar Go Router para rotas declarativas.

### Motivo

- Rotas nomeadas.
- Deep links futuros.
- Guards futuros.
- Estrutura centralizada de navegacao.

## 7. Drift/SQLite para persistencia local

### Decisao

Usar Drift sobre SQLite.

### Motivo

- Banco local tipado.
- Queries seguras.
- Suporte a migrations.
- Banco em memoria para testes.
- Boa base para funcionamento offline.

## 8. Material Design 3

### Decisao

Usar Material Design 3 desde o inicio.

### Motivo

- Consistencia visual.
- Componentes modernos.
- Suporte nativo no Flutter.
- Temas claro e escuro.

## 9. Seed JSON para categorias

### Decisao

Carregar categorias iniciais por JSON em asset.

### Motivo

- Base inicial versionada.
- Facil auditoria.
- Independencia de rede.
- Importacao controlada por `seed_executions`.

### Consequencias

- Alteracoes no seed exigem nova chave versionada.
- O app precisa evitar duplicidade por `id` e `caminhoCompleto`.

## 10. Exclusao logica para produtos

### Decisao

Produtos devem ser desativados por `isAtivo`, nao removidos fisicamente.

### Motivo

- Preservar historico futuro.
- Permitir relatorios confiaveis.
- Evitar quebra de relacionamentos com compras e listas futuras.

## 11. Documentacao como fonte de governanca

### Decisao

Manter documentos oficiais de produto, arquitetura, processo, release, seguranca, backlog, sprints e padroes de codigo.

### Motivo

- Permitir evolucao profissional do projeto.
- Reduzir ambiguidade para desenvolvedores e agentes de IA.
- Garantir rastreabilidade entre roadmap, sprint, implementacao, testes e release.
- Apoiar futura publicacao Android e expansao para iOS.

### Consequencias

- Mudancas relevantes exigem atualizacao documental.
- Sprints devem seguir processo formal de planejamento, validacao e encerramento.
- Agentes devem consultar a documentacao antes de alterar o projeto.

## 12. IA externa opcional por contrato

### Decisao

Iniciar a Sprint 10 com um contrato de cliente de IA em `services/ia`, prompt versionado em asset e cliente padrao desativado.

### Motivo

- Preservar funcionamento offline.
- Evitar credenciais ou secrets no repositorio.
- Permitir troca futura por provedor externo sem acoplar UI ou dominio a HTTP/API especifica.
- Garantir que o usuario acione a IA manualmente.

### Consequencias

- O app passa a ter a arquitetura pronta para IA externa.
- Sem configuracao de provedor, a experiencia usa fallback local.
- A integracao real com API deve ser decidida e documentada antes de receber credenciais, armazenamento seguro e politica de dados definitiva.
