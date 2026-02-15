local utils = require 'mp.utils'

function main()
  local sub_text = mp.get_property("sub-text")

  local result = utils.subprocess({
    args = {"sh", "-c", "echo '" .. sub_text .. "' | sudachi -w -m c"},
    capture_stdout = true
  })

  local words = {}
  for word in string.gmatch(result.stdout, "[^%s]+") do
    table.insert(words, word)
  end
end

mp.add_key_binding("a", "print-sub", main)
