-- Sistema de Boas-Vindas ao Jogador

print(">> Script: Boas-Vindas ao Jogador")

-- Definição das Alianças
local TEAM_ALLIANCE = 0 -- Aliança
local TEAM_HORDE = 1    -- Horda

-- Definição das Classes
local CLASS_WARRIOR      = 1  -- Guerreiro
local CLASS_PALADIN      = 2  -- Paladino
local CLASS_HUNTER       = 3  -- Caçador
local CLASS_ROGUE        = 4  -- Ladrão
local CLASS_PRIEST       = 5  -- Sacerdote
local CLASS_DEATH_KNIGHT = 6  -- Cavaleiro da Morte
local CLASS_SHAMAN       = 7  -- Xamã
local CLASS_MAGE         = 8  -- Mago
local CLASS_WARLOCK      = 9  -- Bruxo
local CLASS_DRUID        = 11 -- Druida

-- Tabela de Nomes das Classes
local ClassName = {
    [CLASS_WARRIOR]      = "Guerreiro",
    [CLASS_PALADIN]      = "Paladino",
    [CLASS_HUNTER]       = "Caçador",
    [CLASS_ROGUE]        = "Ladrão",
    [CLASS_PRIEST]       = "Sacerdote",
    [CLASS_DEATH_KNIGHT] = "Cavaleiro da Morte",
    [CLASS_SHAMAN]       = "Xamã",
    [CLASS_MAGE]         = "Mago",
    [CLASS_WARLOCK]      = "Bruxo",
    [CLASS_DRUID]        = "Druida",
}

-- Função para Obter Informações do Jogador
local function GetPlayerInfo(player)
    local class = ClassName[player:GetClass()] or "? ? ?" -- Obtém a classe do jogador
    local name = player:GetName()                         -- Obtém o nome do jogador
    local team = ""                                       -- Inicializa a string da facção
    local teamType = player:GetTeam()                     -- Obtém o tipo de facção

    -- Define a cor e o nome da facção
    if teamType == TEAM_ALLIANCE then
        team = "|cFF0070d0Aliança|r"
    elseif teamType == TEAM_HORDE then
        team = "|cFFF000A0Horda|r"
    end

    -- Formata a mensagem com as informações do jogador
    return string.format("%s%s Jogador[|cFF00FF00|Hplayer:%s|h%s|h|r]", team, class, name, name)
end

-- Função para quando o Jogador Fizer o Primeiro Login
local function OnPlayerFirstLogin(event, player)
    SendWorldMessage("|cFFFF0000[Sistema]|r Bem-vindo(a) "..GetPlayerInfo(player).."! Você entrou pela primeira vez no |cFFFF0000Mundo de Azeroth.|r")
    print("Jogador criado. GUID:"..player:GetGUIDLow())
end

-- Função para quando o Jogador Fizer Login
local function OnPlayerLogin(event, player)
    SendWorldMessage("|cFFFF0000[Sistema]|r Bem-vindo(a) "..GetPlayerInfo(player).."! Você está online.")
    print("Jogador conectado. GUID:"..player:GetGUIDLow())
end

-- Função para quando o Jogador Fizer Logout
local function OnPlayerLogout(event, player)
    SendWorldMessage("|cFFFF0000[Sistema]|r "..GetPlayerInfo(player).." saiu do jogo.")
    print("Jogador desconectado. GUID:"..player:GetGUIDLow())
end

-- Registra os Eventos do Jogador
RegisterPlayerEvent(30, OnPlayerFirstLogin) -- Primeiro login
RegisterPlayerEvent(3, OnPlayerLogin)      -- Login
RegisterPlayerEvent(4, OnPlayerLogout)     -- Logout
