#!/bin/bash

AutoFile="$(ls -1 /etc/init.d/*-libev |head -n1)";

[ -n "$AutoFile" ] || {
echo "Error! "
exit 1
}

sed -i 's|PIDFILE=.*.pid$|PIDFILEPATH=/var/run/$NAME|g' "$AutoFile";
sed -i 's|do_start$|for CONFFILE in `find /etc/$NAME -maxdepth 1 -path "/etc/$NAME/config-obfs*.json" -prune -o -name 'config*.json' -print`; do PIDFILE="$PIDFILEPATH/$(basename $CONFFILE)"; do_start; done|g' "$AutoFile";

[ -d /lib/systemd/system ] && {
find /lib/systemd/system -name '*-libev*' -exec rm -rf {} \;
systemctl daemon-reload
}

chown root:root "$AutoFile";
chmod 755 "$AutoFile";
