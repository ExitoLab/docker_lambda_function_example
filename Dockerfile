# Stage 1: Build dependencies
FROM ubuntu:22.04 as builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-pip

# Copy requirements.txt
COPY requirements.txt /app/

# Install dependencies in a directory for Lambda
RUN pip3 install --no-cache-dir -r requirements.txt -t /app/python

# Stage 2: Create final image
FROM public.ecr.aws/lambda/python:3.10

# Copy dependencies from the builder stage
COPY --from=builder /app/python ${LAMBDA_TASK_ROOT}

# Set working directory
WORKDIR ${LAMBDA_TASK_ROOT}

# Copy Lambda function code
COPY lambda.py ${LAMBDA_TASK_ROOT}/lambda.py

# Expose port 8080 (optional, for local testing with Docker)
EXPOSE 8080

# Set the Lambda handler
CMD ["lambda.handler" ]