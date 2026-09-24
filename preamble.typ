#let bracketlink(text, href) = [\[#link(href, text)\]]
#let paperlink = bracketlink.with("paper")
#let handout = bracketlink.with("handout")
#let slides = bracketlink.with("slides")
#let doi = bracketlink.with("doi")


#let collapsible(content, text: "abstract") = html.div(class: "collapsible-abstract")[
	#html.button(class: "abstract-toggle", type: "button", aria-expanded: false)[
		#html.span(class: "abstract-triangle")[▶]
		#html.span(class: "abstract-label")[#text]
	]
	#html.div(class: "abstract-content")[#content]
]

#let maillink(email) = {
	link("mailto:" + email, email)
}


#let htmlpage(name, content) = document(name, title: "Keny Chatain", {
	html.html(lang: "en")[
		#html.head[
			// meta
			#html.meta(charset: "utf-8")
			#html.meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
			#html.title[Keny Chatain]
			// css
			#html.link(rel: "stylesheet", href: "/tacit.css", type: "text/css")
			#html.link(rel: "stylesheet", href: "custom.css", type: "text/css")
			#html.script(src: "collapsible.js")
			//
		]
		#html.body[
			#html.header[
				#title[Keny Chatain]
				#html.nav[
					#link(<about>, html.button([About]))
					#link(<research>, html.button([Research]))
					#link(<cv>, html.button([CV]))
					#link(<other>, html.button([Misc]))
				]
			]
			#html.main(content)
		]

	]

})
