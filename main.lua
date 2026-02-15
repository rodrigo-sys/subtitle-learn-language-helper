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
      mp.osd_message("Looking up: " .. word, 2)

      local def = dictionary.fetch_definition(word)

      if not def then
        print("No definition found")
        return
      end

      local script_dir = mp.get_script_directory()
      local viewer_path = script_dir .. "/viewer"

      if utils.file_info(viewer_path) then
        html.generate_html(def)
        mp.osd_message("Opening: " .. def.word, 1)
        utils.subprocess({
          args = { viewer_path }
        })
      else
        print("Viewer binary NOT found at: " .. viewer_path)
      end

    end
  })
end

mp.add_key_binding("a", "select-subtitle-word", main)
