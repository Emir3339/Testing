#!/bin/bash

success=true

# Обновление пакетов и установка необходимых зависимостей для Docker
if ! sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common; then
    success=false
fi

# Добавление ключа Docker GPG
if ! curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -; then
    success=false
fi

# Добавление репозитория Docker
if ! sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"; then
    success=false
fi

# Обновление списка пакетов и установка Docker
if ! sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io; then
    success=false
fi

# Установка docker-compose
if ! sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose; then
    success=false
fi

# docker-compose
if ! sudo chmod +x /usr/local/bin/docker-compose; then
    success=false
fi

# Запуск сервиса Docker
if sudo systemctl start docker; then
    echo "Docker service started successfully."
    sudo systemctl status docker
else
    echo "Failed to start Docker service. Aborting."
    success=false
fi

# Если установка прошла успешно, запускаем docker-compose
if [ "$success" = true ]; then
    sudo docker-compose -f /home/test/destination/docker-compose.yaml up -d
    echo "Installation and setup complete."
else
    echo "Installation failed. Aborting."
fi
