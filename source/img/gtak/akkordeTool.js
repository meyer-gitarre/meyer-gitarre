//These arrays hold the chords defined in the JSON file
var normalChords = [];
var eChords = [];
var aChords = [];
var dChords = [];
var cChords = [];

//The checkboxes
var normalBox = document.getElementById("normalChords");
var eBox = document.getElementById("eChords");
var aBox = document.getElementById("aChords");
var dBox = document.getElementById("dChords");
var cBox = document.getElementById("cChords");

var currentChord;
var nextChord = true;

//on loading the page
loadChordsFromPseudoJSON();
resetForm();

function loadChordsFromPseudoJSON(){
        for (i = 0; i < allChordsArray.length; i++) {
                var chord = allChordsArray[i];
                if (chord.category === "normal") {
                        normalChords.splice(0, 0, chord);
                } else if (chord.category === "basisE") {
                        eChords.splice(0, 0, chord);
                } else if (chord.category === "basisA") {
                        aChords.splice(0, 0, chord);
                } else if (chord.category === "basisD") {
                        dChords.splice(0, 0, chord);
                } else if (chord.category === "basisC") {
                        cChords.splice(0, 0, chord);
                }
        }
}

function handleImageClick() {
        nextChord = !nextChord;

        if (!nextChord) {
                //set currentChord
                var chords = [];
                if (normalBox.checked) {
                        for (i = 0; i < normalChords.length; i++) {chords.splice(0, 0, normalChords[i]);}
                }
                if (eBox.checked) {
                        for (i = 0; i < eChords.length; i++) {chords.splice(0, 0, eChords[i]);}
                }
                if (aBox.checked) {
                        for (i = 0; i < aChords.length; i++) {chords.splice(0, 0, aChords[i]);}
                }
                if (dBox.checked) {
                        for (i = 0; i < dChords.length; i++) {chords.splice(0, 0, dChords[i]);}
                }
                if (cBox.checked) {
                        for (i = 0; i < cChords.length; i++) {chords.splice(0, 0, cChords[i]);}
                }
                var oldChord = currentChord;
                while (currentChord === oldChord){
                        currentChord = chords[Math.floor(Math.random() * chords.length)];
                }
        }

        if (!nextChord) {
                changeImage("zwischenakk");
                changeText(" <br /><b>Greife " + currentChord.name + "!</b>");
        } else {
                changeImage(currentChord.imgFile);
                var text = "";
                text += "<b>" + currentChord.name + ": ";
                if (currentChord.category === "basisE" || currentChord.category === "basisA") {text += "Barré im " + currentChord.fret + ". Bund."}
                if (currentChord.category === "basisD") {text += "Der Grundton auf der d-Saite ist im " + currentChord.fret + ". Bund"}
                if (currentChord.category === "basisC") {text += "Der Grundton auf der A-Saite ist im " + currentChord.fret + ". Bund. Der Barré liegt im " + (currentChord.fret - 3) + ". Bund.";}
                if (currentChord.category === "normal") {text = "";}
                text += "</b><br />Klicke auf das Bild für einen neuen Akkord!";
                changeText(text);
        }
}

//setzt das Bild auf [name].jpg
function changeImage(name) {
    var image = document.getElementById('akkordeToolImage');
    image.src = "gtak/" + name + ".jpg";
}

function changeText(text) {
    document.getElementById('akkordeToolText').innerHTML = text;
}

function handleFormClick(){
        //check if last box got unchecked, if so reset form
        if (!(normalBox.checked || eBox.checked || aBox.checked || dBox.checked || cBox.checked)) {
                resetForm();
        }
}

function resetForm(){
        document.getElementById("normalChords").checked = true;
        document.getElementById("eChords").checked = false;
        document.getElementById("aChords").checked = false;
        document.getElementById("dChords").checked = false;
        document.getElementById("cChords").checked = false;
}