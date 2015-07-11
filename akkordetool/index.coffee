# dom references
task = null
solution = null
hint = null
controls = null

togglers = null

data = null

normalChords = []
eChords = []
aChords = []
dChords = []
cChords = []

currentChord = null
nextChord = true

addContent = ->
  task = document.createElement('div')
  task.id = 'task'
  task.innerHTML = 'Übung lädt noch'

  solution = document.createElement('img')
  solution.id = 'solution'
  solution.src = 'img/startakk.jpg'

  hint = document.createElement('div')
  hint.id = 'hint'

  controls = document.createElement('form')
  controls.id = 'controls'
  togglers =
    normal: document.createElement('input')
    e: document.createElement('input')
    a: document.createElement('input')
    d: document.createElement('input')
    c: document.createElement('input')
  togglers.normal.value = 'normal'
  togglers.e.value = 'basisE'
  togglers.a.value = 'basisA'
  togglers.d.value = 'basisD'
  togglers.c.value = 'basisC'
  for key of togglers
    togglers[key].type = 'checkbox'
    togglers[key].name = 'chords'
    controls.appendChild togglers[key]

  chordTool = document.createElement('div')
  chordTool.id = 'chordTool'
  chordTool.appendChild task
  chordTool.appendChild solution
  chordTool.appendChild hint
  chordTool.appendChild controls

  scriptTag = document.scripts[document.scripts.length - 1]
  scriptTag.parentElement.insertBefore(chordTool, scriptTag.nextSibling)

handleFormClick = ->
  reset = true
  for key of togglers
    if togglers[key].checked
      reset = false
  if reset
    resetForm()

handleImageClick = ->
  nextChord = not nextChord

  if nextChord
    solution.src = "img/#{currentChord.imgFile}.jpg"

    info = ''

    switch currentChord.category
      when 'normal' then info = ''
      when 'basisE' then info = "Barré im #{currentChord.fret}. Bund."
      when 'basisA' then info = "Barré im #{currentChord.fret}. Bund."
      when 'basisD' then info = "Der Grundton auf der d-Saite ist
      im #{currentChord.fret}. Bund."
      when 'basisC' then info = "Der Grundton auf der A-Saite ist
      im #{currentChord.fret}. Bund.
      Der Barré liegt im #{currentChord.fret - 3}. Bund."

    task.innerHTML = "#{currentChord.name}: #{info}"
    hint.innerHTML = 'Klicke auf das Bild für einen neuen Akkord!'
  else
    chords = []
    if togglers.normal.checked
      Array::push.apply chords, normalChords
    if togglers.e.checked
      Array::push.apply chords, eChords
    if togglers.a.checked
      Array::push.apply chords, aChords
    if togglers.d.checked
      Array::push.apply chords, dChords
    if togglers.c.checked
      Array::push.apply chords, cChords

    oldChord = currentChord

    while oldChord is currentChord
      currentChord = chords[Math.floor(Math.random() * chords.length)]

    solution.src = 'img/zwischenakk.jpg'
    task.innerHTML = "Greife #{currentChord.name}!"
    hint.innerHTML = ''

loadData = ->
  req = new XMLHttpRequest()

  req.addEventListener 'readystatechange', ->
    if req.readyState is 4
      successResultCodes = [200, 304]
      if req.status in successResultCodes
        for chord in JSON.parse req.responseText
          switch chord.category
            when 'normal' then normalChords.push chord
            when 'basisE' then eChords.push chord
            when 'basisA' then aChords.push chord
            when 'basisD' then dChords.push chord
            when 'basisC' then cChords.push chord

        solution.addEventListener 'click', handleImageClick, false

        for key of togglers
          togglers[key].addEventListener 'change', handleFormClick, false

        task.innerHTML = 'Klicke auf das Bild,
        um eine Aufgabe gestellt zu bekommen.'
      else
        task.innerHTML = 'Fehler beim AJAX-Request,
        Programm funktioniert nicht.'

  req.open 'GET', '/akkordetool/data.json'
  req.send()

resetForm = ->
  for key of togglers
    togglers[key].checked = false
  togglers.normal.checked = true

init = ->
  addContent()
  loadData()
  resetForm()

# On loading the page
init()
