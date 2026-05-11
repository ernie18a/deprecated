docker run -d --name registry -v /REGISTRY:/var/lib/registry -p 5000:5000 --restart on-failure registry
