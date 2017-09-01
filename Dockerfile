FROM alpine

RUN apk update
RUN apk add curl

# Download kubectl
ENV KUBE_URL https://storage.googleapis.com/kubernetes-release/release/v1.7.1/bin/linux/amd64/kubectl

RUN curl -o /usr/bin/kubectl -LO ${KUBE_URL}
RUN chmod +x /usr/bin/kubectl

ENTRYPOINT ["/usr/bin/kubectl"]
CMD ["version"]
