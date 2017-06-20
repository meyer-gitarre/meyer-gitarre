cson = require 'cson'

Page = require('./menustructure/page')

module.exports = helper = {}

home = Page.parse cson.parseCSONFile('./menustructure.cson').menustructure

getPage = (pageHierarchy) ->
  if not pageHierarchy?
    return home
  else
    return home.recursiveChild pageHierarchy

getParentsInclusive = (p) ->
  parentsinc = []

  while p isnt null
    parentsinc.unshift p
    p = p.parent

  return parentsinc

renderLink = (p, clazz) ->
  if p?
    if clazz
      return "<a class=\"#{clazz}\" href=\"#{p.path}\"></a>"
    else
      return "<a href=\"#{p.path}\">#{p.name}</a>"
  else
    return ''

makeOrderedList = (clazz, entries) ->
  return '' if entries.length is 0

  lis = ''

  lis += "<li>#{entry}</li>" for entry in entries

  if clazz?
    classattr = " class=\"#{clazz}\""
  else
    classattr = ''

  return "<ol#{classattr}>#{lis}</ol>"

renderMenuEntry = (clazz, p) ->
  lis = []

  if p.children? and p.children.length > 0
    lis.push renderMenuEntry(null, child) for child in p.children
  else
    if p.sections? and p.sections.length > 0
      lis.push renderMenuEntry(null, section) for section in p.sections

  return "#{renderLink(p)}#{makeOrderedList(clazz, lis)}"

renderImportants = (p) ->
  importants = []

  # Bei Home Seite sind die importants gehardcoded.
  unless p.parent?
    homeImps = [
      name: "Stichworte"
      path: "/gitarre/index.html#stichwortverzeichnisgitarre"
      sections: [
        name: "Gitarre"
        path: "/gitarre/index.html#stichwortverzeichnisgitarre"
      ,
        name: "Musiklehre"
        path: "/musiklehre/index.html#stichwortverzeichnismusik"
      ,
        name: "Blockflöte"
        path: "/blockfloete/index.html#stichwortverzeichnisbfl"
      ],
    ,
      name: "Musikschultermine"
      path: "/musiklehre/musik-text/musikschule/index.html#termine"
    ]
    for homeImp in homeImps
      importants.unshift renderMenuEntry(null, homeImp)

  for page in getParentsInclusive p
    if page.important? and page.important.length > 0
      for imp in page.important
        if renderMenuEntry null, imp not in importants
          flag = true

          flag = false if p.name is imp.name
          flag = false for child in p.children when child.name is imp.name

          importants.unshift renderMenuEntry(null, imp) if flag

  if importants.length is 0
    return ''
  else
    return makeOrderedList('important', importants)

helper.renderBreadcrumbs = (menuStructure) ->
  entries = []

  for page in getParentsInclusive getPage(menuStructure)
    children = []
    children.push renderLink(child) for child in page.children
    entries.push "#{renderLink page}#{makeOrderedList null, children}"

  return makeOrderedList 'breadcrumbs', entries

helper.renderMenuDefault = (menuStructure) ->
  p = getPage menuStructure
  return "<div class=\"menu\">#{renderMenuEntry(null, p)}\
    #{renderImportants(p)}</div>"

helper.renderSitemap = () ->
  return "<div id=\"sitemap\" class=\"clearfix\"><div>#{renderMenuEntry(null, getPage ['Gitarre'])}</div><div>#{renderMenuEntry(null, getPage ['Musiklehre'])}</div><div>#{renderMenuEntry(null, getPage ['Blockflöte'])}</div></div>"

helper.renderLinkPreviousPage = (menuStructure) ->
  p = getPage menuStructure

  if not menuStructure?
    menuStructure = []

  threshold = if (menuStructure[0] is 'Blockflöte') then 1 else 2

  if menuStructure.length > threshold
    prevSibling = sib for sib in p.parent.children when p.
    parent.children.indexOf(sib) + 1 is p.parent.children.indexOf(p)
    if prevSibling?
      return renderLink prevSibling, 'prevPage'
    else
      return renderLink p.parent, 'prevPage'

  return ''


helper.renderLinkNextPage = (menuStructure) ->
  p = getPage menuStructure

  if not menuStructure?
    menuStructure = []

  threshold = if (menuStructure[0] is 'Blockflöte') then 1 else 2

  if menuStructure.length is threshold
    if p.children? and p.children.length > 0
      return renderLink p.children[0], 'nextPage'

  if menuStructure.length > threshold
    nextSibling = sib for sib in p.parent.children when p.
    parent.children.indexOf(sib) - 1 is p.parent.children.indexOf(p)
    if nextSibling?
      return renderLink nextSibling, 'nextPage'
    else
      return renderLink p.parent, 'nextPage'

  return ''
