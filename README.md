# Fork of Sight Reading Trainer

All kudos go to original
[sightreading.training](https://github.com/leafo/sightreading.training) authored by [@leaf](https://github.com/leafo).

## In this fork

Branch | Description
------ | -----------
[setup-fork](https://github.com/maizy/sightreading.training/tree/setup-fork) | Fork setup, fix file names for macOS
[iss4-serverless-build](https://github.com/maizy/sightreading.training/tree/iss4-serverless-build) | Serverless version: build docker container

## Serverless version

Version without lua backend. Only nginx serving statics.

Build

```
docker build -t st-serverless:latest -f serverless.dockerfile .
```

Run

```
docker run -p 8080:80 st-serverless:latest
```

Server started at [http://127.0.0.1:8080/](http://127.0.0.1:8080/)
