#############################################
# Author: Casaburi, Nicolás Esteban
# Lambda handler app
#############################################

import json
import os
import time
import uuid
import boto3
from botocore.exceptions import ClientError

TABLE_NAME = os.getenv("TABLE_NAME", "")
BUCKET = os.getenv("BUCKET", "")

dynamodb = boto3.resource("dynamodb")
s3 = boto3.client("s3")

def _resp(status: int, body: dict):
    return {
        "statusCode": status,
        "headers": {"content-type": "application/json"},
        "body": json.dumps(body),
    }

def _get_path(event: dict) -> str:
    # HTTP API v2
    return (event.get("rawPath") or "").rstrip("/") or "/"

def _get_method(event: dict) -> str:
    return (event.get("requestContext", {})
                .get("http", {})
                .get("method", "GET")).upper()

def handler(event, context):
    method = _get_method(event)
    path = _get_path(event)

    if method == "GET" and path == "/health":
        return _resp(200, {"ok": True, "ts": int(time.time())})

    if method == "POST" and path == "/items":
        if not TABLE_NAME:
            return _resp(500, {"error": "TABLE_NAME env var not set"})

        try:
            payload = json.loads(event.get("body") or "{}")
        except json.JSONDecodeError:
            return _resp(400, {"error": "Invalid JSON body"})

        item_id = payload.get("id") or str(uuid.uuid4())
        pk = f"ITEM#{item_id}"
        now = int(time.time())

        item = {
            "pk": pk,
            "created_at": now,
            "data": payload.get("data", payload),
        }

        try:
            table = dynamodb.Table(TABLE_NAME)
            table.put_item(Item=item)
        except ClientError as e:
            return _resp(500, {"error": "DynamoDB put_item failed", "detail": str(e)})

        return _resp(201, {"id": item_id, "pk": pk})

    if method == "POST" and path == "/uploads":
        if not BUCKET:
            return _resp(500, {"error": "BUCKET env var not set"})

        try:
            payload = json.loads(event.get("body") or "{}")
        except json.JSONDecodeError:
            payload = {}

        key = payload.get("key") or f"uploads/{uuid.uuid4()}.bin"
        expires = int(payload.get("expires_in", 300))

        try:
            url = s3.generate_presigned_url(
                ClientMethod="put_object",
                Params={"Bucket": BUCKET, "Key": key},
                ExpiresIn=expires,
            )
        except ClientError as e:
            return _resp(500, {"error": "Failed to generate presigned URL", "detail": str(e)})

        return _resp(200, {"bucket": BUCKET, "key": key, "url": url, "expires_in": expires})

    return _resp(404, {"error": "Not Found", "method": method, "path": path})
