#!/bin/bash

success=true

# Установка docker-compose с использованием sudo
if ! sudo apt install docker-compose -y; then
    success=false
fi

# Запуск сервиса Docker с использованием sudo
if sudo systemctl start docker; then
    echo "Service started successfully."
    sudo systemctl status docker
else
    echo "Failed to start service. Aborting."
fi

# Если установка прошла успешно, запускаем docker-compose
if [ "$success" = true ]; then
    sudo docker-compose -f /home/test/destination/docker-compose.yaml up -d
    echo "Installation complete."
else
    echo "Installation failed. Aborting."
fi
