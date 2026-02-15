local utils = require 'mp.utils'

function fetch_definition(word)
  local result = utils.subprocess({
    args = {"sh", "-c", "curl -s -G --data-urlencode 'keyword=" .. word .. "' 'https://jisho.org/api/v1/search/words'"},
    capture_stdout = true
  })

  local data = utils.parse_json(result.stdout)
  if not data or not data.data or #data.data == 0 then
    return nil
  end

  local entry = data.data[1]
  return {
    word = word,
    reading = entry.japanese[1].reading or word,
    part_of_speech = entry.senses[1].parts_of_speech[1] or "",
    definitions = entry.senses[1].english_definitions
  }
end

function print_definition(def)
  print(def.word .. " [" .. def.reading .. "]")
  print(def.part_of_speech)
  for i, def in ipairs(def.definitions) do
    print(i .. ". " .. def)
  end
end

return {
  fetch_definition = fetch_definition,
  print_definition = print_definition
}
