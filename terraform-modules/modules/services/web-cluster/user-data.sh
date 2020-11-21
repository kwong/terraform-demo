#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World</h1>
<p>DB ADDRESS: ${db_address}</p>
<p>DB PORT: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &