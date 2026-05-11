```conf
http {
 server {
   listen 80;
   listen [::]:80;
   location / {
       proxy_pass http://172.18.0.5:30001;
   }
 }
```
