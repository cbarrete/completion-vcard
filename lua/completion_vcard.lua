M = {}

local function is_in_header()
    local line = vim.api.nvim_get_current_line()
    for _, needle in pairs({ 'Bcc', 'Cc', 'From', 'Reply-To', 'To' }) do
        if vim.startswith(line, needle .. ':') then
            return true
        end
    end
    return false
end

function M.setup(vcard_directory)
    local contacts = {}
    local filenames = vim.fn.split(vim.fn.globpath(vcard_directory, '*.vcf'), '\n')
    for _, filename in pairs(filenames) do
        local name = nil
        local emails = {}
        for _, line in pairs(vim.fn.readfile(filename)) do
            if vim.startswith(line, 'FN:') then
                name = line:sub(4)
            end
            if line:match('EMAIL') then
                table.insert(emails, line:match(':(.*)'))
            end
        end
        for _, email in pairs(emails) do
            table.insert(contacts, name .. ' <' .. email .. '>')
        end
    end

    function complete_vcard(prefix, score_func)
        local items = {}
        for _, contact in pairs(contacts) do
            if vim.startswith(contact:lower(), prefix:lower()) and is_in_header()  then
                table.insert(items, {
                  word = contact,
                  kind = 'vCard',
                })
            end
        end
        return items
    end

    require('completion').addCompletionSource('vCard', { item = complete_vcard })
end


return M