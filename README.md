# willfarrell/filebeat

**Filebeat: Analyze Log Files in Real Time**
Get ready for the next-generation Logstash Forwarder: Filebeat. Filebeat collects, pre-processes, and forwards log files from remote sources so they can be further enriched and combined with other data sources using Logstash. https://www.elastic.co/products/beats/filebeat

- [docs](https://www.elastic.co/guide/en/beats/filebeat/index.html)

## Supported tags and Dockerfile links

-	[`1.0.1`, `1.0` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.1.1/Dockerfile)
-	[`1.1.1`, `1.1` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.1.1/Dockerfile)
-	[`1.2.1`, `1.2`, `1`, `latest` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.2.1/Dockerfile)
-	[`5.0.0-alpha1` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/5.0.0-alpha/Dockerfile)

## Run Examples

### docker-cli
```
docker run \
	-v /path/to/filebeat.yml:/etc/filebeat/filebeat.yml \
	willfarrell/filebeat:5.0.0-alpha1 \
	-c /etc/filebeat/filebeat.yml
```

### Dockerfile

```Dockerfile
FROM willfarrell/filebeat
COPY filebeat/config/ /etc/filebeat/
```

### docker-compose

```yml
version "2"

services:
  filebeat:
    image: willfarrell/filebeat:5.0.0-alpha
    command: "filebeat /etc/filebeat/filebeat.yml"
    environment:
      LOGSTASH_HOST: "192.168.99.100"
      LOGSTASH_PORT: "5044"
    volumes:
     - "./filebeat:/etc/filebeat:ro"
     - "./logs/nginx:/var/log/nginx:ro"
     - "./logs/node:/var/log/node:ro"
     - "./logs/postgres:/var/log/postgres:ro"
     - "./logs/redis:/var/log/redis:ro"

```