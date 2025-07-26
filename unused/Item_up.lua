### Código Corrigido e Traduzido:
```lua
--[[
Resumo: Script ELUNA para atualização de itens
Autor original: 5L
Modificado por: 烟雨江南 (Traduzido para português)
Agradecimentos: ayase, 愈
]]--
print(">>Script: Item_up loading...OK")

-- Configuração inicial
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
local ITEMID = 60007 -- ID do item usado para atualização (ex.: "Pedra de Atualização")
UP = {}

-- Função principal para exibir o menu de atualização
function Item_Up(event, player, item, target)
    -- Move o jogador ligeiramente para evitar bugs de posição
    player:MoveTo(0, player:GetX() + 0.01, player:GetY(), player:GetZ())
    
    -- Obtém o ID do item alvo
    local U = target:GetEntry()
    
    -- Consulta no banco de dados as informações de atualização para o item
    local Q = WorldDBQuery(string.format("SELECT id1, id2, amount, amount1, amount2, upid, chance, crazing, baoshi FROM item_up WHERE `id` = %d;", U))
    if not Q then
        player:SendBroadcastMessage("Este equipamento não pode ser atualizado.")
        player:SendAreaTriggerMessage("Este equipamento não pode ser atualizado.")
        return
    end

    -- Armazena os dados da consulta em uma tabela
    UP[U] = {
        upid    = Q:GetString(5),  -- ID do item após a atualização
        amount  = Q:GetString(2),  -- Quantidade do item original necessária
        chance  = Q:GetString(6),  -- Chance de sucesso (%)
        crazing = Q:GetString(7),  -- Se o item quebra ao falhar: 0 = não, 1 = sim
        id1     = Q:GetString(0),  -- ID do primeiro material necessário
        amount1 = Q:GetString(3),  -- Quantidade do primeiro material necessário
        id2     = Q:GetString(1),  -- ID do segundo material necessário
        amount2 = Q:GetString(4),  -- Quantidade do segundo material necessário
        baoshi  = Q:GetString(8)   -- ID da "Pedra da Sorte" (opcional)
    }

    -- Limpa o menu de interação e adiciona opções
    player:GossipClearMenu()
    player:GossipMenuAddItem(1, "|TInterface\\ICONS\\Tradeskill_Inscription_JadeSerpent.blp:30|t Materiais necessários: " .. GetItemLink(U) .. " × " .. UP[U].amount, 0, 99)
    
    if tonumber(UP[U].id1) > 0 and tonumber(UP[U].amount1) > 0 then
        player:GossipMenuAddItem(1, "|TInterface\\ICONS\\Tradeskill_Inscription_RedCrane.blp:30|t Materiais necessários: " .. GetItemLink(UP[U].id1) .. " × " .. UP[U].amount1, 0, 99)
    end
    
    if tonumber(UP[U].id2) > 0 and tonumber(UP[U].amount2) > 0 then
        player:GossipMenuAddItem(1, "|TInterface\\ICONS\\Tradeskill_Inscription_BlackOx.blp:30|t Materiais necessários: " .. GetItemLink(UP[U].id2) .. " × " .. UP[U].amount2, 0, 99)
    end
    
    player:GossipMenuAddItem(1, "|TInterface\\ICONS\\Spell_Priest_Chakra.blp:30|t Equipamento após atualização: " .. GetItemLink(UP[U].upid), 0, 99)
    player:GossipMenuAddItem(1, "|TInterface\\ICONS\\Spell_Priest_VowofUnity.blp:30|t Chance de sucesso: " .. UP[U].chance .. "%", 0, 99)
    
    if tonumber(UP[U].crazing) == 0 then
        player:GossipMenuAddItem(1, "|TInterface\\ICONS\\INV_Ingot_Trillium.blp:30|t Não quebra em caso de falha", 0, 99)
    elseif tonumber(UP[U].crazing) == 1 then
        player:GossipMenuAddItem(1, "|TInterface\\ICONS\\INV_Ingot_Titansteel_red.blp:30|t Quebra em caso de falha", 0, 99)
    end
    
    player:GossipMenuAddItem(1, "|TInterface\\ICONS\\Spell_Holy_HopeAndGrace.blp:40|t |CFFFF1100Confirmar atualização|R", 1, 1)
    player:GossipSendMenu(1, item)
end

-- Função para processar a seleção do jogador
function Item_Select(event, player, object, sender, intid, code, menu_id)
    if intid == 1 then
        -- Gera um número aleatório para verificar a chance de sucesso
        local ChanceUp = math.random(0, 100)
        
        -- Verifica se o jogador possui os materiais necessários
        if player:HasItem(U, tonumber(UP[U].amount)) and 
           (tonumber(UP[U].id1) == 0 or tonumber(UP[U].amount1) == 0 or player:HasItem(tonumber(UP[U].id1), tonumber(UP[U].amount1))) and 
           (tonumber(UP[U].id2) == 0 or tonumber(UP[U].amount2) == 0 or player:HasItem(tonumber(UP[U].id2), tonumber(UP[U].amount2))) then
            
            -- Remove os materiais necessários
            if tonumber(UP[U].id1) > 0 and tonumber(UP[U].amount1) > 0 then
                player:RemoveItem(UP[U].id1, UP[U].amount1)
            end
            if tonumber(UP[U].id2) > 0 and tonumber(UP[U].amount2) > 0 then
                player:RemoveItem(UP[U].id2, UP[U].amount2)
            end
            
            -- Verifica se a atualização foi bem-sucedida
            if tonumber(UP[U].chance) >= ChanceUp then
                -- Remove a "Pedra da Sorte" se usada
                if player:HasItem(tonumber(UP[U].baoshi), 1) then
                    player:RemoveItem(tonumber(UP[U].baoshi), 1)
                end
                
                -- Remove o item antigo e adiciona o novo
                player:RemoveItem(U, UP[U].amount)
                player:AddItem(UP[U].upid, 1)
                player:SendBroadcastMessage("|CFFFF0000Atualização bem-sucedida!!|R")
                player:SendAreaTriggerMessage("|CFFFF0000Atualização bem-sucedida!!|R")
            else
                -- Caso falhe, verifica se o item quebra ou se a "Pedra da Sorte" protege
                if tonumber(UP[U].crazing) == 0 then
                    player:SendBroadcastMessage("|CFFFF0000Atualização falhou!!|R")
                    player:SendAreaTriggerMessage("|CFFFF0000Atualização falhou!!|R")
                elseif player:HasItem(tonumber(UP[U].baoshi), 1) then
                    player:RemoveItem(tonumber(UP[U].baoshi), 1)
                    player:SendBroadcastMessage("|CFFFF0000Atualização falhou! A Pedra da Sorte quebrou e evitou a destruição do item!!|R")
                    player:SendAreaTriggerMessage("|CFFFF0000Atualização falhou! A Pedra da Sorte quebrou e evitou a destruição do item!!|R")
                else
                    player:RemoveItem(U, UP[U].amount)
                    player:SendBroadcastMessage("|CFFFF0000Atualização falhou! O item foi destruído!!|R")
                    player:SendAreaTriggerMessage("|CFFFF0000Atualização falhou! O item foi destruído!!|R")
                end
            end
        else
            -- Mensagem de erro se faltarem materiais
            player:SendBroadcastMessage("|CFFFF0000Equipamento ou materiais insuficientes|R")
            player:SendAreaTriggerMessage("|CFFFF0000Equipamento ou materiais insuficientes|R")
        end
        
        -- Finaliza o menu de interação
        player:GossipComplete()
    elseif intid == 99 then
        player:SendBroadcastMessage("|CFFFF0000Por favor, clique no botão 'Confirmar Atualização'!!!|R")
        player:SendAreaTriggerMessage("|CFFFF0000Por favor, clique no botão 'Confirmar Atualização'!!!|R")
        player:GossipComplete()
    end
end

-- Registra os eventos do item
RegisterItemEvent(ITEMID, 2, Item_Up)
RegisterItemGossipEvent(ITEMID, 2, Item_Select)
