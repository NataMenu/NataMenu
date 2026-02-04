-- NataMenu | Loader Oficial

if getgenv().NataMenuLoaded then
    warn("[NataMenu] Loader já executado.")
    return
end
getgenv().NataMenuLoaded = true

-- Aguarda o jogo carregar
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Config
local CONFIG = {
    Name = "NataMenu",
    Version = "1.0",
    MainURL = "https://raw.githubusercontent.com/NataMenu/NataMenu/main/main.lua"
}

-- Banner
print("╔════════════════════════════════╗")
print("║        "..CONFIG.Name.." v"..CONFIG.Version.."        ║")
print("║        Loader iniciado         ║")
print("╚════════════════════════════════╝")

-- Load protegido
local success, err = pcall(function()
    loadstring(game:HttpGet(CONFIG.MainURL, true))()
end)

if success then
    print("[NataMenu] Menu carregado com sucesso!")
else
    warn("[NataMenu] Erro ao carregar o menu:")
    warn(err)
end
