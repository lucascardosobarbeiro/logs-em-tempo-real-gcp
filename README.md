# Real-Time Log Monitor com E-mail

Este projeto monitora logs em tempo real usando Cloud Functions, Pub/Sub e Firestore, com alertas por e-mail via SendGrid.

## Tecnologias
- Google Cloud (Cloud Functions, Pub/Sub, Firestore)
- SendGrid (e-mail)
- Terraform
- GitHub Actions (CI/CD)

## Configuração
1. Crie uma conta SendGrid e gere uma API key.
2. Adicione as secrets `SENDGRID_API_KEY` e `DEST_EMAIL` no GitHub.
3. Faça push para a branch `main`.

## Envio de Logs
```json
POST /receive-logs
{
  "message": "Erro no banco de dados",
  "level": "ERROR",
  "timestamp": "2025-05-09T14:00:00Z"
}
```

Mensagens com palavras críticas como "error", "unauthorized" ou "failure" disparam alertas por e-mail.# logs-em-tempo-real-gcp
