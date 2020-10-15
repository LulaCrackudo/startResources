-- Save running resources/Auto-start mod
-- Developed by: Lula Crackudo © 2020

--------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE ENVIRONMENT
--------------------------------------------------------------------------------------------------------------------------------------------

function preStart ()
    if not fileExists("database.db") then  -- check if the 'database.db' file actually exists before doing anything
        local newFile = fileCreate("database.db")  -- if it doesn't, creates a new file named 'database.db'
        if newFile then
            outputDebugString("["..getResourceName(getThisResource()).."] Arquivo database.db criado com sucesso.")
            fileClose(newFile) 
        end
        local newDB = dbConnect( "sqlite", "database.db" ) -- connects to the new database
        if newDB then 
            outputDebugString("["..getResourceName(getThisResource()).."] Conexão com a nova database bem sucedida.")
        else 
            outputDebugString("["..getResourceName(getThisResource()).."] Erro conectando à nova database.")
        end
        local populate = dbExec(newDB, "CREATE TABLE `resources` (resourceName TEXT)") -- create the table in the new database
        if (newDB) and (populate) then
            outputDebugString("["..getResourceName(getThisResource()).."] Base de dados populada corretamente.")
            destroyElement(newDB)
        end   
    end
    database = dbConnect( "sqlite", "database.db" ) -- if a database already existed, it just connects and executes initResources
    initResources()
end

addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), preStart)

--------------------------------------------------------------------------------------------------------------------------------------------
--- START MODS
--------------------------------------------------------------------------------------------------------------------------------------------

function initResources()
    if not (hasObjectPermissionTo(getThisResource(), "function.startResource")) then  -- checks if the script has the permission needed for resource starting
        outputDebugString("Erro: o mod "..getResourceName(getThisResource()).." não tem as permissões necessárias para funcionar corretamente \nDigite no F8: aclrequest allow "..getResourceName(getThisResource()).." all", 1)
        return
    end
    if not database then
        outputDebugString("dbConnect["..getResourceName(getThisResource()).."]: falha ao estabelecer conexão com a base de dados.", 1)
    else
    local query = dbQuery(database, "SELECT * FROM `resources`") 
    local result = dbPoll(query, -1)
        for _, row in ipairs (result) do -- row represents the tables that are in 'result', which represent the rows
            for _, value in pairs (row) do 
                local resource = getResourceFromName(value) 
                if not (getResourceState(resource) == "running") then
                    startResource(resource)
                    outputDebugString("Iniciando resource "..value)
                end
            end
        end
    outputDebugString("["..getResourceName(getThisResource()).."]:Resources iniciados corretamente.")
    end
end

--------------------------------------------------------------------------------------------------------------------------------------------
--- SAVE MODS
--------------------------------------------------------------------------------------------------------------------------------------------

addCommandHandler("save", function ()
    local resources = getResources() -- get all loaded resources from the server
    dbExec(database, "DELETE FROM `resources`") -- clear the table in the database, to avoid resource duplication and debugscript spam;
    for _, resourceValue in ipairs (resources) do 
        local resourceName = getResourceName(resourceValue) 
        if (getResourceState(resourceValue) == "running")  -- get all the running resources
            if resourceName ~= getResourceName(getThisResource()) then
                dbExec(database, "INSERT INTO `resources` VALUES (?)", resourceName)  -- save the resource names in the database
                outputDebugString("Status do resource ["..resourceName.."] salvo!")
            end
        end  
    end 
    outputDebugString("Backup de resources feito com sucesso!")
end 
)

--------------------------------------------------------------------------------------------------------------------------------------------