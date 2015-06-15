util = require('util')

Page = require('./page')
menustructure = require('./menustructure')

getParentsInclusive = (p) ->
  parentsinc = []

  while p?
    parentsinc.unshift(p)
    p = p.parent

  return parentsinc

makeOrderedList = (clazz, entries) ->
  lis = ''
  lis += "<li>#{entry}</li>" for entry in entries
  if clazz?
    classattr = " class=\"#{clazz}\""
  else
    classattr = ''
  return "<ol#{classattr}>#{lis}</ol>"

print = (p = home) ->
  if p.parent?
    p.parent = p.parent.name
  console.log(util.inspect(p, false, null))

renderLink = (p) ->
  if p?
    "<a href=\"#{p.path}\">#{p.name}</a>"
  else
    ''

renderLinkParent = (p) ->
  if p.parent?
    renderLink(p.parent)
  else
    ''
renderLinkPreviousSibling = (p) ->
  if p.parent?
    prevSibling = sib for sib in p.parent.children when p.parent.children.indexOf(sib) + 1 is p.parent.children.indexOf(p)
    renderLink(prevSibling)
  else
    ''

renderLinkNextSibling = (p) ->
  if p.parent?
    prevSibling = sib for sib in p.parent.children when p.parent.children.indexOf(sib) - 1 is p.parent.children.indexOf(p)
    renderLink(prevSibling)
  else
    ''

renderLinkPreviousPage = (p) ->
  if p.parent?
    prevSibling = sib for sib in p.parent.children when p.parent.children.indexOf(sib) + 1 is p.parent.children.indexOf(p)
    if p?
      "<a href=\"#{p.path}\" class=\"prevPage\"></a>"
    else
      ''
  else
    ''

renderLinkNextPage = (p) ->
  if p.parent?
    prevSibling = sib for sib in p.parent.children when p.parent.children.indexOf(sib) - 1 is p.parent.children.indexOf(p)
    if p?
      "<a href=\"#{p.path}\" class=\"nextPage\"></a>"
    else
      ''
  else
    ''

renderSimpleBreadcrumbs = (p) ->
  entries = []
  entries.push(renderLink(page)) for page in getParentsInclusive(p)
  makeOrderedList('breadcrumbs', entries)

renderBreadcrumbs = (p) ->
  entries = []
  for page in getParentsInclusive(p)
    children = []
    children.push(renderLink(child)) for child in page.children
    entries.push(renderLink(page) + makeOrderedList(null, children))
  makeOrderedList('breadcrumbs', entries)

#ol mit Kindern als Einträgen, oder Sections falls keine Kinder
renderMenuEntry = (clazz, p) ->
  lis = []
  lis.push(renderLink(p))

  if p.children? and p.children.length > 0
    lis.push(renderMenuEntry(null, child)) for child in p.children
  else
    if p.sections?
      lis.push(renderLink(section)) for section in p.sections

  makeOrderedList(clazz, lis)

# ol class menu, erstes li link zu Seite selbst, dann komplett rekursiv Kinder. Wenn keine Kinder, dann Sections
renderMenuDefault = (p) ->
  renderMenuEntry('menu', p)

cmd = process.argv[2] ? 'print'

pagehierarchy = []
if process.argv.indexOf('-p') is 3
  pagehierarchy.push(p) for p in process.argv when process.argv.indexOf(p) > 3

home = Page.parse(menustructure)

page = home.recursiveChild(pagehierarchy)

switch cmd
  when 'print' then print(page)
  when 'link' then console.log(renderLink(page))
  when 'linkParent' then console.log(renderLinkParent(page))
  when 'linkPrev' then console.log(renderLinkPreviousSibling(page))
  when 'linkNext' then console.log(renderLinkNextSibling(page))
  when 'linkPrevPage' then console.log(renderLinkPreviousPage(page))
  when 'linkNextPage' then console.log(renderLinkNextPage(page))
  when 'breadcrumbsSimple' then console.log(renderSimpleBreadcrumbs(page))
  when 'breadcrumbs' then console.log(renderBreadcrumbs(page))
  when 'menu' then console.log(renderMenuDefault(page))
