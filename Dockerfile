FROM debian:bullseye-slim
 
# Устанавливаем рабочую директорию
WORKDIR /app_fuzzing
 
# Копируем все файлы в рабочую директорию
COPY . .
 
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    wget \
    build-essential \
    coreutils \
    findutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
    
RUN wget https://golang.org/dl/go1.17.11.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.17.11.linux-amd64.tar.gz && \
    rm go1.17.11.linux-amd64.tar.gz
 
ENV PATH="/usr/local/go/bin:${PATH}"
 
# Устанавливаем FFUF
RUN git clone https://github.com/ffuf/ffuf && cd ffuf && go build
# Проверка наличия команды ls
RUN which ls && ls --version
# Запускаем приложение
CMD ["flask", "run", "--host=0.0.0.0", "--port=5001"]