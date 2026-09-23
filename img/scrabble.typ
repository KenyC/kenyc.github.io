#import "@preview/cetz:0.5.2"
#set page(width: auto, height: auto, margin: 1pt)
#set text(2cm)
#cetz.canvas({
	import cetz.draw: *
	rect((-1, -1), (1, 1), radius: 0.2, fill: rgb("#ffecbb"))
	content((0, 0), [Y], name: "letter")
	content((rel:  (0, 0), to: "letter.south-east"), text(0.3em)[10])
})