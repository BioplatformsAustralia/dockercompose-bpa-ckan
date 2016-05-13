#
import os

# 
#for key in os.environ:
#    print "{0}:{1}".format(key, os.environ[key])

from paste.deploy import loadapp
config_filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'ckan.ini')

from paste.script.util.logging_config import fileConfig
fileConfig(config_filepath)

application = loadapp('config:%s' % config_filepath)
