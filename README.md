# VNC Docker image for use with Instruqt

Exposes port 9000

Usage:

 * Create a Dockerfile based on `gcr.io/instruqt/vnc`
 * Install whatever you need to run
 * Create a start.sh entrypoint (must be executable) that runs the program you
   you need to present to the user

Example:
```
FROM gcr.io/instruqt/vnc

RUN apt-get -y install firefox

ADD start.sh /start.sh
```

start.sh:
```
#!/bin/sh
firefox
```
