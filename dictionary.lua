local utils = require 'mp.utils'

function fetch_definition(word)
  local result = utils.subprocess({
    args = { "sh", "-c", "curl -s -G --data-urlencode 'keyword=" .. word .. "' 'https://jisho.org/api/v1/search/words'" },
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

function showDefinition(def)
  showDefinitionWebView(def)
end

function showDefinitionPrint(def)
  print(def.word .. " [" .. def.reading .. "]")
  print(def.part_of_speech)
  for i, def in ipairs(def.definitions) do
    print(i .. ". " .. def)
  end
end

function showDefinitionOsd(def)
  local msg = def.word .. " [" .. def.reading .. "]\n" .. def.part_of_speech .. "\n"
  for i, meaning in ipairs(def.definitions) do
    msg = msg .. i .. ". " .. meaning .. "\n"
  end
  mp.osd_message(msg, 10)
end

function showDefinitionWebView(def)
  local html = require 'html'
  local script_dir = mp.get_script_directory()
  local viewer_path = script_dir .. "/viewer"

  if utils.file_info(viewer_path) then
    html.generate_html(def)
    utils.subprocess({
      args = { viewer_path }
    })
  else
    print("Viewer binary NOT found at: " .. viewer_path)
  end
end

return {
  fetch_definition = fetch_definition,
  showDefinition = showDefinition,
  showDefinitionOsd = showDefinitionOsd
}
