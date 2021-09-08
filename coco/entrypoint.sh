#!/usr/bin/dumb-init /bin/sh
. init_coco

if [ ! -n "$IP_DEVICE" ]; then
	IP_DEVICE=$(ip route|grep default|awk '{print $5}')
fi
if [ ! -n "$CORE_HOST" ]; then
	CORE_HOST=http://$(ip -o -4 addr list ${IP_DEVICE} | head -n1 | awk '{print $4}' | cut -d/ -f1):${JUMPSERVER_HTTP_PORT}
fi
formatOutput title
if [ ! -s config.yml ]; then
    formatOutput "Fix File Permissions...."
    chown root.root . -R
    printOK $?
    formatOutput "Generate configuration file config.yml...."
    cat config_example.yml > config.yml
    printOK $?
    sed -i "s|'BOOTSTRAP_TOKEN':.*|'BOOTSTRAP_TOKEN': os.environ.get('BOOTSTRAP_TOKEN') or '',|g" coco/conf.py
    sed -i "s|'BIND_HOST':.*|'BIND_HOST': os.environ.get('BIND_HOST') or '0.0.0.0',|g" coco/conf.py
    sed -i "s|'SSHD_PORT':.*|'SSHD_PORT': os.environ.get('SSHD_PORT') or 2222,|g" coco/conf.py
    sed -i "s|'HTTPD_PORT':.*|'HTTPD_PORT': os.environ.get('HTTPD_PORT') or 5000,|g" coco/conf.py
    sed -i "s|'DEBUG':.*|'DEBUG': os.environ.get('DEBUG') or True,|g" coco/conf.py
    sed -i "245s|if key.isupper():|if key.isupper() and value != '':|" coco/conf.py

fi
exec ./cocod start 
