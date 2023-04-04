local Lights = {}
local ChangeNeeded = false

RegisterServerEvent('Lights:Server:Toggle')
AddEventHandler('Lights:Server:Toggle', function(bool, extend)
    if bool then
        Lights[source] = extend
    else
        Lights[source] = nil
    end

    ChangeNeeded = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if ChangeNeeded then
            LastCount = Count
            TriggerClientEvent('Lights:Client:Return', -1, Lights)
            ChangeNeeded = false
        end
    end
end)