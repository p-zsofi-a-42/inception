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

COPY ./html/index.html /usr/share/nginx/html/index.html

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

# Run the application
CMD ["nginx", "-g", "daemon off;"]

# docker build -t testimage .
# docker run --name testname -p 8080:80 testimage
# docker exec -it testname sh
# docker stop testname && docker rm testname && docker rmi testimage

# docker build -t testimage . && docker run -d --name testname -p 8080:80 testimage

