-- Super Hearthstone
print(">> Script: Super Hearthstone carregado... OK")

-- Item de menu padrão
local itemEntry = 6948

-- Constantes de facções
local TEAM_ALLIANCE = 0 -- Aliança
local TEAM_HORDE = 1    -- Horda

-- IDs dos menus
local MMENU = 1         -- Menu principal
local TPMENU = 2        -- Menu de teletransporte
local GMMENU = 3        -- Menu GM
local ENCMENU = 4       -- Menu de encantamento

-- Tipos de menus
local FUNC = 1          -- Função
local MENU = 2          -- Submenu
local TP = 3            -- Teletransporte
local ENC = 4           -- Encantamento
local SPELL_HEARTHSTONE = 8690 -- ID do feitiço de pedra de retorno

-- Ícones de diálogo
local GOSSIP_ICON_CHAT = 0                    -- Chat
local GOSSIP_ICON_VENDOR = 1                  -- Comerciante
local GOSSIP_ICON_TAXI = 2                    -- Transporte
local GOSSIP_ICON_TRAINER = 3                 -- Treinador
local GOSSIP_ICON_INTERACT_1 = 4              -- Interagir 1
local GOSSIP_ICON_INTERACT_2 = 5              -- Interagir 2
local GOSSIP_ICON_MONEY_BAG = 6               -- Bolsa de dinheiro
local GOSSIP_ICON_TALK = 7                   -- Conversar
local GOSSIP_ICON_TABARD = 8                  -- Emblema
local GOSSIP_ICON_BATTLE = 9                  -- Batalha
local GOSSIP_ICON_DOT = 10                    -- Ponto

-- Posições de equipamento
local EQUIPMENT_SLOT_HEAD = 0     -- Cabeça
local EQUIPMENT_SLOT_NECK = 1     -- Pescoço
local EQUIPMENT_SLOT_SHOULDERS = 2 -- Ombros
local EQUIPMENT_SLOT_BODY = 3     -- Torso
local EQUIPMENT_SLOT_CHEST = 4    -- Peito
local EQUIPMENT_SLOT_WAIST = 5    -- Cintura
local EQUIPMENT_SLOT_LEGS = 6     -- Pernas
local EQUIPMENT_SLOT_FEET = 7     -- Pés
local EQUIPMENT_SLOT_WRISTS = 8   -- Pulso
local EQUIPMENT_SLOT_HANDS = 9    -- Mãos
local EQUIPMENT_SLOT_FINGER1 = 10 -- Dedo 1
local EQUIPMENT_SLOT_FINGER2 = 11 -- Dedo 2
local EQUIPMENT_SLOT_TRINKET1 = 12 -- Pingente 1
local EQUIPMENT_SLOT_TRINKET2 = 13 -- Pingente 2
local EQUIPMENT_SLOT_BACK = 14    -- Asa
local EQUIPMENT_SLOT_MAINHAND = 15 -- Mão principal
local EQUIPMENT_SLOT_OFFHAND = 16 -- Mão secundária
local EQUIPMENT_SLOT_RANGED = 17  -- Arma de longo alcance
local EQUIPMENT_SLOT_TABARD = 18  -- Emblema

-- Tabela de instâncias
local Instances = {
    {249, 0}, {249, 1}, {269, 1}, {309, 0},
    {409, 0}, {469, 0},
    {509, 0}, {531, 0}, {532, 0}, {533, 0}, {533, 1},
    {534, 0}, {540, 1}, {542, 1}, {543, 1}, {544, 0}, {545, 1}, {546, 1}, {547, 1}, {548, 0},
    {550, 0}, {552, 1}, {553, 1}, {554, 1}, {555, 1}, {556, 1}, {557, 1}, {558, 1},
    {560, 1}, {564, 0}, {565, 0}, {568, 0},
    {574, 1}, {575, 1}, {576, 1}, {578, 1},
    {580, 0}, {585, 1}, {595, 1}, {598, 1}, {599, 1},
    {600, 1}, {601, 1}, {602, 1}, {603, 0}, {603, 1}, {604, 1}, {608, 1},
    {615, 0}, {615, 1}, {616, 0}, {616, 1}, {619, 1}, {624, 0}, {624, 1},
    {631, 0}, {631, 1}, {631, 2}, {631, 3}, {632, 1},
    {649, 0}, {649, 1}, {649, 2}, {649, 3}, -- Teste da Cruzada
    {650, 1}, {658, 1}, {668, 1},
    {724, 0}, {724, 1}, {724, 2}, {724, 3},
}

