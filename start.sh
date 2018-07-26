#!/usr/bin/env bash
set -eo pipefail

# make temp directory
dir="$(mktemp -d -t "local-80-proxy-XXXXXX")"
path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cleanup(){
	rm -r "$dir"
}

trap cleanup EXIT

if ! which nginx >/dev/null; then
	echo "Error: nginx not installed or not in PATH";
	exit 1
fi

host="$1"
port="$2"

if [[ "$host" == "" ]]; then
	cat <<EOF
Usage: ./start.sh <host> [<port>]

Proxies all traffic

No host specified.
EOF
	exit 1
fi

if [[ "$port" == "" ]]; then
	port="3000"
fi

# sed the nginx.conf with variables.
<"$path/nginx.conf" sed "s|@PORT@|$port|g;s|@HOST@|$host|g;s|@PATH@|$path|g" >"$dir/nginx.conf"

echo "Proxying traffic from localhost:80 to localhost:$port with header 'Host: $host'"

nginx -c "$dir/nginx.conf"
