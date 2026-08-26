# ---------------------------------------------------------------------------------------------------
# This file contains the commands needed to set up the VS Code DBM-Db2 extension. 
# ---------------------------------------------------------------------------------------------------

# 1. Get into the right directory.

cd 01_GetConnected

# 2. A zowe.config.json has been created for your id MAINFRAME_USER to use during the DBM-Db2 extension workshop. This step will 
#    copy the zowe.config and zowe.schema to the working directory for the workshop.
#    

cp zoweProfile/zowe.config.json  /home/developer

cp zoweProfile/zowe.schema.json  /home/developer


# 3. Review zowe.config.json file. 

zowe config list 

# 4. Follow the instructions in the Db2DevOpsWorkshop.pdf to install the Zowe Explore extension in VS Code, then return to this
#    instructions.md


# 5. Execute the below command to install the DBM-Db2 extension, then follow the instructions in the Db2DevOpsWorkshop.pdf to 
#    complete the set up for the DBM-Db2 extension.

code --install-extension /home/developer/Db2Workshop/01_GetConnected/zoweProfile/dbm-db2-0.3.0.vsix