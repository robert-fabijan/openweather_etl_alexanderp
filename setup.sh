# #!/bin/bash

# # 1. Build the wheel
# python setup.py bdist_wheel

# # 2. Upload to GCS
# WHEEL=$(ls dist/*.whl | tail -n1)
# BASENAME=$(basename "$WHEEL")
# BUCKET=gs://functions-bucket-openweather-etl-alexp/download-elexon-function
# gsutil cp "$WHEEL" "$BUCKET/"

# # 3. Update requirements.txt dynamically
# cat > functions/requirements.txt <<EOF
# my-utils @ $BUCKET/$BASENAME
# EOF
