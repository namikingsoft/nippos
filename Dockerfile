FROM debian:stretch-20180625 AS build-env

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update\
 && apt-get install -y --no-install-recommends curl ca-certificates\
 && apt-get clean\
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update\
 && apt-get install -y --no-install-recommends build-essential\
 && apt-get clean\
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/work\
 && cd /tmp/work\
 && curl -LO https://github.com/jpmens/jo/releases/download/v1.1/jo-1.1.tar.gz\
 && tar xzf jo-1.1.tar.gz\
 && cd jo-1.1\
 && ./configure\
 && make check\
 && make install\
 && rm -rf /tmp/work

RUN curl -o /usr/local/bin/jq -L\
      https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64\
 && chmod +x /usr/local/bin/jq

FROM debian:stretch-20180625

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update\
 && apt-get install -y --no-install-recommends curl ca-certificates\
 && apt-get clean\
 && rm -rf /var/lib/apt/lists/*

COPY --from=build-env /usr/local/bin/jq /usr/local/bin/jq
COPY --from=build-env /usr/local/bin/jo /usr/local/bin/jo

ENV APP_ROOT /app
ENV PATH $PATH:$APP_ROOT/bin

WORKDIR $APP_ROOT

COPY . $APP_ROOT
