print(">>Script: InstanceAura loading...OK")

-- 副本类型
local DUNGEON = 1
local HEROIC  = 2
local RAID    = 3

-- 阵营
local ALLIANCE = 1
local HORDE    = 2

-- 职业
local CLASS_HUNTER = 3 --猎人

--[[
    --联盟光环
    73762, -- 5%
    73824, -- 10%
    73825, -- 15%
    73826, -- 20%
    73827, -- 25%
    73828, -- 30%
    --部落光环
    73816, -- 5%
    73818, -- 10%
    73819, -- 15%
    73820, -- 20%
    73821, -- 25%
    73822, -- 30%
]]

local AURAS = {
    [ALLIANCE] = {
        [DUNGEON] = 73826, -- 20%
        [HEROIC]  = 73827, -- 25%
        [RAID]    = 73828, -- 30%
    },
    [HORDE] = {
        [DUNGEON] = 73820, -- 20%
        [HEROIC]  = 73821, -- 25%
        [RAID]    = 73822, -- 30%
    },
}

-- Função para adicionar aura com base no tipo de instância
local function AddAuraByInstanceType(player, instanceType)
    if not player then
        print("Erro: Player é nulo.")
        return
    end

    local faction = player:IsAlliance() and ALLIANCE or HORDE
    local auras = AURAS[faction]
    local auraId = auras[instanceType]

    if auraId and auraId > 0 then
        player:AddAura(auraId, player)
        print(string.format("Adicionado Aura ID %d para jogador %s", auraId, player:GetName()))
    else
        print("Erro: Aura ID inválida ou inexistente.")
    end
end

-- Função para limpar todas as auras relacionadas ao jogador
local function ClearAura(player)
    if not player then
        print("Erro: Player é nulo.")
        return
    end

    local faction = player:IsAlliance() and ALLIANCE or HORDE
    local auras = AURAS[faction]

    for _, auraId in pairs(auras) do
        if player:HasAura(auraId) then
            player:RemoveAura(auraId)
            print(string.format("Removido Aura ID %d para jogador %s", auraId, player:GetName()))
        end
    end
end

-- Evento quando o jogador muda de mapa
local function PlayerChangeMap(event, player)
    if not player or not player:GetMap() then
        print("Erro: Mapa ou jogador nulo.")
        return
    end

    if player:GetMap():IsDungeon() then
        ClearAura(player)
        AddAuraByInstanceType(player, DUNGEON)
        player:SendAreaTriggerMessage("您已获得地下城强化光环")
    elseif player:GetMap():IsHeroic() then
        ClearAura(player)
        AddAuraByInstanceType(player, HEROIC)
        player:SendAreaTriggerMessage("您已获得英雄地下城强化光环")
    elseif player:GetMap():IsRaid() then
        ClearAura(player)
        AddAuraByInstanceType(player, RAID)
        player:SendAreaTriggerMessage("您已获得团队地下城强化光环")
    else
        ClearAura(player)
    end
end

-- Registrar evento de mudança de mapa
RegisterPlayerEvent(27, PlayerChangeMap)
