Deploy startup service

1. Navigate to /etc/systemd/system/
2. Create a service file. Ex. startup.service
3. Open the created file and update the service details. Refer : startup.service
4. use below commands to start/stop/check status
    1. systemctl start startup.service 
    2. systemctl stop startup.service
    3. systemctl status startup.service
5. To update the service use below command
    systemctl edit startup.service --full
6. For audting or troubleshooting the service
    journalctl -u startup.service
 
 
 D07 Service name:  d07-startup.service

Validate the haproxy config file using docker image.

docker run -it --rm --name haproxy-syntax-check -v /home/yogesh/code/haproxy:/usr/local/etc/haproxy:ro  haproxy -c -f /usr/local/etc/haproxy/haproxy-D07.cfg
