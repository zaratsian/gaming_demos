#Setup (assumes the gcloud and bq SKDs are installed)

# Variables
export GCP_PROJECT=gaming-demos
export BIGQUERY_DATASET=streaming
export BIGQUERY_TABLE=game_logs
export PUBSUB_TOPIC=game-logs

echo ""
echo "The following ENV variables have been set:"
echo "GCP_PROJECT:      $GCP_PROJECT"
echo "BIGQUERY_DATASET: $BIGQUERY_DATASET"
echo "BIGQUERY_TABLE:   $BIGQUERY_TABLE"
echo "PUBSUB_TOPIC:     $PUBSUB_TOPIC"
echo ""
sleep 3

echo "Installing Dependencies..."
sleep 3
# Install python dependencies
pip install google-cloud-bigquery==1.12.1
pip install google-cloud-pubsub==0.41.0
pip install random-username==1.0.2

# Create BigQuery Table
echo ""
echo "Creating BigQuery Dataset and Table called $BIGQUERY_DATASET.$BIGQUERY_TABLE"
sleep 3
bq rm -f -t $GCP_PROJECT:$BIGQUERY_DATASET.$BIGQUERY_TABLE
bq --location=US mk --dataset $GCP_PROJECT:$BIGQUERY_DATASET
bq mk --table --location=US $BIGQUERY_DATASET.$BIGQUERY_TABLE uid:STRING,game_id:STRING,game_server:STRING,game_type:STRING,game_map:STRING,event_datetime:TIMESTAMP,player:STRING,killed:STRING,weapon:STRING,x_cord:INTEGER,y_cord:INTEGER


# Create PubSub Topic
echo ""
echo "Creating PubSub Topic called $PUBSUB_TOPIC"
sleep 3
gcloud pubsub topics create $PUBSUB_TOPIC

# Create PubSub Subscription
echo ""
echo "Creating PubSub Subscription called $PUBSUB_TOPIC-sub"
sleep 3
gcloud pubsub subscriptions create --topic $PUBSUB_TOPIC $PUBSUB_TOPIC-sub

# Setup Dataflow Project (PubSub Subscription > BigQuery Streaming)
# I'm currently doing this manually within the GCP Console, under Dataflow.
# Planning to add the CLI option here. 

echo ""
echo "Setup Complete"

#ZEND
