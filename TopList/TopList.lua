local Top = {}

local UpdatePlayerStats = function(pid)
      Top = {}
      local player = Players[pid]

      local playerName = Players[pid].name
      if (player.data.stats.levelProgress >= 1) or (player.data.stats.level > 1) then
           local LvL = player.data.stats.level
           local Progress = player.data.stats.levelProgress
           local cHP = player.data.stats.healthCurrent
           local bHP = player.data.stats.healthBase
           local Race = player.data.character.race
           local Cell = player.data.location.cell
           Top[playerName] = {}
           Top[playerName].level = LvL
           Top[playerName].levelProgress = Progress
           Top[playerName].healthCurrent = cHP
           Top[playerName].healthBase = bHP
           Top[playerName].race = Race
           Top[playerName].class = Class
              if tes3mp.IsInExterior(pid) == true  then
                 local Cell = player.data.location.regionName
                 Top[playerName].cell = Cell 
              else
                 Top[playerName].cell = Cell 
	      end

          jsonInterface.save("TopList/" .. playerName .. ".json", Top)
      end
end

customEventHooks.registerHandler("OnPlayerLevel", function(eventStatus, pid)
    UpdatePlayerStats(pid)
end)

customEventHooks.registerHandler("OnPlayerCellChange", function(eventStatus, pid)
    UpdatePlayerStats(pid)
end)