-- NPC acompanhante
local ST = {
    TIME = 90, -- Segundos
    NPCID1 = 190098,
    NPCID2 = 190099,
    -- [guid] = lasttime,
}

function ST.SummonNPC(player, entry)
    local guid = player:GetGUIDLow()
    local lastTime, nowTime = (ST[guid] or 0), os.time()
    if player:IsInCombat() then
        player:SendAreaTriggerMessage("Não é possível convocar enquanto estiver em combate.")
    else
        if nowTime > lastTime then
            local map = player:GetMap()
            if map then
                player:SendAreaTriggerMessage(map:GetName())
                local x, y, z = player:GetX() + 1, player:GetY(), player:GetZ()
                local nz = map:GetHeight(x, y)
                if nz > z and nz < (z + 5) then
                    z = nz
                end
                local NPC = player:SpawnCreature(entry, x, y, z, 0, 3, ST.TIME * 1000)
                if NPC then
                    player:SendAreaTriggerMessage("Convocação bem-sucedida do comerciante acompanhante.")
                    NPC:SetFacingToObject(player)
                    NPC:SendUnitSay(string.format("%s, olá! Precisa de algo?", player:GetName()), 0)
                    lastTime = os.time() + ST.TIME
                else
                    player:SendAreaTriggerMessage("Falha ao convocar o comerciante acompanhante.")
                end
            end
        else
            player:SendAreaTriggerMessage("Não é possível convocar o NPC com tanta frequência.")
        end
    end
    ST[guid] = lastTime
end

function ST.SummonGNPC(player) -- Convocar comerciante
    ST.SummonNPC(player, ST.NPCID2)
end

function ST.SummonENPC(player) -- Convocar encantador
    ST.SummonNPC(player, ST.NPCID1)
end

-- Auras dinâmicas por tipo de instância
local DUNGEON = 1 -- Masmorra
local HEROIC = 2  -- Heroico
local RAID = 3    -- Raide

-- Facções
local ALLIANCE = 1
local HORDE = 2

-- Auras
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

local function AddAuraToPetByInstanceType(player, instanceType)
    -- if player:GetClass() ~= CLASS_HUNTER then
    --     player:SendAreaTriggerMessage("Você não é um caçador")
    --     return false
    -- end
    local pet = player:GetSelection()
    if pet and pet:GetOwner() == player then
        local auras = player:IsAlliance() and AURAS[ALLIANCE] or AURAS[HORDE]
        local auraId = auras[instanceType]
        if auraId and auraId > 0 then
            pet:AddAura(auraId, pet)
            return true
        end
    end
end

function ST.AddAuraToPet(player)
    local map = player:GetMap()
    local instanceType
    if map:IsDungeon() then
        instanceType = DUNGEON
    elseif map:IsHeroic() then
        instanceType = HEROIC
    elseif map:IsRaid() then
        instanceType = RAID
    end
    if AddAuraToPetByInstanceType(player, instanceType) then
        player:SendAreaTriggerMessage("Seu pet recebeu a aura de reforço.")
    end
end

local function ResetPlayer(player, flag, text)
    player:SetAtLoginFlag(flag)
    player:SendAreaTriggerMessage("Você precisa reiniciar o personagem para modificar o "..text..".")
    -- player:SendAreaTriggerMessage("Voltando ao menu de seleção de personagem")
    -- player:LogoutPlayer(true)
end

