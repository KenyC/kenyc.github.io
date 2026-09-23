#import "preamble.typ": *

#include "assets.typ"

#htmlpage("index.html", [
	#include "about.typ"
]) <about>

#htmlpage("research.html", [
	#include "research.typ"
]) <research>

#htmlpage("misc.html", [
	#include "other.typ"
]) <other>

