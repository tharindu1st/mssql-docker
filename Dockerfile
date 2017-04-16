FROM ubuntu:16.04
ADD sqlservr.sh /
RUN apt-get update
RUN apt-get install -y curl libunwind8 libnuma1 libjemalloc1 libc++1 gdb libcurl3 openssl python python3 libgssapi-krb5-2 wget apt-transport-https locales
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | tee /etc/apt/sources.list.d/mssql-server.list
RUN apt-get update
RUN apt-get install -y mssql-server mssql-server-fts
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/msprod.list
RUN apt-get update
RUN ACCEPT_EULA=y DEBIAN_FRONTEND=noninteractive \
apt-get install -y --no-install-recommends mssql-tools unixodbc-dev
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
# Default SQL Server TCP/Port.
EXPOSE 1433
RUN locale-gen en_US.utf8 && update-locale
ADD entrypoint.sh /
CMD /entrypoint.sh