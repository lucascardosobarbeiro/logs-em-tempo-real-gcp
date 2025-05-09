from google.cloud import pubsub_v1
from flask import Request, jsonify
import os
import json

PROJECT_ID = os.environ.get("GCP_PROJECT")
TOPIC_ID = os.environ.get("LOG_TOPIC", "logs-topic")

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path(PROJECT_ID, TOPIC_ID)

def receive_logs(request: Request):
    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST',
            'Access-Control-Allow-Headers': 'Content-Type'
        }
        return ('', 204, headers)

    try:
        log_entry = request.get_json()
        data = json.dumps(log_entry).encode("utf-8")
        publisher.publish(topic_path, data)
        return jsonify({"message": "Log recebido com sucesso"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400