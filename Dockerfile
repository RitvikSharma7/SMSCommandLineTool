# Use the official Ubuntu base image
FROM ubuntu

# Set working directory to /home/ritvik/DockerWork/SMSContainer
WORKDIR /var/lib/smsui

RUN apt-get update && \
    apt-get install -y whiptail

# Copy the scripts into the container
COPY smstui.sh /usr/local/bin/smstui
COPY smscui.sh /usr/local/bin/smscui

# Add execute permissions to the script
RUN chmod u+x /usr/local/bin/sms*ui

# Run the script with bash when the container starts
CMD ["smscui"]

