import os
import uuid

DEBUG = (os.environ.get("DATAPUSHER_DEBUG", "False") == "True")
TESTING = DEBUG
SECRET_KEY = os.environ.get("DATAPUSHER_SECRET_KEY", str(uuid.uuid4()))
USERNAME = os.environ.get("DATAPUSHER_USERNAME", str(uuid.uuid4()))
PASSWORD = os.environ.get("DATAPUSHER_PASSWORD", str(uuid.uuid4()))

NAME = 'datapusher'
SQLALCHEMY_DATABASE_URI = os.environ.get("DATAPUSHER_SQLALCHEMY_DATABASE_URI", 'sqlite:////tmp/job_store.db')
HOST = os.environ.get("DATAPUSHER_HOST", "0.0.0.0")
PORT = os.environ.get("DATAPUSHER_PORT", "8800")

# logging
FROM_EMAIL = os.environ.get("DATAPUSHER_FROM_EMAIL", 'server-error@example.com')
ADMINS = [os.environ.get("DATAPUSHER_ADMINS", 'yourname@example.com')]
LOG_FILE = os.environ.get("DATAPUSHER_LOG_FILE", '/tmp/ckan_service.log')
STDERR = True
