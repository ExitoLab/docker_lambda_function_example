from mangum import Mangum
from fastapi import FastAPI

app = FastAPI()

@app.get("/api")
def read_root():
    return {"Welcome": "Welcome to the FastAPI on Lambda"}

@app.get("/health")
def read_health():
    return {"Health": "Checking endpoint"}

@app.get("/message")
def read_message():
    return {"Message": "sending message"}

# Define the Lambda handler function
def handler(event, context):
    # Instantiate the Mangum adapter and pass the FastAPI app
    mangum_handler = Mangum(app)
    # Call the handler function to process the event
    return mangum_handler(event, context)
