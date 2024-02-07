# Use Ubuntu as the base image for simplicity
FROM ubuntu:20.04

# Avoid prompts from apt
ARG DEBIAN_FRONTEND=noninteractive

# Accept build arguments
ARG BUILD_ARG1=default_value
ARG BUILD_ARG2

# Environment variable to test artifact copying
ENV TEST_ENV="Test environment variable set in Dockerfile"

# Update and install curl (as an example package)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy artifacts from the repository
COPY . /app

# Demonstrate build arguments are passed correctly
# Write build arguments to a file
RUN echo "Build Arg 1: $BUILD_ARG1" > /app/build_args.txt && \
    echo "Build Arg 2: $BUILD_ARG2" >> /app/build_args.txt

# Command to keep the container running for inspection
CMD ["tail", "-f", "/dev/null"]
