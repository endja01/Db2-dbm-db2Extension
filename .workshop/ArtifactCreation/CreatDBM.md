# ---------------------------------------------------------------------------------------------------
# This file contains all the commands needed to complete part 2 of the workshop 02_CreateProfile
# ---------------------------------------------------------------------------------------------------

# 1. Get into the right directory.

cd /projects/IdugWorkshop/02_CreateProfile

# 2. Create a user DBM DB2 profile using your userid micto01, which lets you interact with Db2 using the 
#    Broadcom Database Management Solutions for Db2 for z/OS from the Zowe CLI interface. Values for 
#    the parameters can be found in the pdf. 


zowe profiles create dbm-db2-profile micto01

# 3. Update your user DBM DB2 profile to set default values for user micto01. 
#    Update JobCards set CUSTxx to your userid, z/OS JCL JOB statement cards that are separated using the newline 
#    (\n) characters.

zowe profiles update dbm-db2-profile micto01 --job-cards "//MICTO01A  JOB (),'DEVOPS WORKSHOP',CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1),\n//     REGION=0M,TIME=NOLIMIT"

# 4. Define the db2 subsystems and the LPARs that they run on. Very important is the prefix of the DB2 tools datasets.

zowe profiles update dbm-db2 micto01 --db2-list "{dbcg: {lpar: 'S0W1', ca_prefix: 'PTIPROD.RD200.TEST'}}"
zowe profiles update dbm-db2 micto01 --db2-list "{dbbg: {lpar: 'S0W1', ca_prefix: 'PTIPROD.RD200.TEST'}}"

# 5. Update check, compare, execute, generate options:
#    Change the CUSTxxx to you assigned mainframe userid.

 zowe profiles update dbm-db2-profile micto01 --co false --cs 'MICTO01' --cm 'DEVOPSWS' --cmc 'ENDJA08' --gm 'DEVOPSWS' --gmc 'ENDJA08' --a 'MICTO01' --s 'MICTO01'

# 6. Update check, compare, execute, generate Dataset prefix:
zowe profiles update dbm-db2-profile micto01 --wdp "micto01.dbmdb2.wds"