local Stone = {
    GetTimeASString = function(player)
        local inGameTime = player:GetTotalPlayedTime()
        local days = math.modf(inGameTime / (24 * 3600))
        local hours = math.modf((inGameTime - (days * 24 * 3600)) / 3600)
        local mins = math.modf((inGameTime - (days * 24 * 3600 + hours * 3600)) / 60)
        return days .. " dias " .. hours .. " horas " .. mins .. " minutos"
    end,

    GoHome = function(player) -- Ir para casa
        player:CastSpell(player, SPELL_HEARTHSTONE, true)
        player:ResetSpellCooldown(SPELL_HEARTHSTONE, true)
        player:SendBroadcastMessage("Você já está em casa.")
    end,

    SetHome = function(player) -- Definir posição atual como casa
        local x, y, z, mapId, areaId = player:GetX(), player:GetY(), player:GetZ(), player:GetMapId(), player:GetAreaId()
        player:SetBindPoint(x, y, z, mapId, areaId)
        player:SendBroadcastMessage("A sua casa foi definida na sua posição atual.")
    end,

    OpenBank = function(player) -- Abrir banco
        player:SendShowBank(player)
        player:SendBroadcastMessage("Banco aberto.")
    end,

    WeakOut = function(player) -- Remover frágil após ressurreição
        if player:HasAura(15007) then
            player:RemoveAura(15007) -- Remover frágil após ressurreição
            player:SetHealth(player:GetMaxHealth())
            -- self:RemoveAllAuras() -- Remover todos os efeitos
            player:SendBroadcastMessage("O estado de frágil após ressurreição foi removido.")
        else
            player:SendBroadcastMessage("Você não está frágil após ressurreição.")
        end
    end,

    OutCombat = function(player) -- Sair de combate
        if player:IsInCombat() then
            player:ClearInCombat()
            player:SendAreaTriggerMessage("Você saiu do combate.")
            player:SendBroadcastMessage("Você saiu do combate.")
        else
            player:SendAreaTriggerMessage("Você não está em combate.")
            player:SendBroadcastMessage("Você não está em combate.")
        end
    end,

    WSkillsToMax = function(player) -- Avançar habilidades para o máximo
        player:AdvanceSkillsToMax()
        player:SendBroadcastMessage("Suas habilidades foram avançadas para o nível máximo.")
    end,

    MaxHealth = function(player) -- Restaurar vida máxima
        player:SetHealth(player:GetMaxHealth())
        player:SendBroadcastMessage("Sua vida foi restaurada ao máximo.")
    end,

    ResetTalents = function(player) -- Reiniciar talentos
        player:ResetTalents(true) -- Grátis
        player:SendBroadcastMessage("Seus talentos foram reiniciados.")
    end,

    ResetPetTalents = function(player) -- Reiniciar talentos do pet
        player:ResetPetTalents()
        player:SendBroadcastMessage("Os talentos do seu pet foram reiniciados.")
    end,

    ResetAllCD = function(player) -- Resetar todas as recargas
        player:ResetAllCooldowns()
        player:SendBroadcastMessage("Todas as recargas de itens e habilidades foram resetadas.")
    end,

    RepairAll = function(player) -- Reparar todo o equipamento
        player:DurabilityRepairAll(true, 1, false)
        player:SendBroadcastMessage("Todo o seu equipamento foi reparado.")
    end,

    SaveToDB = function(player) -- Salvar dados
        player:SaveToDB()
        player:SendAreaTriggerMessage("Dados salvos com sucesso.")
    end,

    Logout = function(player) -- Voltar ao menu de seleção de personagem
        player:SendAreaTriggerMessage("Voltando ao menu de seleção de personagem...")
        player:LogoutPlayer(true)
    end,

    LogoutNosave = function(player) -- Voltar sem salvar
        player:SendAreaTriggerMessage("Voltando ao menu de seleção de personagem sem salvar...")
        player:LogoutPlayer(false)
    end,

    UnBind = function(player) -- Desvincular instâncias
        local currentMap = player:GetMapId()
        for _, v in pairs(Instances) do
            local mapId = v[1]
            if mapId ~= currentMap then
                player:UnbindInstance(v[1], v[2])
            else
                player:SendBroadcastMessage("Você não pode desvincular a instância atual.")
            end
        end
        player:SendAreaTriggerMessage("Todas as vinculações de instâncias foram removidas.")
        player:SendBroadcastMessage("Todas as vinculações de instâncias foram removidas.")
    end,

    ResetName = function(player, code) -- Alterar nome
        local target = player:GetSelection()
        if target and (target:GetTypeId() == player:GetTypeId()) then
            ResetPlayer(target, 0x1, "nome")
        else
            player:SendAreaTriggerMessage("Selecione um jogador.")
        end
    end,

    ResetFace = function(player)
        ResetPlayer(player, 0x8, "aparência")
    end,

    ResetRace = function(player)
        ResetPlayer(player, 0x80, "raça")
    end,

    ResetFaction = function(player)
        ResetPlayer(player, 0x40, "facção")
    end,

    ResetSpell = function(player)
        ResetPlayer(player, 0x2, "todos os feitiços")
    end,
}

