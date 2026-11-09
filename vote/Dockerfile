FROM python:3.14-alpine

WORKDIR /app

ARG WORKERS

RUN addgroup -S appgroup && adduser -S flaskuser -G appgroup

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=flaskuser:appgroup . .

USER flaskuser

EXPOSE 8080

CMD ["sh", "-c", "gunicorn -b 0.0.0.0:8080 --workers=$WORKERS app:app"]
