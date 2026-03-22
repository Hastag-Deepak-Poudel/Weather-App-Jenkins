# This is running from github webhook using smee client try 2

#STAGE 1 Build stage

FROM python:3.13 as backend-builder

#Set the working directory
WORKDIR /app

#Copy files from the source code directory to /app of docker image
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# STAGE 2 FINAL STAGE

# Using a slim python 3.13 to put it as base image
FROM python:3.13-slim

#Set the working directory to /app

# Copy the build dependencies from backend-builder stage
COPY --from=backend-builder /usr/local/lib/python3.13/site-packages/ /usr/local/lib/python3.13/site-packages/

# Copy the application code from the builder stage
COPY --from=backend-builder /app /app

EXPOSE 5000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]




#SUMMARY
# In the build stage, main image of python image is used to installed all the necessary requirements because other images like slim and alpine might have modules to install all the dependencency.
# /app as a working directory (usr/src/app is also used in industry), copying all the files and code from the local machine to /app of the docker image(machine). RUN pip install --no-cache-dir -r requirements.txt
# is used such that when we re build the image, installed modules can be cached for future.
# using python3.9 slim as base image. Setting the /app as working directory in image. COPY --from=backend-builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/ is where all the 
# installed modules are located and copying those modules from the backend-builder image to slim image such that we dont have to install the, again. 
# Copy --from=backend-builder /app /app, copying all the files from the 3.9 python image to 3.9-slim image.


