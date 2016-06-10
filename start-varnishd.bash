#!/bin/bash
set -e

mkdir -p /etc/varnish
cat >/etc/varnish/default.vcl <<EOF
vcl 4.0;

backend default {
	.host = "$VARNISH_BACKEND_HOST";
	.port = "$VARNISH_BACKEND_PORT";
}

sub vcl_backend_response {
        set beresp.ttl = $VARNISH_DEFAULT_TTL;
        unset beresp.http.Set-Cookie;
}
EOF

exec varnishd 				\
	-j unix,user=varnishd 		\
	-F 				\
	-f /etc/varnish/default.vcl 	\
	-s ${VARNISH_STORAGE_BACKEND} 	\
	-a 0.0.0.0:${VARNISH_PORT}
