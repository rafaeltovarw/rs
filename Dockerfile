FROM ubuntu:16.04
										 
COPY . /root/

RUN sh /root/opensh-node.sh

WORKDIR /root

EXPOSE 8080

CMD ["bash"]
