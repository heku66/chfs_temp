FROM alpine:latest

LABEL maintainer="solyhe84"

ENV RULE="::r|user:admin:r:filebox:rwd"

COPY chfs /

EXPOSE 80

CMD ["/bin/sh", "-c", "/chfs --rule=$RULE --path=/home"]
