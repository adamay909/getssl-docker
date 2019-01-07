## Overview

Runs getssl 
([https://github.com/srvrco/getssl/](https://github.com/srvrco/getssl)) to 
obtain SSL certificates for an Apache server.

A prebuilt image is on Docker Hub:

	docker pull adamaymas/getssl
	
Dockerfile is available at 
[https://github.com/adamay909/getssl-docker](https://github.com/adamay909/getssl-docker).

## Basic Usage

When you run

	docker run <options> adamaymas/getssl <getssl_options>

inside the container it will run

	getssl <getssl_options>

The default <getssl_option> is -h so if you just run the image without any 
options, it will display basic usage information for getssl. 

I do something like

	docker run \
		-v GETSSL_CONFIG_DIR:/getssl \
		-v DOCUMENT_ROOT/.well-known:/.well-known \
		-v APACHE_SSL_DIR:/ssl \
	  adamaymas/getssl \
		-w /getssl -a

You can get default configuration files as output with the -c option. E.g.:

	docker run -v /opt/getssl:/getssl adamaymas/getssl -c -w /getssl your.domain.com

This will create default config files for your.domain.com in the /opt/getssl (on host) directory. Make sure to edit it appropriately. In particular, you need to supply your account email for using let's encrypt. The files are fairly self-explanatory. You need to pay attention to the paths in the config files---the paths in the 
config files are paths inside the container, not the host system. Other than 
that, it's straightforward. You can get more information in the [getssl documentations](https://github.com/srvrco/getssl/wiki). 



You have to reload Apache separately after running getssl.  No big deal if 
you are using a cron job or the like to run getssl periodically. 


## Notes

Why run getssl inside a container? Because I can! Actually, there are some 
security reasons. Best practice is to have the server certificate as readable 
only by root. Apache can load it on start-up before switching uid to 
some non-privileged user. But this means that getssl needs to run with root 
privileges so it can modify the server certificates. Running getssl inside a 
container as root enables us to severely 
restrict what it can do to the host system. In the above example, apart from 
the getssl configuration directory, getssl only sees DOCUMENT_ROOT/.well-known 
and the directory storing the ssl files. It cannot access any other host
files/directories.

