FROM debian:9
LABEL maintainer="Dennis Pfisterer, http://www.dennis-pfisterer.de"

# Prepare the container and install required software
RUN apt-get update && apt-get install -y expect default-jre-headless net-tools procps sudo unzip wget 

# The version of Apache Knox to use
ENV KNOX_VERSION 1.0.0

# Create a non-root user to run knox
RUN groupadd -r knox && useradd --no-log-init -r -g knox knox
RUN adduser knox sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Download and prepare knox
WORKDIR /opt
RUN wget -q -O knox.zip http://ftp.fau.de/apache/knox/1.0.0/knox-1.0.0.zip && unzip knox.zip && rm knox.zip


# TODO Verify download (cf. https://knox.apache.org/books/knox-1-0-0/user-guide.html#Quick+Start)

ENV GATEWAY_HOME /opt/knox-1.0.0/
RUN chown -R knox:knox $GATEWAY_HOME 
RUN chmod ug+rw -R $GATEWAY_HOME

# Fix directory permissions
RUN find $GATEWAY_HOME -type d -print0 | xargs -0 chmod a+x

# Switch to non-root
USER knox
WORKDIR $GATEWAY_HOME

# Create credentials
COPY knox-pw.expect-script /tmp
COPY run-knox.sh /opt

RUN ls -la /opt/
RUN ls -la /opt/knox-1.0.0/
RUN ls -la /opt/knox-1.0.0/bin/

# Remember to change version 1.0.0 in here, too
# Does not work on Dockerhub (permission denied @ spawn): RUN /tmp/knox-pw.expect-script
# Dirty workaround:
COPY master-secret /opt/knox-1.0.0/data/security/master
USER root
RUN chown knox:knox $GATEWAY_HOME -R
USER knox
# /workaround

# Enable mounting an external config
VOLUME /opt/knox-1.0.0/conf

# Expose the port
EXPOSE 8443

# Start knox
CMD ["/opt/run-knox.sh"]
