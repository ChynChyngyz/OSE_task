#!/bin/bash

LOG_FILE="/var/log/deploy.log"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

set -e

PYTHON_VERSION=$(python3 --version | awk '{print $2}' | cut -d '.' -f1,2)
MIN_PYTHON_VERSION="3.12"

if [[ "$(echo -e "$MIN_PYTHON_VERSION\n$PYTHON_VERSION" | sort -V | head -n1)" != "$MIN_PYTHON_VERSION" ]]; then
    log_message "Ошибка: Требуется Python версии $MIN_PYTHON_VERSION или выше. Установлена версия $PYTHON_VERSION."    exit 1
fi

while getopts "r:d:s:" opt; do
    case $opt in
        r) REPO_URL=$OPTARG ;;
        d) APP_DIR=$OPTARG ;;
        s) SERVER_NAME=$OPTARG ;;
        *) echo "Использование: $0 -r <репозиторий> -d <путь к приложению> -s <сервер>" ;;
    esac
done

REPO_URL=${REPO_URL:-""}
APP_DIR=${APP_DIR:-"/mnt/c/Users/Victus/Desktop/OSE/OSEExam/testPrj"}
SERVER_NAME=${SERVER_NAME:-"localhost"}
VIRTUALENV_DIR="$APP_DIR/venv"

log_message "Обновление системы и установка зависимостей..."
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install -y python3-pip python3-dev libpq-dev git curl
log_message "Клонирование репозитория..."

if [ ! -d "$APP_DIR" ]; then
  sudo git clone $REPO_URL $APP_DIR || { log_message "Ошибка при клонировании репозитория"; exit 1; }
else
  log_message "Каталог приложения уже существует. Пропускаем клонирование."
fi

cd $APP_DIR

log_message "Проверка и установка пакета python3-venv..."
if ! dpkg -l | grep -q python3-venv; then
    sudo apt-get install -y python3-venv || { log_message "Ошибка при установке python3-venv"; exit 1; }
fi

log_message "Создание виртуального окружения..."
if [ ! -d "$VIRTUALENV_DIR" ]; then
  sudo python3 -m venv $VIRTUALENV_DIR || { log_message "Ошибка при создании виртуального окружения"; exit 1; }
fi

log_message "Проверка содержимого виртуального окружения..."
ls -l $VIRTUALENV_DIR

source $VIRTUALENV_DIR/bin/activate
log_message "Установка зависимостей из requirements.txt..."

log_message "Проверка и установка зависимостей из requirements.txt..."
cd testPrj
if [ -f "requirements.txt" ]; then
  pip install -r requirements.txt || { log_message "Ошибка при установке зависимостей"; exit 1; }
else
  log_message "Файл requirements.txt не найден."
fi

log_message "Проверка и установка whitenoise..."
if ! pip show whitenoise > /dev/null; then
  pip install whitenoise || { log_message "Ошибка при установке whitenoise"; exit 1; }
fi

log_message "Запуск Django-приложения на локальном сервере..."
python manage.py runserver 127.0.0.1:8000 || { log_message "Ошибка при запуске Django-сервера"; exit 1; }

log_message "Django-приложение успешно развернуто и доступно по адресу http://$SERVER_NAME:8000"
