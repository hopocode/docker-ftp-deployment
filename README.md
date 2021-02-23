# docker-ftp-deployment

Docker image wrap ftp-deployment from David Grudl wrap to docker image

Copy file deploy.sh to your project directory to dir deployment

Take config file from ftp-deployment

```sh
wget https://raw.githubusercontent.com/dg/ftp-deployment/v3.3.0/deployment.sample.ini
cp deployment.sample.ini deployment.ini
```

Setup configuration in `deployment.ini` file

Run deployment process

```sh
sh deployment/deploy.sh ./deployment.ini
```

Development

```
docker build -t hopocode/ftp-deployment:x.x.x
docker login
docker push hopocode/ftp-deployment:x.x.x
```
