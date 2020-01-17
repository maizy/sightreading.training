# Fork of Sight Reading Trainer

All kudos go to original
[sightreading.training](https://github.com/leafo/sightreading.training) authored by [@leaf](https://github.com/leafo).

## In this fork

Branch | Description
------ | -----------
[setup-fork](https://github.com/maizy/sightreading.training/pull/2/files) | Fork setup, fix file names for macOS
[iss4-serverless-build](https://github.com/maizy/sightreading.training/pull/7/files) | Serverless version: build docker container
[iss5-macos-dev-support](https://github.com/maizy/sightreading.training/pull/6/files) | Dev automation for serverless version, especially for macOS
[iss5-ios-support](https://github.com/maizy/sightreading.training/pull/8/files) | iOS + Web MIDI Browser support (authored by [@MaienM](https://github.com/MaienM/sightreading.training))
[iss4-python-guides-converter](https://github.com/maizy/sightreading.training/pull/9/files) | Remove lua requirements for building statics, use python instead. Lightweight final docker image.
[disable-backend](https://github.com/maizy/sightreading.training/pull/13/files) | Disable lua files compiling

## Serverless version

Version without lua backend. Only nginx serving statics.

Build

```
docker build -t st-serverless:latest -f serverless.dockerfile .
```

Run

```
docker run -p 127.0.0.1:8080:80 st-serverless:latest
```

Server started at [http://127.0.0.1:8080/](http://127.0.0.1:8080/)

## Dev env on macOS

#### 1\.

```
brew cask install osxfuse  # restart may required
brew install sassc npm tup python
python -m pip install -r requirements.txt
```

#### 2\. comment line with moon

in `static/guides/Tupfile`

```diff
--- a/static/guides/Tupfile
+++ b/static/guides/Tupfile
@@ -1,3 +1,3 @@
 .gitignore

-: foreach *.md |> moon convert_to_json.moon %f > %o |> %B.json
+#: foreach *.md |> moon convert_to_json.moon %f > %o |> %B.json
```


#### 3\. init tup DB

```
tup init
```

#### 4\. update generated files

```
tup
```

#### Extra: reinit tup generated files

```
rm -rf .tup/
./cleanup.sh
```

Then do 3rd & 4th steps again.

## Run dev serverless version

#### 1\. Install docker-compose

#### 2\. Build all static

For macOS see instruction above.

#### 3\. Run

```
docker-compose -f dev-docker-compose.yml up
```

#### 4\. After any changes

Run tup for regenerating files

```
tup
```

or use `tup monitor` if you on linux.
