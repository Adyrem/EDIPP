gcloud functions deploy hello_world \
  --gen2 \
  --runtime=python312 \
  --region=europe-west6 \
  --source=. \
  --entry-point=hello_world \
  --trigger-http \
  --allow-unauthenticated
