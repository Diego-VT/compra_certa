# Feature template

Use esta estrutura para cada modulo funcional:

```text
feature_name/
  application/
  data/
    datasources/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    controllers/
    pages/
    widgets/
```

Mantenha regras de negocio em `domain`, acesso externo em `data`, orquestracao de estado em `application` e Flutter UI em `presentation`.
