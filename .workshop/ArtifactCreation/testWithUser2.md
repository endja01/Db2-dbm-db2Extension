# ---------------------------------------------------------------------------------------------------
# This file contains all the commands needed to complete part 1 of the workshop
# ---------------------------------------------------------------------------------------------------
cd /projects/IdugWorkshop/01_GetConnected

# Create profiles against S01W

zowe profiles create zosmf BRS --host 34.66.39.193 --port 443 --user MICTO01 --password prague2 --rejectUnauthorized false --ow

zowe zos-jobs submit local-file exercise1.jcl --zosmf-profile BRS --wait-for-output

zowe profiles create db2 D10A -H 34.66.39.193 -P 6033 -d D10APTIB -u MICTO01 --pw prague2 --ow
zowe db2 execute sql -q "Select CURRENT SERVER from sysibm.sysdummy1;" --db2-p D10A

zowe profiles create db2 D10C -H 34.66.39.193 -P 6017 -d D10CPTIB -u MICTO01 --pw  prague2 --ow
zowe db2 execute sql -q "Select CURRENT SERVER from sysibm.sysdummy1;" --db2-p D10C

# Create dbm-db2 profile


zowe profiles delete dbm-db2 MICTO01 
zowe profiles create dbm-db2 MICTO01
zowe profiles update dbm-db2 MICTO01 --jc "//MICTO01A  JOB (),'TOINE',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),\n//     REGION=0M,TIME=NOLIMIT"
zowe profiles update dbm-db2 MICTO01 --dl "{d10c: {lpar: 'BRS', ca_prefix: 'PRODUCT.DB2TOOLS.R20'}}"
zowe profiles update dbm-db2 MICTO01 --dl "{d10a: {lpar: 'BRS', ca_prefix: 'PRODUCT.DB2TOOLS.R20'}}"


zowe profiles update dbm-db2 MICTO01 --wdp "MICTO01.zowe.dbm"
zowe profiles update dbm-db2 MICTO01 -a "MICTO01"  -s "MICTO01" --cs DUMMY --cmc "MICTO01" --gmc "MICTO01"


zowe profiles update dbm-db2-profile MICTO01 --wdp 'MICTO01.PROD2.DDL' --a 'MICTO01' --s 'MICTO01' --dl '{''d10c'': {lpar: ''pe04'', ca_prefix: ''PRODUCT.DB2TOOLS.R20'' }, ''d10a'': {lpar: ''pe04'', ca_prefix: ''PRODUCT.DB2TOOLS.R20''}}'


zowe dbm-db2 unload data --sd D10A -s "SELECT * FROM SYSIBM.SYSDATABASE" --output-dataset "TM891807.TEST.DATA" --output-control-file test.ctl --dbm-db2-profile MICTO01 --zosmf-p BRS

# TEST with customer id
# -------------------------------------------------------------------------------------------

cd /projects/IdugWorkshop/01_GetConnected

zowe profiles create zosmf cust01BRS --host sr02BRS.lvn.broadcom.net --port 443 --user CUST001 --password CUST001 --rejectUnauthorized false --ow
zowe profiles create db2 cust01D10A -H sr02BRS.lvn.broadcom.net -P 6033 -d D10APTIB -u CUST001 --pw  CUST001 --ow
zowe profiles create db2 cust01D10C -H sr02BRS.lvn.broadcom.net -P 6017 -d D10CPTIB -u CUST001 --pw  CUST001 --ow

zowe zos-jobs submit local-file exercise1.jcl --zosmf-profile cust01BRS --wait-for-output
zowe zos-files download data-set cust001.demouser.idugws.data -f exercise1.txt --zosmf-profile cust01BRS

zowe  db2  execute  sql  --file  exercise2.sql --db2-profile  cust01D10A
zowe  db2  execute  sql  --file  exercise2.sql --db2-profile  cust01D10C

# Create dbm-db2 profile


