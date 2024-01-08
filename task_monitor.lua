TaskMonitor = {}

function TaskMonitor:new(entity, cTasks)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.entity = entity
    obj.displayedTasks = nil
    obj.cTasks = cTasks or {}
    obj:run()
    obj:drawTasks()
    return obj
end

function TaskMonitor:drawText3D(coords, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + 1.5)
    local dist = #(GetGameplayCamCoords() - coords)

    local scale = (1 / dist) * 15
    local fov = (1 / GetGameplayCamFov()) * 10
    scale = scale * fov

    if onScreen then
        SetTextScale(1.5 * scale, 1.5 * scale)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function TaskMonitor:getActiveTasks()
    local tasks = {}
    for id, task in pairs(self.cTasks) do
        if GetIsTaskActive(self.entity, id) then
            tasks[#tasks + 1] = task
        end
    end
    return tasks
end

function TaskMonitor:run()
    CreateThread(function()
        local activeTasks = {}
        while self.entity do
            Wait(250)
            if DoesEntityExist(self.entity) then
                activeTasks = self:getActiveTasks()
            else
                self.entity = nil
            end
            self.displayedTasks = activeTasks[1] and table.concat(activeTasks, '~n~') or nil;
        end
    end)
end

function TaskMonitor:drawTasks()
    CreateThread(function()
        while self.entity do
            Wait(0)
            if self.displayedTasks then
                self:drawText3D(GetEntityCoords(self.entity), self.displayedTasks)
            end
        end
    end)
end

function TaskMonitor:destroy()
    self.entity = nil
end



