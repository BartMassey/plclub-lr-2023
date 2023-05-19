TALK = notes-2023
HTML = $(SRCHTML) $(TALK).html

all: $(HTML)

$(TALK).html: $(TALK).md plclub.css mdwrap.sh
	sh mdwrap.sh $(TALK).md >$(TALK).html

clean:
	-rm -f $(HTML)