zowe profiles delete dbm-db2 cust001
zowe profiles create dbm-db2 cust001
zowe profiles update dbm-db2-profile cust001 --wdp 'CUST001.PROD2.DDL' --a 'cust001' --s 'cust001' 
zowe profiles update dbm-db2 cust001 --jc "//CUST001A  JOB (),'IDUGWS USER',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),\n//     REGION=0M,TIME=NOLIMIT"

zowe profiles update dbm-db2 cust001 --dl "{d10c: {lpar: 'BRS', ca_prefix: 'PRODUCT.DB2TOOLS.R20'}}"
zowe profiles update dbm-db2 cust001 --dl "{d10a: {lpar: 'BRS', ca_prefix: 'PRODUCT.DB2TOOLS.R20'}}"
zowe profiles update dbm-db2-profile cust001 --co false --cs 'cust001' --cm 'IDUGWS' --cmc 'ENDJA01' --gm 'IDUGWS' --gmc 'ENDJA01'

# 3 Create Objects -----------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------
# This file contains all the commands needed to complete part 3 of the workshop 03_CreateObjects
# ---------------------------------------------------------------------------------------------------

cd /projects/IdugWorkshop/03_CreateObjects

zowe dbm-db2 execute ddl --help 

zowe dbm-db2 execute ddl exercise3.ddl --td d10a --ef execddl-error.log --dbm-db2-profile CUST??? --zosmf-profile BRS

zowe  db2  execute  sql  --file  exercise3a.sql --db2-profile  D10A

zowe dbm-db2 generate ddl --help 

zowe dbm-db2 generate ddl object3.txt --sd d10c --csf changeset3.txt --output-file gener3ddl.sql --error-file errors-generate.log --dbm-db2-profile CUST??? --zosmf-profile BRS

zowe dbm-db2 execute bp-script --help

zowe dbm-db2 execute bp-script gener3ddl.sql --td d10a --ef execute-ddl.log --r no --dbm-db2-profile CUST??? --zosmf-profile BRS

zowe  db2  execute  sql  --file  exercise3b.sql --db2-profile  D10A

# 4 Add Column -----------------------------------------
# ---------------------------------------------------------------------------------------------------
# This file contains all the commands needed to complete part 4 of the workshop 04_AddAColumn 
# ---------------------------------------------------------------------------------------------------

cd /projects/IdugWorkshop/04_AddAColumn

cp ../03_CreateObjects/gener3ddl.sql ./addcolumn4.sql

zowe dbm-db2 check ddl --help 

zowe dbm-db2 check ddl addcolumn4.sql --td d10a --ef check-errors.log --dbm-db2-profile CUST??? --zosmf-profile BRS

zowe dbm-db2 compare ddl --help 

zowe dbm-db2 execute compare --help

zowe dbm-db2 compare ddl addcolumn4.sql --td d10a --ef compddl-error.log --cf compare-ddl --sf icl-file --dbm-db2-profile CUST??? --zosmf-profile BRS

zowe dbm-db2 execute compare compare-ddl --td d10a --ef execcomp-error.log --rf cust???.temp.ddl.cmpddl.rcvr --dbm-db2-profile CUST??? --zosmf-profile BRS

zowe  db2  execute  sql  --file  exercise4.sql --db2-profile  D10A

# 05 Get Test Data  -----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------
# This file contains all the commands needed to complete part 5 of the workshop 05_GetTestData
# ---------------------------------------------------------------------------------------------------

cd /projects/IdugWorkshop/05_GetTestData
 
zowe dbm-db2 unload data --sd D10A -s "SELECT ORDER,ORDER_LINE,AMOUNT FROM IDUGWS.TEST_CASES_ORDERLINES WHERE USECASE_ID = 'CUST???'" --odf CSV --output-dataset "CUST???.EXC5.DATA" --output-control-file Exercise5.ctl --error-file error.log --dbm-db2-profile  CUST??? --zosmf-p BRS

zowe dbm-db2 load data --td D10A --replace yes --control-file Exercise5.ctl --dataset 'CUST???.EXC5.DATA' --dbm-db2-profile CUST??? --table CUST???.ORDERLINES --error-file error.log --zosmf-p BRS 

zowe  db2  execute  sql  --file  exercise5.sql --db2-profile  D10A