local Menu = {
    [MMENU] = { -- Menu principal
        {FUNC, "Teleportar para casa", Stone.GoHome, GOSSIP_ICON_CHAT, false, "Deseja teleportar para casa?"},
        {FUNC, "Definir posição atual como casa", Stone.SetHome, GOSSIP_ICON_INTERACT_1, false, "Deseja definir esta posição como casa?"},
        {FUNC, "Abrir banco online", Stone.OpenBank, GOSSIP_ICON_MONEY_BAG},
        {MENU, "Menu de teletransporte", TPMENU, GOSSIP_ICON_BATTLE},
        {MENU, "Outras funções", MMENU + 0x10, GOSSIP_ICON_INTERACT_1},
        {MENU, "Encantador duplo", ENCMENU, GOSSIP_ICON_TABARD},
        {FUNC, "Desvincular instâncias", Stone.UnBind, GOSSIP_ICON_INTERACT_1, false, "Deseja desvincular todas as instâncias?"},
        {FUNC, "Convocar comerciante acompanhante", ST.SummonGNPC, GOSSIP_ICON_MONEY_BAG},
        -- {FUNC, "NPC de encantador", ST.SummonENPC, GOSSIP_ICON_TABARD},
        {MENU, "Treinadores de habilidades de classe", MMENU + 0x20, GOSSIP_ICON_BATTLE},
        {MENU, "Treinadores de habilidades profissionais", MMENU + 0x30, GOSSIP_ICON_BATTLE},
        -- {FUNC, "Forçar saída de combate", Stone.OutCombat, GOSSIP_ICON_CHAT},
        {FUNC, "Adicionar aura ao pet na instância", ST.AddAuraToPet, GOSSIP_ICON_BATTLE},
    },
    [MMENU + 0x10] = { -- Outras funções
        {FUNC, "Remover fraqueza", Stone.WeakOut, GOSSIP_ICON_INTERACT_1, false, "Deseja remover a fraqueza e restaurar a saúde?"},
        {FUNC, "Reiniciar talentos", Stone.ResetTalents, GOSSIP_ICON_TRAINER, false, "Confirmar reinicialização de talentos?"},
        {FUNC, "Avançar habilidades de arma até o máximo", Stone.WSkillsToMax, GOSSIP_ICON_TRAINER, false, "Confirmar avanço das habilidades de arma até o máximo?"},
        {FUNC, "Reparar todo o equipamento", Stone.RepairAll, GOSSIP_ICON_VENDOR, false, "Deseja gastar ouro para reparar o equipamento?"},
        -- {FUNC, "Alterar nome", Stone.ResetName, GOSSIP_ICON_CHAT, false, "Deseja alterar o nome?\n|cFFFFFF00É necessário reiniciar o personagem.|r"},
        -- {FUNC, "Alterar aparência", Stone.ResetFace, GOSSIP_ICON_CHAT, false, "Deseja alterar a aparência?\n|cFFFFFF00É necessário reiniciar o personagem.|r"},
        -- {FUNC, "Alterar raça", Stone.ResetRace, GOSSIP_ICON_CHAT, false, "Deseja alterar a raça?\n|cFFFFFF00É necessário reiniciar o personagem.|r"},
        -- {FUNC, "Alterar facção", Stone.ResetFaction, GOSSIP_ICON_CHAT, false, "Deseja alterar a facção?\n|cFFFFFF00É necessário reiniciar o personagem.|r"},
        {FUNC, "Esquecer todos os feitiços", Stone.ResetSpell, GOSSIP_ICON_CHAT, false, "Deseja esquecer todos os feitiços?\n|cFFFFFF00É necessário reiniciar o personagem para que isso tenha efeito.|r"},
    },
    [GMMENU] = { -- Menu GM
        {FUNC, "Resetar todas as recargas", Stone.ResetAllCD, GOSSIP_ICON_INTERACT_1, false, "Confirmar reset de todas as recargas?"},
        {FUNC, "Salvar personagem", Stone.SaveToDB, GOSSIP_ICON_INTERACT_1},
        {FUNC, "Voltar ao menu de seleção de personagem", Stone.Logout, GOSSIP_ICON_INTERACT_1, false, "Voltar ao menu de seleção de personagem?"},
        {FUNC, "|cFF800000Não salvar personagem|r", Stone.LogoutNosave, GOSSIP_ICON_INTERACT_1, false, "|cFFFF0000Não salvar personagem e voltar ao menu de seleção de personagem?|r"},
    },
    [TPMENU] = { -- Menu de teletransporte
        {MENU, "|cFF006400[Cidades]|r Principais cidades", TPMENU + 0x10, GOSSIP_ICON_BATTLE},
        {MENU, "|cFF006400[Nascimento]|r Locais de nascimento racial", TPMENU + 0x20, GOSSIP_ICON_BATTLE},
        {MENU, "|cFF0000FF[Exterior]|r Reino da Expansão Oriental", TPMENU + 0x30, GOSSIP_ICON_BATTLE},
        {MENU, "|cFF0000FF[Exterior]|r Kalimdor", TPMENU + 0x40, GOSSIP_ICON_BATTLE},
        {MENU, "|cFF0000FF[Exterior]|r |cFF006400Outland|r", TPMENU + 0x50, GOSSIP_ICON_BATTLE},
        {MENU, "|cFF0000FF[Exterior]|r |cFF4B0082Northrend|r", TPMENU + 0x60, GOSSIP_ICON_BATTLE},
        {MENU, "|cFF006400[Dungeons 5p] Classic World Dungeons|r ★☆☆☆☆", TPMENU + 0x70, GOSSIP_ICON_BATTLE},
        {MENU, "|cFF0000FF[Dungeons 5p] Burning Crusade Dungeons|r ★★☆☆☆", TPMENU + 0x80, GOSSIP_ICON_BATTLE},
        {MENU, "|cFF4B0082[Dungeons 5p] Wrath of the Lich King Dungeons|r ★★★☆☆", TPMENU + 0x90, GOSSIP_ICON_BATTLE},
        {MENU, "|cFFB22222[Tanks & Dungeons 10p-40p] Team Dungeons|r ★★★★★", TPMENU + 0xa0, GOSSIP_ICON_BATTLE},
        {MENU, "Teleportes de paisagem", TPMENU + 0xb0, GOSSIP_ICON_BATTLE},
        {MENU, "Teleportes de arena", TPMENU + 0xc0, GOSSIP_ICON_BATTLE},
        {MENU, "Teleportes de chefes externos", TPMENU + 0xd0, GOSSIP_ICON_BATTLE},
        {MENU, "Teleportes de arena", TPMENU + 0xe0, GOSSIP_ICON_BATTLE},
    },
    [TPMENU + 0x10] = { -- Cidades principais
        {TP, "Cidade da Tempestade", 0, -8842.09, 626.358, 94.0867, 3.61363, TEAM_ALLIANCE},
        {TP, "Darnassus", 1, 9869.91, 2493.58, 1315.88, 2.78897, TEAM_ALLIANCE},
        {TP, "Ironforge", 0, -4900.47, -962.585, 501.455, 5.40538, TEAM_ALLIANCE},
        {TP, "Exodar", 530, -3864.92, -11643.7, -137.644, 5.50862, TEAM_ALLIANCE},
        {TP, "Orgrimmar", 1, 1601.08, -4378.69, 9.9846, 2.14362, TEAM_HORDE},
        {TP, "Thunder Bluff", 1, -1274.45, 71.8601, 128.159, 2.80623, TEAM_HORDE},
        {TP, "Undercity", 0, 1633.75, 240.167, -43.1034, 6.26128, TEAM_HORDE},
        {TP, "Silvermoon City", 530, 9738.28, -7454.19, 13.5605, 0.043914, TEAM_HORDE},
        {TP, "[Northrend] Dalaran", 571, 5809.55, 503.975, 657.526, 2.38338},
        {TP, "[Outland] Shattrath", 530, -1887.62, 5359.09, -12.4279, 4.40435},
        {TP, "[Neutra] Treasure Bay", 0, -14281.9, 552.564, 8.90422, 0.860144},
        {TP, "[Neutra] Razor Hill", 1, -955.21875, -3678.92, 8.29946, 0},
        {TP, "[Neutra] Gearsby", 1, -7122.79834, -3704.82, 14.0526, 0},
    },
    [TPMENU + 0x20] = { -- Locais de nascimento racial
        {TP, "Local de nascimento humano", 0, -8949.95, -132.493, 83.5312, 0, TEAM_ALLIANCE},
        {TP, "Local de nascimento anão", 0, -6240.32, 331.033, 382.758, 6.1, TEAM_ALLIANCE},
        {TP, "Local de nascimento goblin", 0, -6240, 331, 383, 0, TEAM_ALLIANCE},
        {TP, "Local de nascimento elfo noturno", 1, 10311.3, 832.463, 1326.41, 5.6, TEAM_ALLIANCE},
        {TP, "Local de nascimento draenei", 530, -3961.64, -13931.2, 100.615, 2, TEAM_ALLIANCE},
        {TP, "Local de nascimento orc", 1, -618.518, -4251.67, 38.718, 0, TEAM_HORDE},
        {TP, "Local de nascimento troll", 1, -618.518, -4251.67, 38.7, 4.747, TEAM_HORDE},
        {TP, "Local de nascimento tauren", 1, -2917.58, -257.98, 52.9968, 0, TEAM_HORDE},
        {TP, "Local de nascimento morto-vivo", 0, 1676.71, 1678.31, 121.67, 2.70526, TEAM_HORDE},
        {TP, "Local de nascimento blood elf", 530, 10349.6, -6357.29, 33.4026, 5.31605, TEAM_HORDE},
        {TP, "|cFF006400Local de nascimento death knight|r", 609, 2355.84, -5664.77, 426.028, 3.65997, TEAM_NONE, 55, 0},
    },
    [TPMENU + 0x30] = { -- Região Oriental
        {TP, "Elwynn Forest", 0, -9449.06, 64.8392, 56.3581, 3.0704},
        {TP, "Eversong Woods", 530, 9024.37, -6682.55, 16.8973, 3.1413},
        {TP, "Dun Morogh", 0, -5603.76, -482.704, 396.98, 5.2349},
        {TP, "Tirisfal Glades", 0, 2274.95, 323.918, 34.1137, 4.2436},
        {TP, "Ghostlands", 530, 7595.73, -6819.6, 84.3718, 2.5656},
        {TP, "Loch Modan", 0, -5405.85, -2894.15, 341.972, 5.4823},
        {TP, "Silverpine Forest", 0, 505.126, 1504.63, 124.808, 1.7798},
        {TP, "Western Plaguelands", 0, -10684.9, 1033.63, 32.5389, 6.0738},
        {TP, "Redridge Mountains", 0, -9447.8, -2270.85, 71.8224, 0.28385},
        {TP, "Darkshore", 0, -10531.7, -1281.91, 38.8647, 1.5695},
        {TP, "Hillsbrad Foothills", 0, -385.805, -787.954, 54.6655, 1.0392},
        {TP, "Swamp of Sorrows", 0, -3517.75, -913.401, 8.86625, 2.6070},
        {TP, "Alterac Mountains", 0, 275.049, -652.044, 130.296, 0.50203},
        {MENU, "Próxima página", TPMENU + 0x120, GOSSIP_ICON_CHAT},
    },
    [TPMENU + 0x120] = { -- Região Oriental 2
        {TP, "Arathi Highlands", 0, -1581.45, -2704.06, 35.4168, 0.490373},
        {TP, "Stranglethorn Vale", 0, -11921.7, -59.544, 39.7262, 3.7357},
        {TP, "The Barrens", 0, -6782.56, -3128.14, 240.48, 5.6591},
        {TP, "Swamp of Sorrows", 0, -10368.6, -2731.3, 21.6537, 5.2923},
        {TP, "Searing Gorge", 0, 112.406, -3929.74, 136.358, 0.981903},
        {TP, "Blazing Plains", 0, -6686.33, -1198.55, 240.027, 0.91688},
        {TP, "Felwood", 0, -11184.7, -3019.31, 7.29238, 3.20542},
        {TP, "Burning Steppes", 0, -7979.78, -2105.72, 127.919, 5.10148},
        {TP, "Westfall", 0, 1743.69, -1723.86, 59.6648, 5.23722},
        {TP, "Eastern Plaguelands", 0, 2280.64, -5275.05, 82.0166, 4.747},
        {TP, "Isle of Quel'Danas", 530, 12806.5, -6911.11, 41.1156, 2.2293},
    },
    [TPMENU + 0x40] = { -- Kalimdor
        {TP, "Azuremyst Isle", 530, -4192.62, -12576.7, 36.7598, 1.62813},
        {TP, "Bloodmyst Isle", 530, -2721.67, -12208.90, 9.08, 0},
        {TP, "Dazar'alor", 1, 9889.03, 915.869, 1307.43, 1.9336},
        {TP, "Durotar", 1, 228.978, -4741.87, 10.1027, 0.416883},
        {TP, "Moonglade", 1, -2473.87, -501.225, -9.42465, 0.6525},
        {TP, "Bloodmyst Isle", 530, -2095.7, -11841.1, 51.1557, 6.19288},
        {TP, "Blackrock Beach", 1, 6463.25, 683.986, 8.92792, 4.33534},
        {TP, "Badlands", 1, -575.772, -2652.45, 95.6384, 0.006469},
        {TP, "Hellfire Peninsula", 530, -207.335, 2035.92, 96.46
