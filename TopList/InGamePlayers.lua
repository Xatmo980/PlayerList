local data = {}
local ViewPlayerGuiId = 44332205
local Rank = 2
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
      data = {}

      for _,fileName in pairs(Files) do
          local NoFileExtension = fileName:split(".")
          local fileName = NoFileExtension[1]
          local YouShallNotPass = NoFileExtension[2]

      if (YouShallNotPass ~= "json") then
         -- tes3mp.LogMessage(3, "Gandalf: You Shall Not Pass!!!")
      else
         data = jsonInterface.load("TopList/" .. fileName .. ".json")
         LvL = (data[fileName].level)
         Progress = (data[fileName].levelProgress)
         cHP = math.floor(data[fileName].healthCurrent)
         bHP = math.floor(data[fileName].healthBase)
         Race = (data[fileName].race)
         Cell = (data[fileName].cell)
         Playerlist = Playerlist .. "[" .. fileName .. "]" .. " Level " .. LvL .. " Progress " .. Progress .. " HP " .. cHP .. "/" .. bHP .. "\n"
   end
 end
 return Playerlist
end

local viewPlayerMenu = function(pid)
      local header = color.DarkOrange.."Player Information"
            if getPlayerFilesData() == nil then
               tes3mp.ListBox(pid, ViewPlayerGuiId, header, "Error No Values")
            else
	       tes3mp.ListBox(pid, ViewPlayerGuiId, header, getPlayerFilesData())
        end
end

-- GUI Handler
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