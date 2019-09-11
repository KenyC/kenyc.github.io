import os

REPLACE_CONTENT = "<!--##CONTENT##-->"
REPLACE_ACTIVE = "<!--##ACTIVE##-->"
TEMPLATE_DIR = "templates"
TEMPLATE_TO_USE = os.path.join(TEMPLATE_DIR, "template_black.html")
LOC_CONTENT = "contents"

def replace_active(string, filename):
	match_string = "<a href=\"{}\">" + REPLACE_ACTIVE
	replace_string = "<a href=\"{}\" class=\"current\">" + REPLACE_ACTIVE

	return string.replace(match_string.format(filename), replace_string.format(filename))


with open(TEMPLATE_TO_USE, "r") as f:
	template = f.read()


for filename in os.listdir(LOC_CONTENT):

	content_file = os.path.join(LOC_CONTENT, filename)

	with open(content_file, "r") as f:
		content = f.read()

	final = template.replace(REPLACE_CONTENT, content)
	final = replace_active(final, filename)

	with open(filename, "w") as f:
		f.write(final)
