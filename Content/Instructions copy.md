# ---------------------------------------------------------------------------------------------------
# This file contains the commands needed to set up the VS Code DBM-Db2 extension. 
# ---------------------------------------------------------------------------------------------------

zowe config list
zowe config report-env
Team config files in effect:
        C:\Users\je605497\.aadevops_je605497\GADevOps\Db2-vscode\zowe.config.json
        C:\Users\je605497\.zowe\zowe.config.json



# 
# syntax check CLI first CLI executes syntax only, second CLI includes --verify to check dependencies
#
zowe dbm-db2 check ddl --help

zowe dbm-db2 check ddl Labcorp_create_stmt.sql --td d13e --ef check-errors.log

zowe dbm-db2 check ddl Labcorp_create_stmt.sql --td d13e --ef check-errors.log --verify yes

# 
# ========================================================================================================================= 
# Copy Objects (prepare migrate CLI) DDL and data exmaples end8d13a from dsn8d13a using a --cs (global change set defined in RCM)
#
zowe dbm-db2 prepare migration --object "database dbint01 include(children)" --odf provisionddl.sql --sd d13e --td d13e --oms migrate.script --ef mig.error 
#
#
zowe dbm-db2 prepare migration --object "database dbint06 include(children)" --odf dbdevddl.sql --oms dbdevmig.script --ef dbdevmig.error --sd d13e --td d13e -m R135
#
#
zowe dbm-db2 prepare migration --object "database dbint06 include(children)" --odf dbdevddlx.sql --oms dbdevmigx.script --ef dbdevmigx.error --sd d13e --td d13e 

#
zowe dbm-db2 prepare migration --object "database DSN8D13A include(tablespace, table, index)" --cs prod001.dsnmae --odf provision_maeja01_ddl.sql --sd d13e --td d13e --oms migrate_maeja01.script --ef mig.error

#
#    execute migration script
zowe dbm-db2 execute migration-script migrate.script --ef exMigrate.error

#
# ===========================================================================================================================
#    Generate DDL ( generate ddl CLI) generate DDL example can be used with a change set
#
zowe dbm-db2 generate ddl --object "table int006.orderlines" --odf int006ddl.sql --ef int006.generate.error --sd d13e --dbm-db2-profile a207.dbm-a207

zowe dbm-db2 generate ddl --object "database dbint06 include(children)"  --odf dbint06ddl.sql --ef dbint06.error --sd d13e

#    execute migration script
zowe dbm-db2 execute migration-script migrate.script --ef exMigrate.error


#
# ===========================================================================================================================

#
#   Deploy ( compare ddl CLI) execute compare analysis generate icl_file and impact analysis json 
#
zowe dbm-db2 compare ddl jaedeptddl.sql --td d13e --rs prod001.d13etbl --ocs compddl.script --ef compddl-error.log --osf icl-file --id prod001 -d maeja01_column_change


zowe dbm-db2 compare ddl Labxxx_create_stmt.sql --td d13e --rs prod001.d13etbl --ocs Labxxxddl.script --ef compddl-error.log --osf icl-file --id prod001 -d Labxxx_ddl_change

#    execute compare-script CLI
#
zowe dbm-db2 execute compare-script compddl.script --ef execcomp-error.log --output-recovery-file promote.cmpddl.rcvr

# Customer example 
#

zowe dbm-db2 execute compare-script Labxxxddl.script --ef execcomp-error.log --output-recovery-file promote.Labxxxpddl.rcvr


#    back out change
#
zowe dbm-db2 execute script promote.cmpddl.rcvr
   
zowe dbm-db2 execute script recovery_dbdev18_change.txt --td d13e --ef execscript-error.log


#
# Customer execute  drop stmts and grants
#

zowe dbm-db2 execute script Labxxx_drop.sql --td d13e