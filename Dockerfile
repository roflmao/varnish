FROM debian:jessie

RUN useradd -r -s /bin/false varnishd
RUN apt-get update && apt-get install -y curl python --no-install-recommends && rm -r /var/lib/apt/lists/*
RUN curl http://repo.varnish-cache.org/GPG-key.txt | apt-key add --
RUN echo "deb http://repo.varnish-cache.org/debian/ jessie varnish-4.1" >> /etc/apt/sources.list.d/varnish-cache.list
RUN apt-get update && apt-get install -y varnish --no-install-recommends && rm -r /var/lib/apt/lists/*

COPY start-varnishd.bash /start-varnishd.bash

ENV VARNISH_PORT 80
ENV VARNISH_STORAGE_BACKEND malloc,256m
ENV VARNISH_BACKEND_HOST 127.0.0.1
ENV VARNISH_BACKEND_PORT 8080
ENV VARNISH_DEFAULT_TTL 120s

CMD ["/bin/bash", "/start-varnishd.bash"]
