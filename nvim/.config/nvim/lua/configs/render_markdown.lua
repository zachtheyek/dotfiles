return {
    -- Enable markdown rendering
    enabled = true,

    -- File types to enable render-markdown on
    file_types = { "markdown" },

    -- Rendering style
    render_modes = true,

    -- Anti-conceal settings to prevent hiding syntax when cursor is on line
    anti_conceal = {
        enabled = true,
    },

    -- Heading settings
    heading = {
        -- Enable heading icons/styling
        enabled = true,
        -- Sign column icons (optional)
        sign = true,
        -- Icons for each heading level
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },

    -- Code block settings
    code = {
        -- Enable code block rendering
        enabled = true,
        -- Sign column indicator
        sign = true,
        -- Style: 'full', 'normal', 'language', or 'none'
        style = "full",
        -- Left padding
        left_pad = 0,
        -- Right padding
        right_pad = 0,
    },

    -- Bullet point settings
    bullet = {
        -- Enable bullet rendering
        enabled = true,
        -- Icons for different list levels
        icons = { "●", "○", "◆", "◇" },
    },

    -- Checkbox settings
    checkbox = {
        -- Enable checkbox rendering
        enabled = true,
        -- Unchecked icon
        unchecked = { icon = "󰄱 " },
        -- Checked icon
        checked = { icon = "󰱒 " },
    },

    -- Quote block settings
    quote = {
        enabled = true,
        icon = "▋",
    },

    -- Pipe table settings
    pipe_table = {
        enabled = true,
        style = "full",
    },

    -- Callout settings (GitHub-style alerts)
    callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
    },

    -- Link settings
    link = {
        enabled = true,
        -- Render link icon before hyperlinks
        icon = "󰌹 ",
    },

    -- LaTeX math rendering
    latex = {
        enabled = true,
        -- Converters: tries in order, uses first available
        -- 'utftex' (requires libtexprintf) - C-based, unicode-art style
        -- 'latex2text' (requires pylatexenc) - Python-based, unicode symbols
        converter = { "utftex", "latex2text" },
        -- Positioning: 'above', 'below', or 'center'
        position = "center",
        highlight = "RenderMarkdownMath",
    },

    -- HTML support (primarily for comment concealing)
    html = {
        enabled = true,
        comment = {
            -- Conceal HTML comments
            conceal = true,
        },
    },
}
