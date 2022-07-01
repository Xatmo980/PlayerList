local data = {}
local ViewPlayerGuiId = 44332205
local PlayerLimit = 15 -- set to how many players to allowed to be displayed
local Rank = 2 -- Rank allowed to use the /playerlist command
local getFiles = function(directory)

    local i, t, popen = 0, {}, io.popen
    local pfile = nil

    pfile = popen('dir "' .. directory .. '" /b')

    for filename in pfile:lines() do
        i = i + 1
	t[i] = filename
    end
	pfile:close()

   return t
end

local getPlayerFilesData = function(directory)
      local directory = tes3mp.GetDataPath() .. "/TopList/"
      local Files = getFiles(directory)
      local Playerlist = ""
      local list = ""
      local sort = {}
      local R = 0
      data = {}

      for _,fileName in pairs(Files) do
          local NoFileExtension = fileName:split(".")
          local fileName = NoFileExtension[1]
          local YouShallNotPass = NoFileExtension[2]

      if (YouShallNotPass ~= "json") then
         -- tes3mp.LogMessage(3, "Gandalf: You Shall Not Pass!!!")
      else
         data = jsonInterface.load("TopList/" .. fileName .. ".json")
         local cHP = math.floor(data[fileName].healthCurrent)
         local bHP = math.floor(data[fileName].healthBase)
         local Cell = data[fileName].cell
         for k,v in pairs(data) do
             table.insert(sort, {Name = k, level = v.level, Progress = v.levelProgress, HP = cHP .. "/" .. bHP, Location = Cell})
         end
   end
 end
for k, v in pairs(sort) do
           table.sort(sort, function(a,b) return a.level>b.level end)
end
   for i=1,#sort do
       if R >= PlayerLimit then
          break
       end
       list = list .. "[" .. sort[i].Name .. "] - (" .. sort[i].Location .. ")" .. "\n" .. "     Level " .. sort[i].level .. " Progress " .. sort[i].Progress .. " HP " .. sort[i].HP.."\n"
       R = R + 1
   end
 return list
end

local viewPlayerMenu = function(pid)
      local header = color.DarkOrange.."Player Information"
            if getPlayerFilesData() == nil then
               tes3mp.ListBox(pid, ViewPlayerGuiId, header, "Error No Values")
            else
	       tes3mp.ListBox(pid, ViewPlayerGuiId, header, getPlayerFilesData())
        end
end

customEventHooks.registerHandler("OnGUIAction", function(eventStatus, pid, idGui, data)
      local isValid = eventStatus.validDefaultHandler
	    if isValid ~= false then
	       if idGui == ViewPlayerGuiId then
		  isValid = false
		  return
	       end
	   end
	eventStatus.validDefaultHandler = isValid
    return eventStatus
end)

viewPlayers = function(pid, cmd)
    if Players[pid]:IsLoggedIn() then
       if Players[pid].data.settings.staffRank >= Rank then
	  viewPlayerMenu(pid)
       else
	  tes3mp.SendMessage(pid, color.Error.."You do not have access to that command.\n")
       end
    end
end

customCommandHooks.registerCommand("playerlist", viewPlayers)
