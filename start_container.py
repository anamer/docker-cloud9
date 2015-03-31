#!/usr/bin/python
import argparse
__author__ = 'WR'

DEFAULT_SYS_SETTINGS = "/home/wruser/docker/settings"
 
parser = argparse.ArgumentParser(description='Run docker with input paramters.')
parser.add_argument('-p','--http_port', help='map host http port to default container http port (80)',required=True)
parser.add_argument('-l','--lab_dir',help='lab directory on host', required=True)
parser.add_argument('-w','--product_dir',help='installed product dir', required=True)
parser.add_argument('-d','--default_settings_dir',help='Default host dir for conf files', required=False, default=DEFAULT_SYS_SETTINGS)

args = parser.parse_args()
 
## show values ##
print ("http_port: %s" % args.http_port )
print ("lab_dir: %s" % args.lab_dir )
print ("default_settings_dir: %s" % args.default_settings_dir )

#To do
# Validate directory exists

# Run container 
cmd = "docker run -p " + args.http_port + ":80 -v " + args.default_settings_dir +"/user.settings:/root/.c9/user.settings -v " + args.lab_dir + ":/Labs -w /Labs -d cloud9"

