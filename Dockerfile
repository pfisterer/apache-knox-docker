FROM openjdk:8-jre
LABEL maintainer="Dennis Pfisterer, http://www.dennis-pfisterer.de"

# Prepare the container and install required software
RUN apt-get update && apt-get install -y expect net-tools procps sudo unzip wget xtail && apt-get clean

# The version of Apache Knox to use
ENV KNOX_VERSION 1.6.1

# Create a non-root user to run knox
RUN groupadd -r knox && useradd --no-log-init -r -g knox knox
RUN adduser knox sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chmod a+rwx /opt

USER knox

# Download
RUN mkdir -p /opt
WORKDIR /opt

RUN wget -q -O knox.zip https://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist/knox/${KNOX_VERSION}/knox-${KNOX_VERSION}.zip && unzip knox.zip && rm knox.zip

# Link to /opt/knox
RUN ln -s /opt/knox-${KNOX_VERSION} /opt/knox
ENV GATEWAY_HOME /opt/knox/

WORKDIR $GATEWAY_HOME

# Create credentials
COPY knox-pw.expect-script /tmp
COPY run-knox.sh /opt

RUN /tmp/knox-pw.expect-script

# Enable mounting an external config
VOLUME /opt/knox/conf

# Expose the port
EXPOSE 8080
EXPOSE 8443

# Start knox
CMD ["/opt/run-knox.sh"]
