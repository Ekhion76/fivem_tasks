local enable
local monitoredEntities = {}

RegisterCommand('tasks', function()
    enable = not enable

    if enable then
        startMonitor()
    else
        stopMonitor()
    end
end)

function startMonitor()
    print('Task Monitor Started')
    CreateThread(function()
        while enable do
            for _, entity in pairs(GetGamePool('CPed')) do
                if not monitoredEntities[entity] then
                    monitoredEntities[entity] = TaskMonitor:new(entity, cTasks)
                end
            end
            Wait(1000)
        end
    end)
end

function stopMonitor()
    print('Task Monitor Stopped')
    for entity, monitor in pairs(monitoredEntities) do
        monitor:destroy()
        monitoredEntities[entity] = nil
    end
end



