#!/usr/bin/python
import argparse , shutil
from time import gmtime, strftime

# Sample script to start a continer with directories and tags arguments
# Execution example:
# python start_container.py -p 8183 -l /home/wruser/area_51/dev/idp/Labs/ -w /home/wruser/area_51/dev/idp/WindRiver_IDP203/ -i WindRiver_IDP203  -t v1


__author__ = 'WR'

DEFAULT_SYS_SETTINGS = "/home/wruser/area_51/dev/sys_settings"
DEFAULT_DEV_ENV = "/home/wruser/area_51/dev/idp"
READONLY_FLAG = ":ro"
 
parser = argparse.ArgumentParser(description='Run docker with input paramters.')
parser.add_argument('-p','--http_port', help='map host http port to default container http port (80)',required=True)
parser.add_argument('-l','--host_lab_dir',help='lab directory on host', required=True)
parser.add_argument('-w','--host_product_dir',help='installed product dir', required=True)
parser.add_argument('-i','--target_product_dir',help='installed product dir on target /home/wruser/<dir_name>', required=False , default="WindRiver")
parser.add_argument('-s','--default_settings_dir',help='Default host dir for conf files', required=False, default=DEFAULT_SYS_SETTINGS)
#parser.add_argument('-t','--instance_tag_name',help='instance tag ename', required=False, default=strftime("%Y-%m-%d_%H:%M:%S", gmtime()))
parser.add_argument('-t','--instance_tag_name',help='instance tag ename', required=False, default="")
parser.add_argument('-d','--docker_image_name',help='Docker image name', required=True)

args = parser.parse_args()
 
if args.instance_tag_name != "" :
	args.instance_tag_name = ":" + args.instance_tag_name

## show values ##
print ("http_port: %s" % args.http_port )
print ("host_lab_dir: %s" % args.host_lab_dir )
print ("host_product_dir: %s" % args.host_product_dir )
print ("default_settings_dir: %s" % args.default_settings_dir )

#To do
# Validate directory exists

#Copy Labs dir for this user
user_lab_dir = DEFAULT_DEV_ENV + '/' + args.http_port + "/Labs" 
shutil.copytree( args.host_lab_dir , user_lab_dir  , symlinks=True, ignore=None)

#copy Labs dir for this user

# Run container 
cmd = "docker run -p " + args.http_port + ":80 -v " + args.default_settings_dir + "/user.settings:/root/.c9/user.settings" + \
   " -v " +   user_lab_dir   + ":/home/wruser/Labs " +  " -v " + args.host_product_dir + ":/home/wruser/" +  args.target_product_dir + READONLY_FLAG +  " \
    -w /Labs -d " + args.docker_image_name +  args.instance_tag_name

print '-' *18
print cmd
print '-' *18
