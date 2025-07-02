# Usando a imagem base específica que você solicitou.
FROM python:3.13.5-alpine3.21

# Define o diretório de trabalho no container
WORKDIR /app

# Copia o arquivo de dependências primeiro para aproveitar o cache do Docker
COPY requirements.txt .
 
# Instala as dependências em um ambiente virtual para melhor isolamento
# O --no-cache-dir reduz o tamanho da imagem
# Esta é a ÚNICA etapa de instalação de dependências necessária.
RUN python -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir -r requirements.txt


# Adiciona o ambiente virtual ao PATH do sistema.
# Isso garante que o comando 'uvicorn' use a versão instalada no venv.
ENV PATH="/opt/venv/bin:$PATH"


# Copia o restante do código da aplicação para o diretório de trabalho
COPY . .

# Expõe a porta em que a aplicação irá rodar
EXPOSE 8000

# Comando para iniciar a aplicação com Uvicorn
# O --reload foi removido, pois é para desenvolvimento, não para um container de produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]