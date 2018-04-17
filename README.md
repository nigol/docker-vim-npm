# docker-vim-npm
Docker file for Node.js development.


## Build the Docker Image


```
$ docker build -t vim-npm .
```

## Running the Docker Container

After building, you can just pull the image and run it.

```
$ docker run -it --name=vim-npm \
             -p 8080:8080 \
             vim-npm:latest \
             /sbin/my_init -- su - docker
```
