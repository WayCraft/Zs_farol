local LightsOn = false
local ExtendedOn = false
local BlacklistedModels = {'DUMP', 'RHINO', 'BLIMP', 'BLIMP2'}
local Lights = {}
local Speeds = {}

RegisterNetEvent('Lights:Client:Return')
AddEventHandler('Lights:Client:Return', function(NewLights)
    Lights = NewLights
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local PlayerPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(PlayerPed) and IsControlJustPressed(1, 74) then
            if LightsOn then
                if ExtendedOn then
                    TriggerServerEvent('Lights:Server:Toggle', false)
                    LightsOn = false
                    ExtendedOn = false
                else
                    TriggerServerEvent('Lights:Server:Toggle', true, true)
                    ExtendedOn = true
                end
            else
                TriggerServerEvent('Lights:Server:Toggle', true, false)
                LightsOn = true
            end
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for Source, Extend in pairs(Lights) do
            local SourcePlayer = GetPlayerFromServerId(Source)
            local SourcePed = GetPlayerPed(SourcePlayer)
            local PedVehicle = GetVehiclePedIsIn(SourcePed, true)
            if PedVehicle then
                local ForwardVector = GetEntityForwardVector(PedVehicle)
                local LeftHeadLight = GetWorldPositionOfEntityBone(PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'headlight_l'))
                local RightHeadLight = GetWorldPositionOfEntityBone(PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'headlight_r'))
                local LeftTailLight = GetWorldPositionOfEntityBone(PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'taillight_l'))
                local RightTailLight = GetWorldPositionOfEntityBone(PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'taillight_r'))
                local LeftBrakeLight = GetWorldPositionOfEntityBone(PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'brakelight_l'))
                local RightBrakeLight = GetWorldPositionOfEntityBone(PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'brakelight_r'))
                local LeftReverseLight = GetWorldPositionOfEntityBone(PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'reversinglight_l'))
                local RightReverseLight = GetWorldPositionOfEntityBone(PedVehicle, GetEntityBoneIndexByName(PedVehicle, 'reversinglight_r'))
                if not IsModelBlacklisted(GetEntityModel(PedVehicle)) then
                    LeftHeadLight = GetOffsetFromEntityGivenWorldCoords(PedVehicle, LeftHeadLight.x, LeftHeadLight.y, LeftHeadLight.z)
                    LeftHeadLight = GetOffsetFromEntityInWorldCoords(PedVehicle, LeftHeadLight.x, LeftHeadLight.y - 0.55, LeftHeadLight.z)
                    RightHeadLight = GetOffsetFromEntityGivenWorldCoords(PedVehicle, RightHeadLight.x, RightHeadLight.y, RightHeadLight.z)
                    RightHeadLight = GetOffsetFromEntityInWorldCoords(PedVehicle, RightHeadLight.x, RightHeadLight.y - 0.55, RightHeadLight.z)
                    LeftTailLight = GetOffsetFromEntityGivenWorldCoords(PedVehicle, LeftTailLight.x, LeftTailLight.y, LeftTailLight.z)
                    LeftTailLight = GetOffsetFromEntityInWorldCoords(PedVehicle, LeftTailLight.x, LeftTailLight.y - 0.02, LeftTailLight.z)
                    RightTailLight = GetOffsetFromEntityGivenWorldCoords(PedVehicle, RightTailLight.x, RightTailLight.y, RightTailLight.z)
                    RightTailLight = GetOffsetFromEntityInWorldCoords(PedVehicle, RightTailLight.x, RightTailLight.y - 0.02, RightTailLight.z)
                    LeftBrakeLight = GetOffsetFromEntityGivenWorldCoords(PedVehicle, LeftBrakeLight.x, LeftBrakeLight.y, LeftBrakeLight.z)
                    LeftBrakeLight = GetOffsetFromEntityInWorldCoords(PedVehicle, LeftBrakeLight.x, LeftHeadLight.y - 0.30, LeftHeadLight.z)
                    RightBrakeLight = GetOffsetFromEntityGivenWorldCoords(PedVehicle, RightBrakeLight.x, RightBrakeLight.y, RightBrakeLight.z)
                    RightBrakeLight = GetOffsetFromEntityInWorldCoords(PedVehicle, RightBrakeLight.x, RightBrakeLight.y - 0.30, RightBrakeLight.z)
                    LeftReverseLight = GetOffsetFromEntityGivenWorldCoords(PedVehicle, LeftReverseLight.x, LeftReverseLight.y, LeftReverseLight.z)
                    LeftReverseLight = GetOffsetFromEntityInWorldCoords(PedVehicle, LeftReverseLight.x, LeftReverseLight.y - 0.30, LeftReverseLight.z)
                    RightReverseLight = GetOffsetFromEntityGivenWorldCoords(PedVehicle, RightReverseLight.x, RightReverseLight.y, RightReverseLight.z)
                    RightReverseLight = GetOffsetFromEntityInWorldCoords(PedVehicle, RightReverseLight.x, RightReverseLight.y - 0.30, RightReverseLight.z)
                    if GetIsVehicleEngineRunning(PedVehicle) and not (GetVehicleClassFromName(GetEntityModel(PedVehicle)) == 13) then
                        local R, G, B, Fade
                        if IsToggleModOn(PedVehicle, 22) then
                            R, G, B, Brightness, Fade = 20, 57, 127, 15.0, 10.0
                        else
                            R, G, B, Brightness, Fade = 255, 255, 255, 7.5, 15.0
                        end
                        if Extend then
                            DrawSpotLight(LeftHeadLight.x, LeftHeadLight.y, LeftHeadLight.z, ForwardVector.x, ForwardVector.y, ForwardVector.z, R, G, B, 80.0, Brightness, 0.0, 35.0, Fade)
                            DrawSpotLight(RightHeadLight.x, RightHeadLight.y, RightHeadLight.z, ForwardVector.x, ForwardVector.y, ForwardVector.z, R, G, B, 80.0, Brightness, 0.0, 35.0, Fade)
                        else
                            DrawSpotLight(LeftHeadLight.x, LeftHeadLight.y, LeftHeadLight.z, ForwardVector.x, ForwardVector.y, ForwardVector.z, R, G, B, 40.0, Brightness, 0.0, 30.0, Fade)
                            DrawSpotLight(RightHeadLight.x, RightHeadLight.y, RightHeadLight.z, ForwardVector.x, ForwardVector.y, ForwardVector.z, R, G, B, 40.0, Brightness, 0.0, 30.0, Fade)
                            DrawSpotLight(LeftBrakeLight.x, LeftBrakeLight.y, LeftBrakeLight.z, ForwardVector.x * -1, ForwardVector.y * -1, ForwardVector.z, 255, 0, 0, 4.0, 0.4, 0.0, 80.0, 80.0)
                            DrawSpotLight(RightBrakeLight.x, RightBrakeLight.y, RightBrakeLight.z, ForwardVector.x * -1, ForwardVector.y * -1, ForwardVector.z, 255, 0, 0, 4.0, 0.4, 0.0, 80.0, 80.0)
                        end
                        DrawSpotLight(LeftTailLight.x, LeftTailLight.y, LeftTailLight.z, ForwardVector.x * -1, ForwardVector.y * -1, ForwardVector.z, 255, 0, 0, 4.0, 0.4, 0.0, 80.0, 5.0)
                        DrawSpotLight(RightTailLight.x, RightTailLight.y, RightTailLight.z, ForwardVector.x * -1, ForwardVector.y * -1, ForwardVector.z, 255, 0, 0, 4.0, 0.4, 0.0, 80.0, 5.0)
                        if not Speeds[PedVehicle] then
                            Speeds[PedVehicle] = {}
                            Speeds[PedVehicle].Now = 0
                            Speeds[PedVehicle].Last = 0
                        end
                        Speeds[PedVehicle].Now = GetEntitySpeedVector(PedVehicle, true).y
                        if Speeds[PedVehicle].Now < -0.05 then
                            DrawSpotLight(LeftReverseLight.x, LeftReverseLight.y, LeftReverseLight.z, ForwardVector.x * -1, ForwardVector.y * -1, ForwardVector.z, 255, 255, 255, 5.0, 0.7, 0.0, 80.0, 5.0)
                            DrawSpotLight(RightReverseLight.x, RightReverseLight.y, RightReverseLight.z, ForwardVector.x * -1, ForwardVector.y * -1, ForwardVector.z, 255, 255, 255, 5.0, 0.7, 0.0, 80.0, 5.0)
                        end
                        if Speeds[PedVehicle].Now + 0.2 < Speeds[PedVehicle].Last then
                            DrawSpotLight(LeftTailLight.x, LeftTailLight.y, LeftTailLight.z, ForwardVector.x * -1, ForwardVector.y * -1, ForwardVector.z, 255, 0, 0, 4.0, 1.0, 0.0, 80.0, 5.0)
                            DrawSpotLight(RightTailLight.x, RightTailLight.y, RightTailLight.z, ForwardVector.x * -1, ForwardVector.y * -1, ForwardVector.z, 255, 0, 0, 4.0, 1.0, 0.0, 80.0, 5.0)
                        end
                        Speeds[PedVehicle].Last = Speeds[PedVehicle].Now
                    end
                end
            end
        end
    end
end)

function TriggerLight()
    if not On then
        On = true
    else
        if not ExtendedOn then
            ExtendedOn = true
        else
            ExtendedOn = false
            On = false
        end
    end
end

function IsModelBlacklisted(Model)
    for _, BlacklistedModel in ipairs(BlacklistedModels) do
        if Model == GetHashKey(BlacklistedModel) then return true end
    end
    return false
end