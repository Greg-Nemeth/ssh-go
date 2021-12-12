FROM ubuntu:21.04 as stage1
RUN apt-get update && apt-get install -y wget gzip
RUN wget -L https://go.dev/dl/go1.17.5.linux-amd64.tar.gz
RUN tar -C /tmp -xzf go1.17.5.linux-amd64.tar.gz
RUN rm go1.17.5.linux-amd64.tar.gz

FROM alpine:3.15
RUN apk add --update --no-cache openssh git ctags tree
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN adduser -h /home/greg -s /bin/sh -D greg
RUN echo -n 'greg:fluffyg88' | chpasswd
RUN mkdir -p /home/greg/go/ && chown greg:greg /home/greg/go
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile && source /etc/profile
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22
COPY entrypoint.sh /
COPY --from=stage1 /tmp /usr/local
