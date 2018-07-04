FROM debian:stretch-20180625

ENV APP_ROOT /app
ENV PATH $PATH:/app

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update\
 && apt-get install -y --no-install-recommends curl ca-certificates pandoc build-essential\
 && apt-get clean\
 && rm -rf /var/lib/apt/lists/*\
 && curl -o /usr/local/bin/jq -L\
      https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64\
 && chmod +x /usr/local/bin/jq

RUN mkdir /tmp/work\
 && cd /tmp/work\
 && curl -LO https://github.com/jpmens/jo/releases/download/v1.1/jo-1.1.tar.gz\
 && tar xzf jo-1.1.tar.gz\
 && cd jo-1.1\
 && ./configure\
 && make check\
 && make install\
 && rm -rf /tmp/work

WORKDIR $APP_ROOT

COPY . $APP_ROOT
