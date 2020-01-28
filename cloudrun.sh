# Before Starting lab
	# Create an OAuth consent screen for your app
    # Create OAuth client ID (Then Copy Client ID)
	# Create Firestore Native Database
clientID=$1

# Enable all APIs do this seperately
gcloud services enable run.googleapis.com

# Create a new GCS bucket with name as <PROJECT_ID>-customer
gsutil mb gs://$DEVSHELL_PROJECT_ID-customer

# Create a new GCS bucket with name as <PROJECT_ID>-public
gsutil mb gs://$DEVSHELL_PROJECT_ID-public
gsutil iam ch allUsers:objectViewer gs://$DEVSHELL_PROJECT_ID-public

# Import customer data into Firestore Database (but first create a Native Mode Firestore)
gsutil cp -r gs://spls/gsp645/2019-10-06T20:10:37_43617/ gs://$DEVSHELL_PROJECT_ID-customer
gcloud beta firestore import gs://$DEVSHELL_PROJECT_ID-customer/2019-10-06T20:10:37_43617

# Build a REST API with Google Container Registry and Cloud Run
# Connect REST API to Firestore Database
cd pet-theory/lab04
gcloud builds submit \
  --tag gcr.io/$DEVSHELL_PROJECT_ID/rest-api

gcloud beta run deploy rest-api \
--image gcr.io/$DEVSHELL_PROJECT_ID/rest-api \
--platform managed \
--region us-central1 \
--allow-unauthenticated

####################################################
# Add an authentication check to the REST API code #
####################################################
# Modify the index files accordingly
rm index.js
mv auth_check.js index.js
URL=$(gcloud beta run services describe rest-api --platform managed --region us-central1 --format "value(status.url)")
sed -i "s~REPLACE_URL~$URL~g" website/index.js
sed -i "s~REPLACE_CLIENTID~$clientID~g" index.js

# Copy modified website directory content into <PROJECT_ID>-public bucket
cd website
gsutil cp * gs://$DEVSHELL_PROJECT_ID-public

gcloud builds submit \
  --tag gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api

gcloud beta run deploy rest-api \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated

# Skipped NPM Installs or steps
# npm install google-auth-library
# npm install express
# npm install @google-cloud/firestore
# npm install cors

# Other skipped commands
# PROJECT_ID=$(gcloud config get-value project)
# git clone https://github.com/rosera/pet-theory.git

