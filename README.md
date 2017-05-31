# willfarrell/filebeat

**Official Image:** https://github.com/elastic/beats-docker. Note uses `centos:7` as it's base. See [#12](https://github.com/elastic/beats-docker/issues/12)

**Filebeat: Analyze Log Files in Real Time**
Get ready for the next-generation Logstash Forwarder: Filebeat. Filebeat collects, pre-processes, and forwards log files from remote sources so they can be further enriched and combined with other data sources using Logstash. https://www.elastic.co/products/beats/filebeat

- [documentation](https://www.elastic.co/guide/en/beats/filebeat/index.html)
- [sample filebeat.yml](https://github.com/elastic/filebeat/blob/master/etc/filebeat.yml)

## Supported tags and Dockerfile links

-	[`5.2.0`, `5.2`, `5`, `latest` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/5.2.0/Dockerfile)
-	[`5-stdin` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/5-stdin/Dockerfile)

-	[`5.1.2`, `5.1` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/5.1.2/Dockerfile)

-	[`1.3.0`, `1.3`, `1` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.3.0/Dockerfile)
-	[`1.2.3`, `1.2` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.2.3/Dockerfile)
-	[`1.1.2`, `1.1` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.1.2/Dockerfile)
-	[`1.0.1`, `1.0` (*Dockerfile*)](https://github.com/willfarrell/docker-filebeat/blob/master/1.0.1/Dockerfile)


[![](https://images.microbadger.com/badges/version/willfarrell/filebeat.svg)](http://microbadger.com/images/willfarrell/filebeat "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/willfarrell/filebeat.svg)](http://microbadger.com/images/willfarrell/filebeat "Get your own image badge on microbadger.com")

## Run Examples

### ENV
```bash
HOSTNAME: Server Name
LOGSTASH_HOST: Recommended name for Logstash Hostname [default=logstash]
LOGSTASH_PORT: Recommended name for Logstash Port [default=5044]
```

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
version "3"

services:
  filebeat:
    image: willfarrell/filebeat:5
    #command: "filebeat -e -c /etc/filebeat/filebeat.yml"
    environment:
      HOSTNAME: "my-server"
      LOGSTASH_HOST: "192.168.99.100"
      LOGSTASH_PORT: "5044"
    volumes:
     - "./filebeat.yml:/etc/filebeat/filebeat.yml:rw"

```

## stdin
There is also a wrapper image over the base image provided here that allows piping of docker stdout into filebeat.

### ENV
```bash
HOSTNAME: Same as above
LOGSTASH_HOST: Logstash Hostname [default=logstash]
LOGSTASH_PORT: Logstash Port [default=5044]
STDIN_CONTAINER_LABEL: Container label to filter what containers to monitor. Set label to `true` to enable. Set ENV to `all` in ignore labels. [default=filebeat.stdin]
```

### docker-cli
```
docker run \
	-v /path/to/filebeat.yml:/etc/filebeat/filebeat.yml \
	-v /var/run/docker.sock:/tmp/docker.sock \
	willfarrell/filebeat:5-stdin
```

### Dockerfile

```Dockerfile
FROM willfarrell/filebeat:5-stdin
COPY filebeat.yml /filebeat.yml
```

### docker-compose

```yml
version "3"

services:
  filebeat:
    image: willfarrell/filebeat:5-stdin
    #command: "filebeat -e -c /etc/filebeat/filebeat.yml"
    environment:
      HOSTNAME: "my-server"
      LOGSTASH_HOST: "192.168.99.100"
      LOGSTASH_PORT: "5044"
      STDIN_CONTAINER_LABEL: "all"
    volumes:
     - "./filebeat.yml:/etc/filebeat/filebeat.yml:rw"
     - "/var/run/docker.sock:/tmp/docker.sock:ro"

```

### Filebeat
```yml
filebeat:
  prospectors:
    - input_type: "stdin"
      document_type: "filebeat-docker-logs"
```
### Logstash
```conf
filter {

  if [type] == "filebeat-docker-logs" {

    grok {
      match => { 
        "message" => "\[%{WORD:containerName}\] %{GREEDYDATA:message_remainder}"
      }
    }

    mutate {
      replace => { "message" => "%{message_remainder}" }
    }

    mutate {
      remove_field => [ "message_remainder" ]
    }

  }

}
```

### Testing
```bash
docker run --label filebeat.stdin=true -d alpine /bin/sh -c 'while true; do echo "Hello $(date)"; sleep 1; done'
docker build -t filebeat
docker run -v /var/run/docker.sock:/tmp/docker.sock filebeat
```

## Contributors
- @bargenson - main logic for the docker stdin
- @gdubya - idea to use labels to choose what containers to log
