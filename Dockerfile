FROM python:3.8

WORKDIR /app
COPY requirements.txt .

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN pip3 install -r /app/requirements.txt

CMD ["/bin/sh", "-c", "while true; do echo hello world; sleep 1; done"]
