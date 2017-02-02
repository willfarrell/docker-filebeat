# willfarrell/filebeat

**Filebeat: Analyze Log Files in Real Time**
Get ready for the next-generation Logstash Forwarder: Filebeat. Filebeat collects, pre-processes, and forwards log files from remote sources so they can be further enriched and combined with other data sources using Logstash. https://www.elastic.co/products/beats/filebeat

- [documentation](https://www.elastic.co/guide/en/beats/filebeat/index.html)
- [sample filebeat.yml](https://github.com/elastic/filebeat/blob/master/etc/filebeat.yml)

## Supported tags and Dockerfile links

-	[`5.2.0`, `5.2`, `5`, `latest` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/5.1.2/Dockerfile)

-	[`1.3.0`, `1.3`, `1` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.3.0/Dockerfile)
-	[`1.2.3`, `1.2` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.2.3/Dockerfile)
-	[`1.1.2`, `1.1` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.1.2/Dockerfile)
-	[`1.0.1`, `1.0` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.0.1/Dockerfile)


[![](https://images.microbadger.com/badges/version/willfarrell/filebeat.svg)](http://microbadger.com/images/willfarrell/filebeat "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/willfarrell/filebeat.svg)](http://microbadger.com/images/willfarrell/filebeat "Get your own image badge on microbadger.com")

## Run Examples

### docker-cli
```
docker run \
	-v /path/to/filebeat.yml:/etc/filebeat/filebeat.yml \
	willfarrell/filebeat:5
```

### Dockerfile

```Dockerfile
FROM willfarrell/filebeat:5
COPY filebeat.yml /filebeat.yml
```

### docker-compose

```yml
version "2"

services:
  filebeat:
    image: willfarrell/filebeat:1
    command: "filebeat -e -c /etc/filebeat/filebeat.yml"
    environment:
      LOGSTASH_HOST: "192.168.99.100"
      LOGSTASH_PORT: "5044"
    volumes:
     - "./filebeat.yml:/etc/filebeat/filebeat.yml:rw"

```