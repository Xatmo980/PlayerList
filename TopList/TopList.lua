local Top = {}
local Progress = 0

customEventHooks.registerHandler("OnPlayerLevel", function(eventStatus, pid)
    Top = {}
    local player = Players[pid]

    local playerName = Players[pid].name
    if (player.data.stats.levelProgress ~= nil) then
       if (player.data.stats.levelProgress > 0) or (player.data.stats.level > 1) then
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
           Top[playerName].cell = Cell

          jsonInterface.save("TopList/" .. playerName .. ".json", Top)
    end
  end
end)