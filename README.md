# startResources 

##  Setup:
###### 1. Into your server console, command the following:

`aclrequest startResources allow all`
   
       Obs.: This will give the resource the required permission for resource starting. 

###### 2. Go to your mtaserver.conf file in the deathmatch directory.

###### 3. Configure the startup by adding the following line at the bottom of your document, right before the <b>\</config></b> tag. 
~~~xml
<resource src="startResources" startup="1" protected="0" />
~~~
## Use:
###### 1. Once the resource is loaded and succesfully running (don't forget to check the Debugscript), just command **/save** in your ingame chatbox or console and the magic will begin.
  ###### 1.1. You will be able to see the saving progress through the Debugscript, which shouldn't take very long, but depends on the amount of running resources you have.
###### 2. As soon as all your current resources are saved in the database, you can rely on the script for starting them whenever your server starts. 

## Caution: 
###### 1. To avoid any conflicts, it's recommended that you keep the resource name as startResources.
