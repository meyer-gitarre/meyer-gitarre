module.exports =
class Page
  constructor: (@name, @path, @parent, @sections, @children) ->
    @sections ?= []
    @children ?= []

  directChild: (pname) ->
    page = child for child in @.children when child.name is pname

    if not page?
      console.error('no child for this name exists:')
      console.error(pname)
      process.exit(1)

    return page

  recursiveChild: (pnames) ->
    tmp = @
    tmp = tmp.directChild(pname) for pname in pnames
    return tmp

  @parsePage: (page, parent) ->
    parsedPage = new Page(page.name, page.path, parent, page.sections, [])

    if page.children?
      parsedPage.children.push(Page.parsePage(c, parsedPage)) for c in page.children

    return parsedPage

  @parse: (ms) ->
    menu = Page.parsePage(ms, null)

    return menu
