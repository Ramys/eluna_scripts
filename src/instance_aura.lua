-- Carregando o script: Aura de Instância

print(">> Script: Aura de Instância carregado... OK")

-- Tipos de instâncias
local DUNGEON = 1 -- Masmorra
local HEROIC = 2  -- Heroico
local RAID = 3    -- Raide

-- Facções
local ALLIANCE = 1 -- Aliança
local HORDE = 2    -- Horda

-- Classes
local CLASS_HUNTER = 3 -- Caçador

--[[
    -- Aura da Aliança
    73762, -- 5%
    73824, -- 10%
    73825, -- 15%
    73826, -- 20%
    73827, -- 25%
    73828, -- 30%
    -- Aura da Horda
    73816, -- 5%
    73818, -- 10%
    73819, -- 15%
    73820, -- 20%
    73821, -- 25%
    73822, -- 30%
]]

-- Tabela de Auras
local AURAS = {
    [ALLIANCE] = {
        [DUNGEON] = 73826, -- 20%
        [HEROIC] = 73827,  -- 25%
        [RAID] = 73828,    -- 30%
    },
    [HORDE] = {
        [DUNGEON] = 73820, -- 20%
        [HEROIC] = 73821,  -- 25%
        [RAID] = 73822,    -- 30%
    },
}

-- Função para adicionar aura com base no tipo de instância
local function AddAuraByInstanceType(player, instanceType)
    if not player then
        print("Erro: Jogador é nulo.")
        return
    end

    local faction = player:IsAlliance() and ALLIANCE or HORDE
    local auras = AURAS[faction]
    local auraId = auras[instanceType]

    if auraId and auraId > 0 then
        player:AddAura(auraId, player)
        print(string.format("Aura ID %d adicionada para o jogador %s", auraId, player:GetName()))
    else
        print("Erro: Aura ID inválida ou inexistente.")
    end
end

-- Função para limpar todas as auras relacionadas ao jogador
local function ClearAura(player)
    if not player then
        print("Erro: Jogador é nulo.")
        return
    end

    local faction = player:IsAlliance() and ALLIANCE or HORDE
    local auras = AURAS[faction]

    for _, auraId in pairs(auras) do
        if player:HasAura(auraId) then
            player:RemoveAura(auraId)
            print(string.format("Aura ID %d removida para o jogador %s", auraId, player:GetName()))
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
        player:SendAreaTriggerMessage("Você recebeu a aura de reforço de masmorra")
    elseif player:GetMap():IsHeroic() then
        ClearAura(player)
        AddAuraByInstanceType(player, HEROIC)
        player:SendAreaTriggerMessage("Você recebeu a aura de reforço de heroico")
    elseif player:GetMap():IsRaid() then
        ClearAura(player)
        AddAuraByInstanceType(player, RAID)
        player:SendAreaTriggerMessage("Você recebeu a aura de reforço de raide")
    else
        ClearAura(player)
    end
end

-- Registrar evento de mudança de mapa
RegisterPlayerEvent(27, PlayerChangeMap)
