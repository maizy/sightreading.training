# Pianistica

Fork of Sight Reading Trainer.

All kudos go to original
[sightreading.training](https://github.com/leafo/sightreading.training) written by [@leaf](https://github.com/leafo).


## Static version

https://maizy.github.io/pianistica/

## In this fork

Branch | Description
------ | -----------
[setup-fork](https://github.com/maizy/sightreading.training/pull/2/files) | Fork setup, fix file names for macOS
[iss4-serverless-build](https://github.com/maizy/sightreading.training/pull/7/files) | Serverless version: build docker container
[iss5-macos-dev-support](https://github.com/maizy/sightreading.training/pull/6/files) | Dev automation for serverless version, especially for macOS
[iss5-ios-support](https://github.com/maizy/sightreading.training/pull/8/files) | iOS + Web MIDI Browser support (written by [@MaienM](https://github.com/MaienM/sightreading.training))
[iss4-python-guides-converter](https://github.com/maizy/sightreading.training/pull/9/files) | Remove lua requirements for building statics, use python instead. Lightweight final docker image.
[disable-backend](https://github.com/maizy/sightreading.training/pull/13/files) | Disable lua files compiling
[iss11-notes-label](https://github.com/maizy/sightreading.training/pull/15) | Show notes label
[iss14-decrease-octave-num](https://github.com/maizy/sightreading.training/pull/16/files) | decrease octave number (ex: C5 -> C4). done with a very dirty hack.
[iss21-fork-rename](#todo) | fork renamed to Pianistica

## Serverless version

Version without lua backend. Only nginx serving statics.

#### Prebuild containers for releases

https://github.com/users/maizy/packages/container/package/pianistica

```
docker run -d --name=pianistica --restart=always \
    -p 8080:80 ghcr.io/maizy/pianistica:latest
```

#### Build

```
docker build -t pianistica:latest .
```

#### Run

```
docker run -p 127.0.0.1:8080:80 pianistica:latest
```

Server started at [http://127.0.0.1:8080/](http://127.0.0.1:8080/)

## Dev env on macOS

#### 1\.

```
brew install --cask osxfuse # restart may required
brew install sassc npm tup python rust
python -m pip install -r requirements.txt
```

#### 2\. init tup DB

```
tup init
```

#### 3\. update libs & generated files

```
npm install
tup
```

#### Extra: reinit tup generated files

```
rm -rf .tup/
./cleanup.sh
```

Then do 2nd & 3rd steps again.

## Run dev serverless version

#### 1\. Install docker-compose

#### 2\. Build all static

For macOS see instruction above.

#### 3\. Run

```
docker-compose -f dev-docker-compose.yml up
```

#### 4\. Go to

http://127.0.0.1:8080/

#### 4\. After any changes

Run tup for regenerating files

```
tup
```

or use `tup monitor` if you on linux.
