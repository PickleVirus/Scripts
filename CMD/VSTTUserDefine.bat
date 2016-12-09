net stop VSTTAgent
sc config "VSTTAgent" obj= "dixy\backup" password= "#Backup%%"
net start VSTTAgent