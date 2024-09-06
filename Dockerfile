# Use an official Python image as the base
FROM python:3.9-slim

# Install Node.js and npm
RUN apt-get update && apt-get install -y \
    curl \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Install Robot Framework and Browser library
RUN pip install --no-cache-dir robotframework robotframework-browser


RUN npx playwright install-deps

# Initialize the Browser library
RUN rfbrowser init

# Copy your requirements.txt (if you need additional Python libraries)
COPY requirements.txt /opt/robotframework/requirements.txt

# Install the Python dependencies
RUN pip install --no-cache-dir -r /opt/robotframework/requirements.txt

# Set the working directory
WORKDIR /opt/robotframework

# Command to run tests (this can be overridden)
CMD ["robot", "--outputdir", "/opt/robotframework/results", "."]