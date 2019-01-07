
FROM alpine:3.8

RUN 	apk --no-cache add \
		bash \
		libressl \
		curl &&\
	curl --silent https://raw.githubusercontent.com/srvrco/getssl/master/getssl > /usr/local/bin/getssl &&\
	chmod 700 /usr/local/bin/getssl &&\
	mkdir /getssl
	
ENTRYPOINT [ "/usr/local/bin/getssl" ]

CMD [ "-h" ]



LABEL maintainer="Masahiro Yamada <adamay909@gmail.com>"
	
