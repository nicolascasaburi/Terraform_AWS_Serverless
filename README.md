# AWS-Native Serverless API (Terraform)

## Developer
 
* Casaburi, Nicolas

## About
This project is an AWS-native serverless HTTP API deployed with Terraform. It exposes a REST-style interface backed by DynamoDB for storing items and S3 for file uploads, using an AWS Lambda function as the compute layer and API Gateway HTTP API as the front door. The infrastructure is modular and reproducible, with least-privilege IAM and remote Terraform state stored in S3 with S3 locking for safe, repeatable deployments.

**Services**
- AWS Lambda
- Amazon API Gateway v2 (HTTP API)
- Amazon DynamoDB
- Amazon S3

---

## Prerequisites

- Terraform **~> 1.14**
- AWS CLI configured with credentials for your AWS account
- Python 3.12+ (only if you want to run the handler locally; not required for deploy)

---

## How to deploy

### 1) Create the Terraform state bucket (bootstrap)

```bash
cd bootstrap
terraform init
terraform apply
```

After apply, Terraform prints outputs like:
- `tfstate_bucket_name`
- `region`
- `backend_hcl_snippet`

You can re-print them anytime:

```bash
terraform output
terraform output -raw tfstate_bucket_name
```

---

### 2) Configure the backend for `envs/dev`

In `envs/dev/`, this repo keeps `backend.hcl.example` (template).

You will create a **local** file `backend.hcl` based on the bootstrap output.

#### Create `backend.hcl`

```bash
cd ../envs/dev
cp backend.hcl.example backend.hcl
```

Edit `backend.hcl` and replace:
- `bucket` with the bucket name printed by bootstrap
- `region` with the bootstrap region

---

### 3) Initialize and deploy `envs/dev`

#### Initialize Terraform

```bash
terraform init -backend-config=backend.hcl
```

#### Plan + Apply

```bash
terraform plan
terraform apply
```

---

### 4) Test the API

After `apply`, Terraform prints `api_url`:

```bash
terraform output -raw api_url
```

Set it in a variable:

```bash
API_URL=$(terraform output -raw api_url)
echo "$API_URL"
```

#### Health check

```bash
curl -s "$API_URL/health" | jq .
```

#### Create an item (DynamoDB)

```bash
curl -s -X POST "$API_URL/items" \
  -H "content-type: application/json" \
  -d '{"pk":"item#1","payload":{"color":"blue"}}' | jq .
```

#### Get a presigned S3 upload URL

```bash
curl -s -X POST "$API_URL/uploads" \
  -H "content-type: application/json" \
  -d '{"key":"uploads/test.txt","content_type":"text/plain"}' | jq .
```

The response includes a `url`. Upload a file with:

```bash
curl -X PUT "<PRESIGNED_URL>" \
  -H "content-type: text/plain" \
  --data-binary @README.md
```

---

## Lambda code (Python + boto3)

The function code lives in:

```
app/handler.py
```

It implements:
- `GET /health` : verifies the API and Lambda are reachable and working.
- `POST /items` : puts an item into DynamoDB.
- `POST /uploads` : generates a presigned PUT URL for S3.

---

## Cleaning up

Destroy the main stack:

```bash
cd envs/dev
terraform destroy
```

Destroy bootstrap:

```bash
cd ../../bootstrap
terraform destroy
```

> By default the tfstate bucket is created with `force_destroy = false` to prevent accidental state deletion.
> You may need to manually empty the bucket if you need to remove it.