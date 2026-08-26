# ---------------------------------------------------------------------------------------------------
# This file contains all the commands needed to complete part 1 of the workshop
# ---------------------------------------------------------------------------------------------------

# Create profiles against SR02BRS

zowe profiles create zosmf brs --host sr02brs.lvn.broadcom.net --port 443 --user MICTO01 --password prague2 --rejectUnauthorized false --ow

zowe zos-jobs submit local-file exercise1.jcl --zosmf-profile sr02brs --wait-for-output

zowe profiles create db2 D10A -H sr02brs.lvn.broadcom.net -P 6033 -d D10APTIB -u MICTO01 --pw  prague2 --ow
zowe db2 execute sql -q "Select CURRENT SERVER from sysibm.sysdummy1;" --db2-p D10A

zowe profiles create db2 d10c -H sr02brs.lvn.broadcom.net -P 6017 -d D10CPTIB -u MICTO01 --pw  prague2 --ow


# Create dbm-db2 profile


zowe profiles delete dbm-db2 micto01
zowe profiles create dbm-db2 micto01
zowe profiles update dbm-db2 micto01 --jc "//IDUGWS0A  JOB (),'TOINE',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),\n//     REGION=0M,TIME=NOLIMIT"
zowe profiles update dbm-db2 micto01 --dl "{d10c: {lpar: 'BRS', ca_prefix: 'PRODUCT.DB2TOOLS.R20'}}"
zowe profiles update dbm-db2 micto01 --dl "{d10a: {lpar: 'BRS', ca_prefix: 'PRODUCT.DB2TOOLS.R20'}}"


zowe profiles update dbm-db2 micto01 --wdp "micto01.zowe.dbm"
zowe profiles update dbm-db2 micto01 -a "micto01"  -s "MICTO01" --cs DUMMY --cmc "MICTO01" --gmc "MICTO01"


zowe profiles update dbm-db2-profile micto01 --wdp 'MICTO01.PROD2.DDL' --a 'MICTO01' --s 'MICTO01' --dl '{''d10c'': {lpar: ''pe04'', ca_prefix: ''PRODUCT.DB2TOOLS.R20'' }, ''d10a'': {lpar: ''pe04'', ca_prefix: ''PRODUCT.DB2TOOLS.R20''}}'


zowe dbm-db2 unload data --sd D10A -s "SELECT * FROM SYSIBM.SYSDATABASE" --output-dataset "TM891807.TEST.DATA" --output-control-file test.ctl --dbm-db2-profile micto01 --zosmf-p brs

# TEST with customer id
# -------------------------------------------------------------------------------------------

cd ~/IdugWorkshop/01_GetConnected

zowe profiles create zosmf cust01brs --host sr02brs.lvn.broadcom.net --port 443 --user CUST001 --password CUST001 --rejectUnauthorized false --ow
zowe profiles create db2 cust01D10A -H sr02brs.lvn.broadcom.net -P 6033 -d D10APTIB -u CUST001 --pw  CUST001 --ow
zowe profiles create db2 cust01D10C -H sr02brs.lvn.broadcom.net -P 6017 -d D10CPTIB -u CUST001 --pw  CUST001 --ow

zowe zos-jobs submit local-file exercise1.jcl --zosmf-profile cust01brs --wait-for-output
zowe zos-files download data-set cust001.demouser.idugws.data -f exercise1.txt --zosmf-profile cust01brs

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

# 1. Get into the right directory.

cd ../03_CreateObjects

# 2. Create user database in development environment. Edit exercise3.ddl change DBIDUG.. to DBIDUG<user#>
#    Execute --help for plug in syntax.

zowe dbm-db2 execute ddl --help 

#    Execute the SQL input file to implement the Db2 object changes on the target Db2 subsystem. This command also 
#    generates a recovery script to undo compare script changes if needed using plug in ZOWE DBM-DB2 EXECUTE DDL.

zowe dbm-db2 execute ddl exercise3.ddl --td d10a --ef execddl-error.log --dbm-db2-profile cust001 --zosmf-profile brs001

