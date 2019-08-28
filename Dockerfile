FROM debian:9
LABEL maintainer="Dennis Pfisterer, http://www.dennis-pfisterer.de"

# Prepare the container and install required software
RUN apt-get update && apt-get install -y expect default-jre-headless net-tools procps sudo unzip wget 

# The version of Apache Knox to use
ENV KNOX_VERSION 1.3.0

# Create a non-root user to run knox
RUN groupadd -r knox && useradd --no-log-init -r -g knox knox
RUN adduser knox sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chmod a+rwx /opt

USER knox

WORKDIR /opt

RUN wget -q -O knox.zip http://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist/knox/1.3.0/knox-1.3.0.zip && unzip knox.zip && rm knox.zip
# TODO Verify download (cf. https://knox.apache.org/books/knox-1-1-0/user-guide.html#Quick+Start)

RUN ln -s /opt/knox-$KNOX_VERSION /opt/knox

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
