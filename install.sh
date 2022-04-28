#!/bin/bash
function docker_install() {
    docker_check=$(which docker)
    if [ -z "$docker_check" ]; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
    fi
}

function docker_compose_install() {
    docker_compose_check=$(which docker-compose)
    if [ -z "$docker_compose_check" ]; then
        # Install new version docker compose
        VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
        DESTINATION=/usr/local/bin/docker-compose
        sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
        sudo chmod 755 $DESTINATION
    fi
}

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
        nginx_creat_name_check=$(find ./ -name "$nginx_creat_name")
        if [ -z "$nginx_creat_name_check" ]; then
            break
        fi
    done

}
docker_install
docker_compose_install
nginx_port_checker
nginx_docker_name_random
cp -r core $nginx_creat_name
sed -i "s/8080/$port/g" $nginx_creat_name/docker-compose.yml
docker-compose -f $nginx_creat_name/docker-compose.yml up -d
ip_domain=$(hostname -I | awk '{ print $1 }')

printf "==========================================================================\n"
printf "                    Install complete nginx php-fpm on docker              \n"
printf "==========================================================================\n"
printf "             Please save infomation, you can upload code to Webroot        \n"
printf "         Webroot Document:                  $(pwd)/$nginx_creat_name/html          \n"
printf "                 Website:                   $ip_domain:$port           \n"
printf "            Config Nginx:                  $(pwd)/$nginx_creat_name/default.conf   \n"
print  "     Docker Compose File:                  $nginx_creat_name/docker-compose.yml  \n"
printf "==========================================================================\n"