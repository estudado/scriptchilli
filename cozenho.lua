--[====================================================================================
    SCRIPT DE VERIFICAÇÃO DE CHAVE - Este é o código que fica no seu link "raw"
======================================================================================]--

-- // CONFIGURAÇÕES \\ --
local URL_DA_API = "URL_DA_SUA_API_DO_GOOGLE_APPS_SCRIPT_AQUI"

-- // SERVIÇOS E VARIÁVEIS \\ --
-- Em ambientes de exploit, HttpGet já é uma função global de 'game'.
local HttpService = game:GetService("HttpService")
local JogadorLocal = game:GetService("Players").LocalPlayer

-- // LÓGICA DE VERIFICAÇÃO \\ --

-- 1. Tenta pegar a chave que o usuário definiu
-- A variável 'script_key' foi definida antes do loadstring, então ela existe neste ambiente.
local ChaveDoUsuario = script_key

if not ChaveDoUsuario then
    warn("ERRO: A variável 'script_key' não foi definida antes de executar o script.")
    return -- Para a execução
end

-- 2. Pega o HWID (usando o UserId do jogador, que é o método mais seguro)
local hwid = tostring(JogadorLocal.UserId)

-- 3. Monta a URL completa para a verificação
local urlCompleta = string.format("%s?key=%s&hwid=%s", URL_DA_API, ChaveDoUsuario, hwid)

print("Verificando sua chave, por favor aguarde...")

-- 4. Faz a requisição para a sua API de forma segura
local sucesso, resposta = pcall(function()
    local rawResponse = game:HttpGet(urlCompleta)
    return HttpService:JSONDecode(rawResponse)
end)

-- 5. Processa a resposta da API
if not sucesso then
    warn("Falha ao contatar o servidor de ativação. Verifique sua conexão ou tente mais tarde.")
    warn("Detalhes do erro: " .. tostring(resposta))
    return
end

if resposta and resposta.valid then
    -- SE A CHAVE FOR VÁLIDA, EXECUTA O SCRIPT PRINCIPAL
    print("✅ Chave válida! Bem-vindo.")
    Main() -- Chama a função principal do seu script
else
    -- SE A CHAVE FOR INVÁLIDA, MOSTRA O MOTIVO
    local motivo = resposta.reason or "desconhecido"
    warn("❌ A ativação falhou!")
    if motivo == "expired" then
        warn("Motivo: Sua chave expirou.")
    elseif motivo == "hwid_mismatch" then
        warn("Motivo: Esta chave já está sendo usada por outro usuário.")
    elseif motivo == "invalid_key" then
        warn("Motivo: A chave inserida é inválida.")
    else
        warn("Motivo: " .. motivo)
    end
    return -- Para a execução
end

--[====================================================================================
    SEU SCRIPT PRINCIPAL VEM AQUI DENTRO DA FUNÇÃO "Main"
======================================================================================]--

function Main()
    
--[[
	AVISO: Este script é para fins educacionais.
	A execução de scripts locais através de ferramentas de terceiros viola os Termos de Serviço do Roblox
	e pode resultar no banimento da sua conta. Você assume total responsabilidade pelos riscos.
--]]

-- Serviços necessários
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Variável para controlar se a função está ativa ou não
local isEnabled = false

-- Função para remover a aparência de um personagem
local function stripAppearance(character)
	-- Se a função estiver desativada, não faz nada
	if not isEnabled or not character then
		return
	end

	-- Espera o Humanoid para garantir que o personagem está totalmente carregado
	local humanoid = character:WaitForChild("Humanoid", 5)
	if not humanoid then return end

	-- Pausa rápida para garantir que todos os acessórios foram carregados
	wait(0.1)

	-- Percorre todos os filhos do modelo do personagem
	for _, item in pairs(character:GetChildren()) do
		if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then
			item:Destroy()
		end
	end
end

-- Função para processar todos os jogadores atualmente no servidor
local function processAllPlayers()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			stripAppearance(player.Character)
		end
	end
end

-- Função para ser conectada aos eventos de jogador
local function onCharacterAdded(character)
	stripAppearance(character)
end

local function onPlayerAdded(player)
	if player ~= localPlayer then
		player.CharacterAdded:Connect(onCharacterAdded)
	end
end

-- Conecta a função para jogadores que entrarem DEPOIS que o script rodar
Players.PlayerAdded:Connect(onPlayerAdded)

-- Conecta a função para os personagens dos jogadores que JÁ ESTÃO no jogo
for _, player in pairs(Players:GetPlayers()) do
	if player ~= localPlayer then
		if player.Character then
			-- Não remove a aparência imediatamente, apenas prepara o evento para o futuro
			player.CharacterAdded:Connect(onCharacterAdded)
		end
	end
end

-- Função para lidar com o pressionamento de teclas
local function onInputBegan(input, gameProcessed)
	-- Se o jogador estiver digitando em uma caixa de texto, ignora
	if gameProcessed then return end

	-- Verifica se a tecla pressionada foi "F"
	if input.KeyCode == Enum.KeyCode.F then
		-- Inverte o estado (se era true, vira false; se era false, vira true)
		isEnabled = not isEnabled

		if isEnabled then
			print("Função de remover aparência ATIVADA.")
			-- Quando ativado, processa todos os personagens que já existem
			processAllPlayers()
		else
			print("Função de remover aparência DESATIVADA. Personagens voltarão ao normal ao renascerem.")
			-- Quando desativado, os personagens já alterados não são restaurados
			-- Eles voltarão ao normal da próxima vez que renascerem, pois a função stripAppearance não será mais executada
		end
	end
end

-- Conecta a função ao evento de input do usuário
UserInputService.InputBegan:Connect(onInputBegan)

print("Script de remoção de aparência carregado. Pressione 'F' para ativar ou desativar.")
    
end
