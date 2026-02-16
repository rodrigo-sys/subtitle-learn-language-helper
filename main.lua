local utils = require 'mp.utils'
local input = require 'mp.input'
local html = require 'html'
local dictionary = require 'dictionary'

function main()
  local sub_text = mp.get_property("sub-text")

  local result = utils.subprocess({
    args = { "sh", "-c", "echo '" .. sub_text .. "' | sudachi -w -m c" },
    capture_stdout = true
  })

  local words = {}
  for word in string.gmatch(result.stdout, "[^%s]+") do
    table.insert(words, word)
  end

  input.select({
    items = words,
    submit = function(index)
      local word = words[index]

      mp.osd_message("Looking up: " .. word, 5)
      local def = dictionary.fetch_definition(word)

      if not def then
        mp.osd_message("No definition found")
        return
      end

      dictionary.showDefinition(def)
    end
  })
end

mp.add_key_binding("a", "select-subtitle-word", main)
