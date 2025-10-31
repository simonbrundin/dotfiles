-- Skapar en till punkt i en befiltlig punktlista
return {
  "dkarter/bullets.vim",
  -- Optional: Lägg till konfiguration om du vill anpassa pluginen
  config = function()
    -- Exempel på konfiguration
    vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
  end,
}
