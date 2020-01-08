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

## Dev env on macOS

#### 1\.

```
brew cask install osxfuse
brew install sassc npm tup
```

#### 2\. comment line with moon

in `Tuprules.tup`

```diff
--- a/Tuprules.tup
+++ b/Tuprules.tup
@@ -15,4 +15,4 @@ TOP = $(TUP_CWD)
 !pegjs = |> cat %f | $(TOP)/node_modules/.bin/pegjs --format amd  | sed -e 's/^define(/define("st\/%O", /' > %o  |>

 : foreach *.scss |> !scss |> %B.css
-: foreach *.moon |> moonc %f |> %B.lua
+# : foreach *.moon |> moonc %f |> %B.lua
```

and in `static/guides/Tupfile`

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
