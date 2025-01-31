# Используем базовый образ Python
FROM python:3.10-slim

# Устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y iptables

# Копируем файл зависимостей в контейнер
COPY requirements.txt /app/requirements.txt

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r /app/requirements.txt

# Копируем приложение в контейнер
COPY app.py /app/app.py

# Устанавливаем рабочую директорию
WORKDIR /app

# Добавляем правила iptables для защиты от DoS атак и запускаем приложение
CMD ["sh", "-c", "iptables -A INPUT -p tcp --dport 5001 -m connlimit --connlimit-above 10 -j REJECT && \
    iptables -A INPUT -p tcp --dport 5001 -m state --state NEW -m recent --set && \
    iptables -A INPUT -p tcp --dport 5001 -m state --state NEW -m recent --update --seconds 60 --hitcount 20 -j REJECT && \
    python app.py"]