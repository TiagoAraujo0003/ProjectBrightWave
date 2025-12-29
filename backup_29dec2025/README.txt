BACKUP - 29 Dezembro 2025 (v2)
================================

Estado atual do código ANTES da validação de certificados expirados.

Para restaurar:
1. Copiar Rep50200.Certificate.al.backup para src\Report\Rep50200.Certificate.al
2. Copiar Pag-Ext50203.PostedSalesInvoiceExt.al.backup para src\PagesExtension\Pag-Ext50203.PostedSalesInvoiceExt.al

Funcionalidade atual:
- Report processa todos os items com certificado da invoice
- Ação na página verifica se existem items com certificado
- Layout Word com tabela para múltiplos items
