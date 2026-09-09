# Defining base image
FROM debian:bookworm

#
RUN apt update
RUN apt install nginx -y

# copy entire folder
#COPY ./nginx /etc/nginx/conf.d
# onl yif i built ngninx myself, but i didnt
# COPY nginx.conf /usr/local/nginx/conf/nginx.conf

# configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

COPY ./html/index.html /var/www/html/index.html
#: This folder is only used when building from nginx image
#COPY ./html/index.html /usr/share/nginx/html/index.html

RUN mkdir -p /etc/nginx/ssl
COPY ssl/zpalotas.key /etc/nginx/ssl/zpalotas.key
COPY ssl/zpalotas.crt /etc/nginx/ssl/zpalotas.crt

# Working directory inside container
#WORKDIR /app

#RUN mkdir testt
# Copy all the requirements
#COPY requirements.txt .

# Install dependencies
#RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the files
#COPY . .

# Documentation: listening port 
EXPOSE 80
EXPOSE 443

# Run the application
# no need bc nginx has deamon off
#CMD ["nginx", "-g", "daemon off;"]
CMD ["nginx"]

# docker build -t testimage .
# docker run --name testname -p 8080:80 testimage
# docker exec -it testname sh
# docker stop testname && docker rm testname && docker rmi testimage

# docker build -t testimage . && docker run -d --name testname -p 8080:80 testimage

