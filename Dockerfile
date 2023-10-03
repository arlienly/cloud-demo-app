# FROM python:3.9

# # set environment variables
# ENV PYTHONDONTWRITEBYTECODE 1
# ENV PYTHONUNBUFFERED 1

# COPY requirements.txt .
# # install python dependencies
# RUN pip install --upgrade pip
# RUN pip install --no-cache-dir -r requirements.txt

# COPY . .

# # running migrations
# RUN python manage.py migrate

# # gunicorn
# CMD ["gunicorn", "--config", "gunicorn-cfg.py", "core.wsgi"]

# Use an official Python runtime as a parent image
FROM python:3.11

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Copy the dependencies file to the working directory
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app/
COPY . /app/

# Collect static files
RUN python manage.py collectstatic --noinput
# RUN echo "y" | python manage.py search_index --rebuild
# Expose the port that Django runs on
EXPOSE 80

# Define the command to run your application
CMD ["gunicorn", "--bind", "0.0.0.0:80", "core.wsgi:application"]
