#!/bin/bash

if [ ! -f /opt/hound/install_done ]; then
        echo "Running setup"
        sed -i 's/\[supervisord\]/\[supervisord\]\r\nnodaemon=true/g' /etc/supervisor/supervisord.conf
        /usr/bin/supervisord -c /etc/supervisor/supervisord.conf&

        sed -i "s|SUPERUSER_EMAIL|"$SUPERUSER_EMAIL"|g" /opt/hound/scripts/docker_expect.sh
        sed -i "s|SUPERUSER_PASSWORD|"$SUPERUSER_PASSWORD"|g" /opt/hound/scripts/docker_expect.sh
        sed -i "s|SERVER_BASE_URL|"$SERVER_BASE_URL"|g" /opt/hound/scripts/docker_expect.sh
        sed -i "s|HONEYMAP_URL|"$HONEYMAP_URL"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|DEBUG_MODE|"$DEBUG_MODE"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|SMTP_HOST|"$SMTP_HOST"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|SMTP_PORT|"$SMTP_PORT"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|SMTP_TLS|"$SMTP_TLS"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|SMTP_SSL|"$SMTP_SSL"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|SMTP_USERNAME|"$SMTP_USERNAME"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|SMTP_PASSWORD|"$SMTP_PASSWORD"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|SMTP_SENDER|"$SMTP_SENDER"|g" /opt/hound/scripts/docker_expect.sh
		sed -i "s|hound_LOG|"$hound_LOG"|g" /opt/hound/scripts/docker_expect.sh

        /opt/hound/scripts/docker_expect.sh

        sed -i 's/\[supervisord\]/\[supervisord\]\r\nnodaemon=true/g' /etc/supervisor/supervisord.conf
        sed -i 's/autostart=false/autostart=true/g' /etc/supervisor/conf.d/hound.conf

        touch /opt/hound/install_done

        supervisorctl stop all
        pkill -f supervisord
        pkill -f nginx
fi
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf