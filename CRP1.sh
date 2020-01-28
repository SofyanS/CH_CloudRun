# Before Starting lab
	# Create an OAuth consent screen for your app
    # Create OAuth client ID (Then Copy Client ID)
	# Create Firestore Native Database
# Enable all APIs do this seperately
gcloud services enable run.googleapis.com

# Create a new GCS bucket with name as <PROJECT_ID>-customer
gsutil mb gs://$DEVSHELL_PROJECT_ID-customer

# Create a new GCS bucket with name as <PROJECT_ID>-public
gsutil mb gs://$DEVSHELL_PROJECT_ID-public
gsutil iam ch allUsers:objectViewer gs://$DEVSHELL_PROJECT_ID-public

# Import customer data into Firestore Database (can this be done separately)
gsutil cp -r gs://spls/gsp645/2019-10-06T20:10:37_43617/ gs://$DEVSHELL_PROJECT_ID-customer
gcloud beta firestore import gs://$DEVSHELL_PROJECT_ID-customer/2019-10-06T20:10:37_43617