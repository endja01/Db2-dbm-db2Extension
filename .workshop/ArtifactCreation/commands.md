# Create objects and content for exer

cd C:\Users\tm891807\projects\Db2DevOpsWorkshop\.workshop\ArtifactCreation

#  profiles

zowe profiles create zosmf-profile zDNT --host 10.210.139.84 --port 10443 --user micto01 --password micto01 --reject-unauthorized false --ow
zowe profiles create db2  DBBG -H 10.210.139.84  -P 5035 -d DALLASB -u micto01 --pw micto01 --ow
zowe profiles create db2  DBCG -H 10.210.139.84  -P 5040 -d DALLASC -u micto01 --pw micto01 --ow


# Create file used in exercise 1
zowe zos-files create data-set-sequential "DEVOPSWS.EXC1.DATA" --zosmf-profile zDNT --rf 'FB' --lrecl 80 --bs 0 --size '1TRK'
zowe zos-files upload ftds  "Exercise1GC.txt" "DEVOPSWS.EXC1.DATA" --zosmf-profile zDNT

# Drop user databases in  DBBG (TEST)
zowe  db2  execute  sql  --file  dropdb.sql  --db2-profile DBBG
zowe  db2  execute  sql  --file  exercise2.sql  --db2-profile DBCG


# Create "golden copy" database, tablespace, table in DBCG (production)
zowe  db2  execute  sql  -q  "DROP DATABASE  DEVOPSGC" --db2-profile  DBCG


zowe zos-files upload ftds  "TableGoldenCopy.sql" "MICTO01.SQL.DATA(CREATEGC)" --zosmf-profile zDNT
zowe dbm-db2 execute bp-script TableGoldenCopy.sql --restart new --td DBCG --ef execute-ddl.log --dbm-db2-profile micto01 --zosmf-profile zDNT

# Create verification database, tablespace, table in DBBG (development) and DBCG (production)

zowe  db2  execute  sql  -q  "DROP DATABASE  DEVOPSWS" --db2-profile  DBBG
zowe  db2  execute  sql  --file  Exercise1GC.ddl  --db2-profile DBBG
zowe  db2  execute  sql  --file  Exercise1GC.sql  --db2-profile DBBG

zowe  db2  execute  sql  -q  "DROP DATABASE  DEVOPSWS" --db2-profile  DBCG
zowe  db2  execute  sql  --file  Exercise1GC.ddl  --db2-profile DBCG
zowe  db2  execute  sql  --file  Exercise1GC.sql  --db2-profile DBCG


zowe  db2  execute  sql  -q  "DROP DATABASE  DEVOPSWS" --db2-profile  DBCG
zowe dbm-db2 execute bp-script Exercise1GC.ddl --restart new --td DBBG --ef execute-ddl.log --dbm-db2-profile micto01 --zosmf-profile zDNT
zowe dbm-db2 execute bp-script Exercise1GC.sql --restart new --td DBBG --ef execute-ddl.log --dbm-db2-profile micto01 --zosmf-profile zDNT

# Create "testcase database, tablespace, table in DBBG (Development)
zowe  db2  execute  sql  -q  "DROP DATABASE  DBIDUGTC" --db2-profile  DBBG
zowe dbm-db2 execute bp-script TestCaseDb.sql --restart new --td DBBG --ef execute-ddl.log --dbm-db2-profile micto01 --zosmf-profile zDNT
zowe  db2  execute  sql  --file  TestCaseDb.sql  --db2-profile DBBG
zowe  db2  execute  sql  -q  "SELECT * FROM DEVOPSWS.TEST_CASES_ORDERLINES" --db2-profile DBBG

# Create USERDB Grant DBADMIN to all users in DBBG 

zowe  db2  execute  sql  --file  create_db.sql  --db2-profile DBBG
zowe  db2  execute  sql  --file  grant_dbamin.sql  --db2-profile DBBG
zowe  db2  execute  sql  --file  grants.sql  --db2-profile DBBG
zowe  db2  execute  sql  --file  grants.sql  --db2-profile DBCG
zowe  db2  execute  sql  -q  "grant sysadm to  DEVOPADM" --db2-profile  DBBG
zowe  db2  execute  sql  -q  "grant sysadm to  DEVOPADM" --db2-profile  DBCG


# Manage test data

zowe  db2  execute  sql  -q  " SELECT * FROM DEVOPSWS.TEST_CASES_ORDERLINES" --db2-profile DBBG

zowe dbm-db2 unload data --sd DBBG -s "SELECT * FROM DEVOPSWS.TEST_CASES_ORDERLINES" --output-dataset "MICTO01.TEST.DATA" --output-control-file TestCaseData.ctl --dbm-db2-profile micto01 --zosmf-p zDNT

zowe dbm-db2 load data --td DBBG --replace yes --control-file TestCaseData.ctl --dataset 'DEVOPSWS.TESTCASE.DATA' --dbm-db2-profile micto01  --zosmf-p zDNT --error-file error.log

zowe zos-files download data-set "MICTO01.TEST.DATA" -b -f TestCaseData.unl --zosmf-profile zDNT
zowe zos-files create data-set-sequential "DEVOPSWS.TESTCASE.DATA" --rf 'FB' --lrecl 24 --bs 0 --size '1CYL' --zosmf-profile zDNT
zowe zos-files upload ftds  "TestCaseData.unl" "DEVOPSWS.TESTCASE.DATA" -b --zosmf-profile zDNT
zowe dbm-db2 load data --td DBBG --replace yes --control-file TestCaseData.ctl --dataset 'DEVOPSWS.TESTCASE.DATA' --dbm-db2-profile micto01  --zosmf-p zDNT


# TEMP
zowe  db2  execute  sql  -f  exercise2.sql --db2-profile DBCG
