FROM mongo

COPY mongod.conf /etc/mongod.conf

EXPOSE 27018

ENTRYPOINT ["mongod", "-f", "/etc/mongod.conf"]
