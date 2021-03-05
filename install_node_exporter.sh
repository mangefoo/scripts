#!/bin/bash

ARCH=armv7
FILE_BASE=node_exporter-1.1.1.linux-$ARCH
TAR_FILE=$FILE_BASE.tar.gz

rm -f $TAR_FILE
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.1/$TAR_FILE
tar zxvf $TAR_FILE
cp $FILE_BASE/node_exporter /usr/local/bin/
chmod +x /usr/local/bin/node_exporter
useradd -m -s /bin/bash node_exporter
mkdir -p /var/lib/node_exporter/textfile_collector
chown -R node_exporter:node_exporter /var/lib/node_exporter
cat<<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter

[Service]
# Provide a text file location for https://github.com/fahlke/raspberrypi_exporter data with the
# --collector.textfile.directory parameter.
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory /var/lib/node_exporter/textfile_collector

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service

echo "Run systemctl status node_exporter.service"
