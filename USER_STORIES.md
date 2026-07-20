# User Stories - CompraCerta

As historias seguem o padrao Scrum: como [persona], quero [acao], para [beneficio].

## US-001 - Base modular

Descricao: Como desenvolvedor, quero uma base modular para evoluir o app com baixo acoplamento.

Objetivo: reduzir risco de regressao e facilitar expansao.

Prioridade: alta.

Dependencias: nenhuma.

Criterios de aceite:

- Estrutura segue Clean Architecture.
- Features possuem camadas separadas.
- Documentacao tecnica existe.

## US-002 - Governanca para IA

Descricao: Como agente de IA, quero documentacao clara para atuar no projeto sem quebrar padroes.

Objetivo: permitir colaboracao segura com automacoes.

Prioridade: alta.

Dependencias: documentacao inicial.

Criterios de aceite:

- `AGENTS.md` define regras.
- Roadmap e processos estao documentados.
- Limites de atuacao estao claros.

## US-003 - Visualizar categorias

Descricao: Como usuario, quero visualizar categorias para organizar meus produtos.

Objetivo: facilitar classificacao dos itens.

Prioridade: alta.

Dependencias: seed JSON.

Criterios de aceite:

- Categorias aparecem no app.
- Seed nao duplica dados.
- Hierarquia e preservada.

## US-004 - Cadastrar produtos

Descricao: Como usuario, quero cadastrar produtos com categoria, unidade e quantidades de referencia.

Objetivo: criar base para estoque e compras.

Prioridade: alta.

Dependencias: categorias.

Criterios de aceite:

- Nome, categoria e unidade sao obrigatorios.
- Quantidades sao validadas.
- Produto e salvo no banco local.

## US-005 - Buscar e filtrar produtos

Descricao: Como usuario, quero buscar e filtrar produtos por nome, categoria e status.

Objetivo: encontrar itens rapidamente sem travar a interface.

Prioridade: alta.

Dependencias: produtos cadastrados.

Criterios de aceite:

- Busca por nome funciona.
- Filtro por categoria funciona.
- Filtro por ativo, inativo e todos funciona.

## US-006 - Desativar produto

Descricao: Como usuario, quero desativar produtos sem remove-los do banco.

Objetivo: manter historico e evitar perda de dados.

Prioridade: alta.

Dependencias: produtos.

Criterios de aceite:

- Produto alterna entre ativo e inativo.
- Registro permanece no banco.
- Listagem reflete novo status.

## US-007 - Registrar estoque

Descricao: Como usuario, quero registrar a quantidade atual de um produto.

Objetivo: saber o que tenho disponivel.

Prioridade: alta.

Dependencias: produtos.

Criterios de aceite:

- Estoque e vinculado ao produto.
- Quantidade nao pode ser negativa.
- Funcionamento offline.

## US-008 - Identificar estoque baixo

Descricao: Como usuario, quero visualizar produtos abaixo do minimo.

Objetivo: saber o que preciso repor.

Prioridade: alta.

Dependencias: estoque.

Criterios de aceite:

- Produto abaixo do minimo e destacado.
- Consulta e otimizada.
- Regra usa quantidade minima do produto.

## US-009 - Ajustar estoque rapidamente

Descricao: Como usuario, quero ajustar estoque de forma rapida.

Objetivo: manter dados atualizados com pouco esforco.

Prioridade: alta.

Dependencias: estoque.

Criterios de aceite:

- Entrada, saida e ajuste sao registrados.
- Movimentacao guarda data e tipo.
- Estoque final e recalculado corretamente.

## US-010 - Registrar compra

Descricao: Como usuario, quero registrar uma compra realizada.

Objetivo: manter historico de consumo e gastos.

Prioridade: media.

Dependencias: produtos.

Criterios de aceite:

- Compra possui data.
- Itens sao vinculados a produtos.
- Historico pode ser consultado.

## US-011 - Consultar historico

Descricao: Como usuario, quero consultar compras por periodo.

Objetivo: entender padroes de consumo.

Prioridade: media.

Dependencias: compras.

Criterios de aceite:

- Filtro por periodo funciona.
- Listagem usa carregamento incremental quando necessario.
- Consulta nao trava a interface.

## US-012 - Criar lista de compras

Descricao: Como usuario, quero criar lista de compras.

Objetivo: planejar compras futuras.

Prioridade: alta.

Dependencias: produtos.

Criterios de aceite:

- Lista e criada offline.
- Itens podem ser adicionados.
- Itens podem ser marcados como comprados.

## US-013 - Gerar lista por estoque baixo

Descricao: Como usuario, quero gerar uma lista com produtos abaixo do minimo.

Objetivo: acelerar reposicao.

Prioridade: media.

Dependencias: estoque e listas.

Criterios de aceite:

- Somente itens abaixo do minimo sao sugeridos.
- Usuario pode revisar antes de salvar.
- Lista funciona offline.

## US-014 - Visualizar dashboard

Descricao: Como usuario, quero ver indicadores de produtos e compras.

Objetivo: ter visao rapida da situacao atual.

Prioridade: media.

Dependencias: estoque, compras e listas.

Criterios de aceite:

- Indicadores carregam sob demanda.
- Dados sao agregados no banco quando possivel.
- Tela permanece leve.

## US-015 - Receber sugestoes inteligentes locais

Descricao: Como usuario, quero receber sugestoes com base em regras locais.

Objetivo: comprar melhor sem depender de internet.

Prioridade: media.

Dependencias: historico e estoque.

Criterios de aceite:

- Sugestao explica a regra usada.
- Processamento e leve.
- Funciona offline.

## US-016 - Usar IA externa opcional

Descricao: Como usuario, quero acionar IA externa apenas quando desejar.

Objetivo: obter apoio inteligente sem comprometer uso basico.

Prioridade: baixa.

Dependencias: motor local e politicas de privacidade.

Criterios de aceite:

- IA nao e obrigatoria.
- Dados enviados sao controlados.
- Existe fallback sem IA.

## US-017 - Gerar relatorios

Descricao: Como usuario, quero relatorios de consumo e compras.

Objetivo: analisar habitos e planejar melhor.

Prioridade: baixa.

Dependencias: historico.

Criterios de aceite:

- Relatorios carregam sob demanda.
- Consultas sao agregadas e otimizadas.
- Exportacao futura permanece preparada.

## US-020 - Receber notificacoes

Descricao: Como usuario, quero notificacoes de reposicao e listas pendentes.

Objetivo: evitar esquecimentos.

Prioridade: baixa.

Dependencias: estoque e listas.

Criterios de aceite:

- Usuario controla preferencias.
- Notificacoes sao locais inicialmente.
- Nao depende de internet.

## US-021 - Gerar relatorio da lista de compras

Descricao: Como usuario, quero visualizar e compartilhar o relatorio de uma lista de compras.

Objetivo: registrar, revisar e compartilhar o planejamento e a execucao da lista.

Prioridade: media.

Dependencias: listas de compras e produtos.

Criterios de aceite:

- Relatorio mostra status, datas, progresso e itens.
- Quantidades planejadas e compradas sao apresentadas.
- PDF pode ser compartilhado sem internet.
- Lista vazia possui estado orientativo.
