#!/bin/bash
mkdir -p /var/opt/mssql/log
MSSQL_DB=${MSSQL_DB:testdb1}
./sqlservr.sh > /var/opt/mssql/log/serverstart.log &

#waiting for mssql to start
export STATUS=0
i=0
while [[ $STATUS -eq 0 ]] || [[ $i -lt 30 ]]; do
	sleep 1
	i=$i+1
	STATUS=$(grep 'SQL Server is now ready for client connections' /var/opt/mssql/log/serverstart.log | wc -l)
done
echo =============== CREATING INIT DATA                ==========================

cd /opt/mssql/
cat <<-EOSQL > init.sql
CREATE DATABASE $MSSQL_DB;
GO
EOSQL

cd /opt/mssql-tools/bin/
./sqlcmd -S localhost -U sa -P $SA_PASSWORD -t 30 -i"/opt/mssql/init.sql" -o"/opt/mssql/initout.log"

echo =============== INIT DATA CREATED 				   ==========================
echo MSSQL SERVER SUCCESSFULLY STARTED

#trap
while [ "$END" == '' ]; do
			sleep 1
			trap "/opt/mssql/bin/sqlservr stop && END=1" INT TERM
done
