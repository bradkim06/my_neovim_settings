local sniprun = {
    "michaelb/sniprun",
    branch = "master",
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65
    build = "sh install.sh",
}

sniprun.config = function()
    require("sniprun").setup({
        -- your options
    })
end

return sniprun
