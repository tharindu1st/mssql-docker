FROM ubuntu:16.04
ADD sqlservr.sh /
RUN apt-get update
RUN apt-get install -y curl libunwind8 libnuma1 libjemalloc1 libc++1 gdb libcurl3 openssl python python3 libgssapi-krb5-2 wget apt-transport-https locales
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | tee /etc/apt/sources.list.d/mssql-server.list
RUN apt-get update
RUN apt-get install -y mssql-server mssql-server-fts
# Default SQL Server TCP/Port.
EXPOSE 1433
CMD /sqlservr.sh