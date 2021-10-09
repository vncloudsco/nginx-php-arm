#!/bin/bash
function nginx_port_checker() {
    while :; do
        port=$(shuf -i 2000-4000 -n 1)
        port_checking=$(netstat -nplt | grep $port)
        port_checkingv2=$(find ./ -type f -name "*.yaml" -exec grep '$port' {} \;)
        if [ -z "$port_checking" ]; then
            if [ -z "$port_checkingv2" ]; then
                break
            fi
        fi
    done

}

function nginx_docker_name_random() {
    while :; do
        nginx_creat_name=$(openssl rand -hex 8)
        nginx_creat_name_check=$(find ./ -name "$db_creat")
        if [ -z "$nginx_creat_name_check" ]; then
            break
        fi
    done

}

nginx_port_checker
nginx_docker_name_random
cp -r core $nginx_creat_name
sed -i "s/8080/$port/g" $nginx_creat_name/docker-compose.yml
docker-compose -f $nginx_creat_name/docker-compose.yml up -d