# 3. Provision tablespace IDUGEX4 and table IDUGWS.ORDERLINES from the product copy into your personal database 
#    using plug in ZOWE DBM-DB2 GENERATE DDL. 

#    Execute --help for plug in syntax. 

zowe dbm-db2 generate ddl --help 

#    Execute plug in ZOWE DBM-DB2 GENERATE DDL.

zowe dbm-db2 generate ddl object3.txt --sd d10c --csf changeset3.txt --output-file gener3ddl.sql --error-file errors-generate.log --dbm-db2-profile cust001 --zosmf-profile brs001

#    Execute plug in ZOWE DBM-DB2 EXECUTE BP-SCRIPT to execute DDL on the target Db2 subsystem.

#    Execute --help for plug in syntax.

zowe dbm-db2 execute bp-script --help

#    Execute plug in ZOWE DBM-DB2 EXECUTE BP-SCRIPT.

zowe dbm-db2 execute bp-script gener3ddl.sql --td d10a --ef execute-ddl.log --r no --dbm-db2-profile cust001 --zosmf-profile brs001

# 4 Add Column -----------------------------------------

# ---------------------------------------------------------------------------------------------------
# This file contains all the commands needed to complete part 4 of the workshop 04_AddAColumn 
# ---------------------------------------------------------------------------------------------------
# 1. Get into the right directory.

cd ../04_AddAColumn

# 2. Update addcolumn4.sql add a new column to table ORDERLINES.

#    Execute command below to copy gener3ddl.sql to addcolumn4.sql.

cp ../03_CreateObjects/gener3ddl.sql ./addcolumn4.sql

# 3. See pdf for details to add column to table ORDERLINES.

# 4. Validate the syntax of input DDL and optionally verify Db2 object dependencies using plug in ZOWE DBM CHECK DDL.

#    Execute --help for plug in syntax.

zowe dbm-db2 check ddl --help 

#    Execute plug in ZOWE DBM CHECK DDL.

zowe dbm-db2 check ddl addcolumn4.sql --td d10a --ef check-errors.log --dbm-db2-profile cust001 --zosmf-profile brs001

# 5. Implement table IDUGnn.ORDERLINES change.

#    Execute --help for plug in syntax.

zowe dbm-db2 compare ddl --help 

zowe dbm-db2 execute compare --help

#   Compare objects that are defined in a DDL file with objects that are defined on a Db2 subsystem to generate a 
#   Batch Processor script that implements Db2 subsystem object changes. This command also generates an Incremental
#   Change Language (ICL) script that summarizes the changes using plug in ZOWE DBM COMPARE DDL.

zowe dbm-db2 compare ddl addcolumn4.sql --td d10a --ef compddl-error.log --cf compare-ddl --sf icl-file --dbm-db2-profile cust001 --zosmf-profile brs001

#   Execute the compare script to implement the Db2 object changes on the target Db2 subsystem. This command also 
#   generates a recovery script to undo compare script changes if needed using plug in ZOWE DBM EXECUTE 
#   COMPARE-SCRIPT.

zowe dbm-db2 execute compare compare-ddl --td d10a --ef execcomp-error.log --rf cust001.temp.ddl.cmpddl.rcvr --dbm-db2-profile cust001 --zosmf-profile brs001

# 05 Get Test Data  -----------------------------------------------------------------------

cd ../05_GetTestData

# 3. use the dbm-db2 plugin to load the generated test data into you copy of the database
zowe dbm-db2 unload data --sd D10A -s "SELECT USECASE_ID,ORDER,ORDER_LINE,AMOUNT FROM IDUGWS.TEST_CASES_ORDERLINES WHERE USECASE_ID = 'CUST001'" --output-dataset "CUST001.EXC5.DATA" --output-control-file Exercise5.ctl --error-file error.log --dbm-db2-profile cust001 --zosmf-p brs001

zowe dbm-db2 load data --td D10A --replace yes --control-file Exercise5.ctl --dataset 'CUST001.EXC5.DATA' --dbm-db2-profile cust001  --zosmf-p brs001 



