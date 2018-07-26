#!/usr/bin/env bash

if ! which nginx >/dev/null; then
	echo "Error: nginx not installed or not in PATH";
	exit 1
fi

nginx -c "$(pwd)/nginx.conf"
