FROM python:3.7-alpine

EXPOSE 8080

RUN apk update && \
    apk add --virtual build-deps gcc python3-dev musl-dev && \
    apk add --no-cache mariadb-dev

COPY api/users.py /app/
COPY requirements.txt /app

RUN pip install --upgrade pip && \
    pip install -r /app/requirements.txt && \
    apk del build-deps

WORKDIR /app

CMD [ "python", "users.py" ]