SRCHTML = foldlr.hs.html Data-List-Combinator.hs.html
HTML = $(SRCHTML) plclub-lr.html

all: $(HTML)

foldlr.hs.html: foldlr.hs
	HsColour foldlr.hs >foldlr.hs.html

Data-List-Combinator.hs.html: Data-List-Combinator.hs
	HsColour Data-List-Combinator.hs >Data-List-Combinator.hs.html

plclub-lr.html: plclub-lr.md ./mdwrap
	./mdwrap plclub-lr.md >plclub-lr.html

clean:
	-rm -f $(HTML)
