## Overview

Runs getssl 
([https://github.com/srvrco/getssl/](https://github.com/srvrco/getssl)) to 
obtain SSL certificates for an Apache server.

Dockerfile for this image is available at 
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

You can get a default configuration file as output with the -c option. You will 
need to pay attention to the paths in the config files---the paths in the 
config files are paths inside the container, not the host system; other than 
that, it's straightforward.

You will have to reload Apache separately after running getssl.  No big deal if 
you are using a cron job or the like to run getssl periodically. 


## Notes

Why run getssl inside a container? Because I can! Actually, there are some 
security reasons. Best practice is to have the server certificate as readable 
only by root so that Apache can load it on start-up before switching uid to 
some non-privileged user. But this means that getssl needs to run with root 
privileges so it can modify the server certificates. Running getssl inside a 
container as root enables us to run getssl as root and yet severely 
restrict what it can do to the host system. In the above example, apart from 
the getssl configuration directory, getssl only sees DOCUMENT_ROOT/.well-known 
and the directory storing the ssl files. It cannot access any other host
files/directories.

