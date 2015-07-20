module.exports = (menuStructure) ->
  html = '<ul>'
  html += '<li><a href="/index.html">Home</a></li>'

  if menuStructure?
    ancestor = menuStructure[0]
  else
    ancestor = 'default'

  switch ancestor
    when 'Blockflöte'
      html += '<li><a href="/blockfloete/index.html">Blockflöte</a></li>'
      html += '<li><a href="/blockfloete/index.html#stichwortverzeichnisbfl">\
        Stichworte</a></li>'
    when 'Musiklehre'
      html += '<li><a href="/musiklehre/index.html">Musiklehre</a></li>'
      html += '<li><a href="/musiklehre/index.html#stichwortverzeichnismusik">\
        Stichworte</a></li>'
    when 'Gitarre'
      html += '<li><a href="/gitarre/index.html">Gitarre</a></li>'
      html += '<li><a href="/gitarre/index.html#stichwortverzeichnisgitarre">\
        Stichworte</a></li>'
    else
      html += '<li><a href="/gitarre/index.html">Gitarre</a></li>'
      html += '<li><a href="/musiklehre/index.html">Musiklehre</a></li>'
      html += '<li><a href="/blockfloete/index.html">Blockflöte</a></li>'
      html += '<li><a href="/meta/sitemap/index.html">Sitemap</a></li>'

  html += '</ul>'
  return html
