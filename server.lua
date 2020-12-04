-- Save running resources/Auto-start mod
-- Developed by: Lula Crackudo © 2020

--------------------------------------------------------------------------------------------------------------------------------------------
-- CREATE ENVIRONMENT
--------------------------------------------------------------------------------------------------------------------------------------------

function preStart ()
    database = dbConnect( "sqlite", "database.db"  )
    if database then 
        local exec = dbExec(database, "CREATE TABLE IF NOT EXISTS `resources` (resourceName TEXT)")
        if not exec then
            error("dbConnect["..getResourceName(getThisResource()).."] Ocorreu um erro.")
            return
        end
        print("dbConnect["..getResourceName(getThisResource()).."] Database conectada corretamente.")
        initResources()
    end 
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


--------------------------------------------------------------------------------------------------------------------------------------------
--- SAVE MODS
--------------------------------------------------------------------------------------------------------------------------------------------

addCommandHandler("save", function ()
    _call(saveMods)
end) 

function saveMods ()
    local resources = getResources() -- get all loaded resources from the server
    dbExec(database, "DELETE FROM `resources`") -- clear the table in the database, to avoid resource duplication and debugscript spam;
    for _, resourceValue in ipairs (resources) do 
        local resourceName = getResourceName(resourceValue) 
        if (getResourceState(resourceValue) == "running") then -- get all the running resources
            if resourceName ~= getResourceName(getThisResource()) then
                dbExec(database, "INSERT INTO `resources` VALUES (?)", resourceName)  -- save the resource names in the database
                print("Status do resource ["..resourceName.."] salvo!")
            end
        end 
        sleep(200)
    end 
    print("Backup de resources feito com sucesso!")
end 


--------------------------------------------------------------------------------------------------------------------------------------------

function _call(_called, ...)
	local co = coroutine.create(_called);
	coroutine.resume(co, ...);
end

function sleep(time)
	local co = coroutine.running();
	local function resumeThisCoroutine()
		coroutine.resume(co);
	end
	setTimer(resumeThisCoroutine, time, 1);
	coroutine.yield();
end