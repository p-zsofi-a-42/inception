# Defining base image
FROM alpine:3.23

#
RUN apk update
RUN apk add nginx

COPY nginx.conf /etc/nginx/nginx.conf
#COPY nginx.conf /usr/local/nginx/conf/nginx.conf
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

