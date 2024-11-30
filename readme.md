

### kernel version
`uname -r`

### ip adress
`ip addr`


### netcat simple http server
`while true ; do nc -l -p 1500 -c 'echo -e "HTTP/1.1 200 OK\n\n $(date)"'; done`
