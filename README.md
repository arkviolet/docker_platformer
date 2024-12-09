# docker

## docker-build

```bash
sudo docker build -t kviolet:latest .
```
## docker user
```bash
sudo usermod -aG docker $USER
newgrp docker
```

## docker-run

```bash
docker-compose -f kviolet.yaml run --rm dev
```
