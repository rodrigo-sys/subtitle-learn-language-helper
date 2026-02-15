local utils = require 'mp.utils'

function generate_html(def)
  local html = [[
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: "Helvetica Neue", Arial, sans-serif; padding: 20px; background: #fff; }
    .word { font-size: 28px; font-weight: bold; margin-bottom: 4px; }
    .reading { font-size: 18px; color: #666; margin-bottom: 8px; }
    .pos { font-size: 14px; color: #2a6; font-style: italic; margin-bottom: 12px; }
    .definitions { list-style: decimal; padding-left: 20px; }
    .definitions li { margin-bottom: 6px; }
  </style>
</head>
<body>
  <div class="word">]] .. def.word .. [[</div>
  <div class="reading">]] .. def.reading .. [[</div>
  <div class="pos">]] .. def.part_of_speech .. [[</div>
  <ol class="definitions">
]]

  for i, meaning in ipairs(def.definitions) do
    html = html .. "    <li>" .. meaning .. "</li>\n"
  end

  html = html .. [[
  </ol>
</body>
</html>
]]

  local file = io.open("/tmp/definition.html", "w")
  file:write(html)
  file:close()
end

return {
  generate_html = generate_html
}
