module MenuHelper
  class Section
    def initialize(name, path)
      @name = name
      @path = path
    end

    def name
        return @name
    end

    def path
      return @path
    end

    def parent
      return nil
    end

    def important
      return nil
    end
  end

  # A page on the website
  class Page
    def initialize(name, path, parent, sections = [], children = [], important = [])
      @name = name
      @path = path
      @parent = parent
      @sections = sections
      @children = children
      @important = important
    end

    def name
        return @name
    end

    def path
      return @path
    end

    def parent
      return @parent
    end

    def sections
      return @sections
    end

    def children
      return @children
    end

    def important
      return @important
    end

    def directChild(pname)
      page = nil

      for child in @children
        if child.name == pname
          page = child
        end
      end

      if page == nil
        raise "Given Pagehierarchy does not match menustructure: #{pname}"
      end

      return page
    end

    def recursiveChild(pnames)
      tmp = self

      for pname in pnames
        tmp = tmp.directChild(pname)
      end

      return tmp
    end

    def self.parsePage(page, parent)
      parsedPage = Page.new(page['name'], page['path'], parent, [], [], [])

      if page['sections'] != nil
        for s in page['sections']
          parsedPage.sections().push(Section.new(s['name'], s['path']))
        end
      end

      if page['children'] != nil
        for c in page['children']
          parsedPage.children().push(Page.parsePage(c, parsedPage))
        end
      end

      if page['important'] != nil
        for i in page['important']
          parsedPage.important().push(Page.parsePage(i, parsedPage))
        end
      end

      return parsedPage
    end

    def self.parse(ms)
      menu = Page.parsePage(ms, nil)
      return menu
    end
  end

  def getParentsInclusive(p)
    parentsinc = []

    while p != nil
      parentsinc.insert(0, p)
      p = p.parent
    end

    return parentsinc
  end

  def makeOrderedList(clazz, entries)
    if entries.length == 0
      return ''
    end

    lis = ''

    for entry in entries
      lis += "<li>#{entry}</li>"
    end
    if clazz != nil
      classattr = " class=\"#{clazz}\""
    else
      classattr = ''
    end

    return "<ol#{classattr}>#{lis}</ol>"
  end

  def renderLink(p)
    if p != nil
      return "<a href=\"#{p.path}\">#{p.name}</a>"
    else
      return ''
    end
  end

  def renderLinkParent(p)
    if p.parent != nil
      return renderLink(p.parent)
    else
      return ''
    end
  end

  def renderLinkPreviousSibling(p)
    if p.parent != nil
      prevSibling = nil
      for sib in p.parent.children
        if (p.parent.children.index(sib) + 1) == (p.parent.children.index(p))
          prevSibling = sib
        end
      end
      return renderLink(prevSibling)
    else
      return ''
    end
  end

  def renderLinkNextSibling(p)
    if p.parent != nil
      nextSibling = nil
      for sib in p.parent.children
        if (p.parent.children.index(sib) - 1) == (p.parent.children.index(p))
          nextSibling = sib
        end
      end
      return renderLink(nextSibling)
    else
      return ''
    end
  end

  def renderLinkPreviousPage(p)
    if p.parent != nil
      prevSibling = nil
      for sib in p.parent.children
        if (p.parent.children.index(sib) + 1) == (p.parent.children.index(p))
          prevSibling = sib
        end
      end
      if prevSibling != nil
        return "<a href=\"#{prevSibling.path}\" class=\"prevPage\"></a>"
      else
        return ''
      end
    else
      return ''
    end
  end

  def renderLinkNextPage(p)
    if p.parent != nil
      nextSibling = nil
      for sib in p.parent.children
        if (p.parent.children.index(sib) - 1) == (p.parent.children.index(p))
          nextSibling = sib
        end
      end
      if nextSibling != nil
        return "<a href=\"#{nextSibling.path}\" class=\"nextPage\"></a>"
      else
        return ''
      end
    else
      return ''
    end
  end

  def renderSimpleBreadcrumbs(p)
    entries = []

    for page in getParentsInclusive(p)
      entries.push(renderLink(page))
    end

    return makeOrderedList('breadcrumbs', entries)
  end

  def renderBreadcrumbs(p)
    entries = []

    for page in getParentsInclusive(p)
      children = []

      for child in page.children
        children.push(renderLink(child))
      end

      entries.push(renderLink(page) + makeOrderedList(nil, children))
    end

    return makeOrderedList('breadcrumbs', entries)
  end

  def renderMenuEntry(clazz, p, ignoreImportant = false, isImportant = false)
    lis = []

    if defined?(p.children) && p.children.length > 0
      for child in p.children
        lis.push(renderMenuEntry(nil, child, ignoreImportant))
      end
    else
      if defined?(p.sections) && p.sections.length > 0
        for section in p.sections
          lis.push(renderMenuEntry(nil, section, ignoreImportant))
        end
      end
    end

    importants = []
    for page in getParentsInclusive(p)
      if (page.important != nil) && page.important.length > 0
        for imp in page.important
          importants.insert(0, imp)
        end
      end
    end

    if !ignoreImportant
      for i in importants
        flag = true

        for li in lis
            if li['name'] == i.name
              flag = false
            end
        end

        if flag
            lis.push(renderMenuEntry('important', i, true, true))
        end
      end
    end

    if isImportant
        return "<a href=\"#{p.path}\" class=\"important\">#{p.name}</a>#{makeOrderedList(clazz, lis)}"
    end

    return "#{renderLink(p)}#{makeOrderedList(clazz, lis)}"
  end

  def renderMenuDefault(p)
    return "<div class=\"menu\">#{renderMenuEntry(nil, p)}</div>"
  end

  require 'json'

  # The structure of the menu
  @@home = Page.parse(JSON.parse(File.read('menustructure.json')))

  # Return the correct Page instance from the given pagehierarchy,
  # which is an array of page name, e.g. ['Blockflöte', 'Behandlung']
  def getPage(pageHierarchy)
    if pageHierarchy == nil
      return @@home
    end
    return @@home.recursiveChild(pageHierarchy)
  end
end
