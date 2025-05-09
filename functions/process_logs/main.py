from google.cloud import firestore
import base64
import json
import os
import requests

ALERT_KEYWORDS = ["error", "unauthorized", "failure"]
SENDGRID_API_KEY = os.environ.get("SENDGRID_API_KEY")
DEST_EMAIL = os.environ.get("DEST_EMAIL")

def send_email(subject, content):
    if not SENDGRID_API_KEY or not DEST_EMAIL:
        print("SendGrid config ausente.")
        return
    requests.post(
        "https://api.sendgrid.com/v3/mail/send",
        headers={
            "Authorization": f"Bearer {SENDGRID_API_KEY}",
            "Content-Type": "application/json"
        },
        json={
            "personalizations": [{"to": [{"email": DEST_EMAIL}]}],
            "from": {"email": "alert@log-monitor.com"},
            "subject": subject,
            "content": [{"type": "text/plain", "value": content}]
        }
    )

def process_logs(event, context):
    try:
        db = firestore.Client()
        payload = base64.b64decode(event['data']).decode('utf-8')
        log_entry = json.loads(payload)

        db.collection("logs").add(log_entry)

        msg_text = log_entry.get("message", "").lower()
        if any(keyword in msg_text for keyword in ALERT_KEYWORDS):
            send_email("🚨 Alerta de Log Crítico", msg_text)
    except Exception as e:
        print(f"Erro ao processar log: {e}")