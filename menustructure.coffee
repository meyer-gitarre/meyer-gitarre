module.exports =
	name: "Home"
	path: "/index.html"
	children: [
		name: "Gitarre"
		path: "/gitarre/index.html"
		children: [
			name: "Lernen"
			path: "/gitarre/lernen/index.html"
		]
	,
		name: "Musiklehre"
		path: "/musiklehre/index.html"
		children: [

		]
	,
		name: "Blockflöte"
		path: "/blockfloete/index.html"
		children: [
			name: "Das Instrument"
			path: "/blockfloete/instrument/index.html"
			sections: [
				name: "Das Instrument und der Name"
				path: "/blockfloete/instrument/index.html#instrument"
			,
				name: "Notation der Blockflöten"
				path: "/blockfloete/instrument/index.html#floetennotier"
			,
				name: "Flötenmodelle"
				path: "/blockfloete/instrument/index.html#floetenmodelle"
			]
		,
			name:"Qualität und Preise"
			path: "/blockfloete/qualitaet/index.html"
			sections: [
				name: "Qualität oder: die Suche nach einer guten Flöte"
				path: "blockfloete/qualitaet/index.html#qualitaet"
			,
				name: "Kriterien für die Auswahl"
				path: "blockfloete/qualitaet/index.html#kriterien"
			,
				name: "Musikgeschäft oder Internet"
				path: "blockfloete/qualitaet/index.html#wokaufen"
			,
				name: "Konkrete Tips"
				path: "blockfloete/qualitaet/index.html#konkret"
			]
		,
			name: "Behandlung"
			path: "/blockfloete/behandlung/index.html"
			sections: [
				name: "Vor dem Spielen"
				path: "/blockfloete/behandlung/index.html"
			,
				name: "Nach dem Spielen"
				path: "/blockfloete/behandlung/index.html#nachdemspielen"
			,
				name: "Ölen"
				path: "/blockfloete/behandlung/index.html#oelen"
			,
				name: "Einspielen"
				path: "/blockfloete/behandlung/index.html#einspielen"
			,
				name: "Holzverletzungen"
				path: "/blockfloete/behandlung/index.html#holzverletzungen"
			,
				name: "Heiserkeit / Verstopfen"
				path: "/blockfloete/behandlung/index.html#verstopfen"
			]
		,
			name: "Spieltechnik"
			path: "/blockfloete/spieltechnik/index.html"
			sections: [
				name: "Ein schwieriges Instrument"
				path: "/blockfloete/spieltechnik/index.html#schwieriges"
			,
				name: "Der Wechsel vom Sopran zum Alt"
				path: "/blockfloete/spieltechnik/index.html#wechselalt"
			,
				name: "Literatur für Blockflöte"
				path: "/blockfloete/spieltechnik/index.html#literatur"
			,
				name: "Deutsche Griffweise"
				path: "/blockfloete/spieltechnik/index.html#deutsche"
			,
				name: "Wege zur Blockflöte"
				path: "/blockfloete/spieltechnik/index.html#wegezur"
			]
		]
	,
		name: "Impressum, Links"
		path: "/impressum/index.html"
		sections: [
			name: "Credits"
			path: "/impressum/index.html#credits"
		,
			name: "Links"
			path: "/impressum/index.html#links"
		,
			name: "Disclaimer"
			path: "/impressum/index.html#disclaimer"
		]
	]
