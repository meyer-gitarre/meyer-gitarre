// totally not pretty-printed, transpiled coffeescript!

// dom references
var aChords, addContent, cChords, controls, currentChord, dChords, data, eChords, extendedChords, handleFormClick, handleImageClick, hint, hintText, init, loadData, nextChord, normalChords, resetForm, solution, task, togglers,
  indexOf = [].indexOf;

task = null;

solution = null;

hint = null;

hintText = null;

controls = null;

togglers = null;

data = null;

normalChords = [];

extendedChords = [];

eChords = [];

aChords = [];

dChords = [];

cChords = [];

currentChord = null;

nextChord = true;

addContent = function() {
  var chordTool, key, scriptTag;
  task = document.createElement('div');
  task.id = 'task';
  task.innerHTML = 'Übung lädt noch';
  solution = document.createElement('img');
  solution.id = 'solution';
  solution.src = '/img/gtak/startakk.jpg';
  hint = document.createElement('div');
  hint.id = 'hint';
  hintText = document.createElement('em');
  hint.appendChild(hintText);
  controls = document.createElement('form');
  controls.id = 'controls';
  togglers = {
    normal: document.createElement('input'),
    extended: document.createElement('input'),
    e: document.createElement('input'),
    a: document.createElement('input'),
    d: document.createElement('input'),
    c: document.createElement('input')
  };
  togglers.normal.value = 'normal';
  togglers.extended.value = 'extended';
  togglers.e.value = 'basisE';
  togglers.a.value = 'basisA';
  togglers.d.value = 'basisD';
  togglers.c.value = 'basisC';
  for (key in togglers) {
    togglers[key].type = 'checkbox';
    togglers[key].name = 'chords';
    controls.appendChild(togglers[key]);
  }
  controls.insertBefore(document.createTextNode('Standard'), togglers.normal.nextSibling);
  controls.insertBefore(document.createTextNode('Standard erweitert'), togglers.extended.nextSibling);
  controls.insertBefore(document.createTextNode('Barré auf E-Basis'), togglers.e.nextSibling);
  controls.insertBefore(document.createTextNode('Barré auf A-Basis'), togglers.a.nextSibling);
  controls.insertBefore(document.createTextNode('Barré auf D-Basis'), togglers.d.nextSibling);
  controls.insertBefore(document.createTextNode('Barré auf C-Basis'), togglers.c.nextSibling);
  chordTool = document.createElement('div');
  chordTool.id = 'chordTool';
  chordTool.appendChild(task);
  chordTool.appendChild(solution);
  chordTool.appendChild(hint);
  chordTool.appendChild(controls);
  scriptTag = document.scripts[document.scripts.length - 1];
  return scriptTag.parentElement.insertBefore(chordTool, scriptTag.nextSibling);
};

handleFormClick = function() {
  var key, reset;
  reset = true;
  for (key in togglers) {
    if (togglers[key].checked) {
      reset = false;
    }
  }
  if (reset) {
    return resetForm();
  }
};

handleImageClick = function() {
  var chords, info, oldChord;
  nextChord = !nextChord;
  if (nextChord) {
    solution.src = `/img/gtak/${currentChord.imgFile}.jpg`;
    info = '';
    switch (currentChord.category) {
      case 'normal':
        info = '';
        break;
      case 'extended':
        info = '';
        break;
      case 'basisE':
        info = `Barré im ${currentChord.fret}. Bund.`;
        break;
      case 'basisA':
        info = `Barré im ${currentChord.fret}. Bund.`;
        break;
      case 'basisD':
        info = `Der Grundton auf der d-Saite ist im ${currentChord.fret}. Bund.`;
        break;
      case 'basisC':
        info = `Der Grundton auf der A-Saite ist im ${currentChord.fret}. Bund. Der Barré liegt im ${currentChord.fret - 3}. Bund.`;
    }
    task.innerHTML = `${currentChord.name}: ${info}`;
    return hintText.innerHTML = 'Klicke auf das Bild für einen neuen Akkord!';
  } else {
    chords = [];
    if (togglers.normal.checked) {
      Array.prototype.push.apply(chords, normalChords);
    }
    if (togglers.extended.checked) {
      Array.prototype.push.apply(chords, extendedChords);
    }
    if (togglers.e.checked) {
      Array.prototype.push.apply(chords, eChords);
    }
    if (togglers.a.checked) {
      Array.prototype.push.apply(chords, aChords);
    }
    if (togglers.d.checked) {
      Array.prototype.push.apply(chords, dChords);
    }
    if (togglers.c.checked) {
      Array.prototype.push.apply(chords, cChords);
    }
    oldChord = currentChord;
    while (oldChord === currentChord) {
      currentChord = chords[Math.floor(Math.random() * chords.length)];
    }
    solution.src = '/img/gtak/zwischenakk.jpg';
    task.innerHTML = `Greife ${currentChord.name}!`;
    return hintText.innerHTML = '';
  }
};

loadData = function() {
  var req;
  req = new XMLHttpRequest();
  req.addEventListener('readystatechange', function() {
    var chord, i, key, len, ref, ref1, successResultCodes;
    if (req.readyState === 4) {
      successResultCodes = [200, 304];
      if (ref = req.status, indexOf.call(successResultCodes, ref) >= 0) {
        ref1 = JSON.parse(req.responseText);
        for (i = 0, len = ref1.length; i < len; i++) {
          chord = ref1[i];
          switch (chord.category) {
            case 'normal':
              normalChords.push(chord);
              break;
            case 'extended':
              extendedChords.push(chord);
              break;
            case 'basisE':
              eChords.push(chord);
              break;
            case 'basisA':
              aChords.push(chord);
              break;
            case 'basisD':
              dChords.push(chord);
              break;
            case 'basisC':
              cChords.push(chord);
          }
        }
        solution.addEventListener('click', handleImageClick, false);
        for (key in togglers) {
          togglers[key].addEventListener('change', handleFormClick, false);
        }
        return task.innerHTML = 'Klicke auf das Bild, um eine zufällige Aufgabe gestellt zu bekommen.';
      } else {
        return task.innerHTML = 'Fehler beim AJAX-Request, Programm funktioniert nicht.';
      }
    }
  });
  req.open('GET', '/akkordetool/data.json');
  return req.send();
};

resetForm = function() {
  var key;
  for (key in togglers) {
    togglers[key].checked = false;
  }
  return togglers.normal.checked = true;
};

init = function() {
  addContent();
  loadData();
  return resetForm();
};

// On loading the page
init();
