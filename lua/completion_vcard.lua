local M = {}

local function is_in_header()
    local line = vim.api.nvim_get_current_line()
    for _, header in pairs({ 'Bcc:', 'Cc:', 'From:', 'Reply-To:', 'To:' }) do
        if vim.startswith(line, header) then
            return true
        end
    end
    return false
end

local function get_contacts(vcard_directory)
    local contacts = {}
    local filenames = vim.fn.split(vim.fn.globpath(vcard_directory, '*.vcf'), '\n')
    for _, filename in pairs(filenames) do
        local name = nil
        local emails = {}
        for _, line in pairs(vim.fn.readfile(filename)) do
            if vim.startswith(line, 'FN:') then
                name = line:sub(4)
            elseif vim.startswith(line, 'N:') and name == nil then
                -- According to the vCard specification (source:
                -- https://datatracker.ietf.org/doc/html/rfc6350#section-6.2.2), the N identification property can be
                -- made up of up to 5 components, separated by semicolons.

                -- So it's easier to understand these steps, here's an example from the specification:
                -- N:Stevenson;John;Philip,Paul;Dr.;Jr.,M.D.,A.C.P.

                -- First, we separate these components.
                local components = vim.fn.split(line:sub(3), ';')
                -- If there are more than 1 of them, we use only the second and first parts, in that order because
                -- these correspond to the contact's first and last names.
                if #components > 1 then
                    components = {components[2], components[1]}
                end
                local joined_components = {}
                -- Again according to the specification, commas separate different parts of a component. So, we replace
                -- unescaped commas with spaces and remove the escape characters from commas.
                for _, component in ipairs(components) do
                    local joined_component = component:gsub('([^\\]),', '%1 '):gsub('([^\\])\\,', '%1,')
                    table.insert(joined_components, joined_component)
                end
                -- Finally, we join the components with spaces and remove any trailing whitespace in case one of the
                -- components was an empty string or ended with whitespace.
                name = vim.trim(table.concat(joined_components, ' '))
            elseif line:match('EMAIL') then
                table.insert(emails, line:match(':(.*)'))
            end
        end
        if name ~= nil then
            for _, email in pairs(emails) do
                table.insert(contacts, name .. ' <' .. email .. '>')
            end
        end
    end
    return contacts
end

function M.setup_completion(vcard_directory)
    local util = require('completion/util')
    local contacts = get_contacts(vcard_directory)
    function complete_vcard(prefix)
        local items = {}
        if is_in_header() then
            for _, contact in pairs(contacts) do
                local score = util.fuzzy_score(prefix, contact)
                if score < #prefix/3 or #prefix == 0 then
                    table.insert(items, {
                            word = contact,
                            kind = 'vCard',
                        })
                end
            end
        end
        return items
    end

    require('completion').addCompletionSource('vCard', { item = complete_vcard })
end

function M.setup_compe(vcard_directory)
    local compe = require('compe')
    local contacts = get_contacts(vcard_directory)

    local Source = {}

    function Source.get_metadata(_)
        return {
            menu = '[vCard]',
            priority = 100,
            filetypes = { 'mail' }
        }
    end

    function Source.determine(_, context)
        return compe.helper.determine(context)
    end

    function Source.complete(self, context)
        if is_in_header() then
            context.callback({ items = contacts })
        end
    end

    compe.register_source('vCard', Source)
end

return M
