<!-- This file defines the DocBook-utils Style Sheet for DocBook
     Original author: Eric Bischoff <eric@caldera.de>
     Modified by Edward Loper and Steven Bird

     For a list of variables that can be customized, see:
         sgml/docbook/docbook-dsssl-1.78/*/dbparam.dsl
-->

<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
  <!ENTITY % html "IGNORE">
  <![%html; [
	<!ENTITY % print "IGNORE">
	<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN" CDATA dsssl>
  ]]>
  <!ENTITY % print "INCLUDE">
  <![%print; [
	<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN" CDATA dsssl>
  ]]>
]>

<STYLE-SHEET>

  <STYLE-SPECIFICATION ID="UTILS" USE="DOCBOOK">
    <STYLE-SPECIFICATION-BODY>
;; ===================================================================
;; Generic Parameters
;; (Generic currently means: both print and html)

(define %chapter-autolabel% #t)
(define %section-autolabel% #t)
(define (toc-depth nd) 3)

    </STYLE-SPECIFICATION-BODY>
  </STYLE-SPECIFICATION>

  <STYLE-SPECIFICATION ID="PRINT" USE="UTILS">
    <STYLE-SPECIFICATION-BODY>
;; ===================================================================
;; Print Parameters
;; Call: jade -d docbook-utils.dsl#print

; === Page layout ===

;;;; use A4 paper - comment this out if needed
;; (define %paper-type% "A4") 

;; Alternate which side the headers are on.
(define %two-side% #t)

;; Decrease the indentation for section contents.
(define %body-start-indent% 2pi)

;; Place footnotes at the bottom of the page.
(define bop-footnotes #t)

;; Include the Copyright and the legal notice on the titlepage.
(define (article-titlepage-recto-elements)
  (list (normalize "title") 
	(normalize "subtitle") 
	(normalize "corpauthor") 
	(normalize "authorgroup") 
	(normalize "author") 
	(normalize "abstract")
        (normalize "copyright")
        (normalize "legalnotice")))
(define (book-titlepage-recto-elements)
  (list (normalize "title") 
	(normalize "subtitle") 
	(normalize "graphic") 
	(normalize "mediaobject")
	(normalize "corpauthor") 
	(normalize "authorgroup") 
	(normalize "author") 
	(normalize "editor")
        (normalize "copyright")
        (normalize "legalnotice")))

; === Media objects ===

;; this magic allows to use different graphical formats for printing
;; and putting online
(define preferred-mediaobject-extensions  
   (list "eps"))			
(define acceptable-mediaobject-extensions
   '())
(define preferred-mediaobject-notations
   (list "EPS"))
(define acceptable-mediaobject-notations
   (list "linespecific"))

; === Rendering ===

;; not much whitespace after orderedlist head
(define %head-after-factor% 0.2)

;; more whitespace after paragraph than before
(define ($paragraph$)
  (make paragraph
    first-line-start-indent: (if (is-first-para)
                                 %para-indent-firstpara%
                                 %para-indent%)
    space-before: (* %para-sep% 2)
    space-after: (/ %para-sep% 4)
    quadding: %default-quadding%
    hyphenate?: %hyphenation%
    language: (dsssl-language-code)
    (process-children)))

;; Don't list URLs (mainly of ref docs); they clutter up the text.
(define %show-ulinks% #f) 

;; End Print Parameters
;; ===================================================================
    </STYLE-SPECIFICATION-BODY>
  </STYLE-SPECIFICATION>

  <STYLE-SPECIFICATION ID="HTML" USE="UTILS">
    <STYLE-SPECIFICATION-BODY>
;; ===================================================================
;; HTML Parameters
;; Call: jade -d docbook-utils.dsl#html

; === File names ===

;; name for the root html file
(define %root-filename% "index")

;; default extension for html output files
(define %html-ext% ".html")

;; prefix for all filenames generated (except root)
(define %html-prefix% "section-")

;; if #t uses ID value, if present, as filename otherwise a code is
;; used to indicate level of chunk, and general element number (nth
;; element in the document)
(define %use-id-as-filename% #t)

;; output in separate directory?
(define use-output-dir #f)

;; if output in directory, it's called HTML
(define %output-dir% "HTML")

; === HTML settings ===
;; Nearly true :-(
(define %html-pubid% "-//W3C//DTD HTML 4.01 Transitional//EN") 
(define %html40% #t)

; === Media objects ===
;; This magic allows to use different graphical formats for printing
;; and putting online
(define preferred-mediaobject-extensions
  (list "png" "jpg" "jpeg"))
(define acceptable-mediaobject-extensions
  (list "png" "bmp" "gif" "eps" "epsf" "avi" "mpg" "mpeg" "qt"))
(define preferred-mediaobject-notations
  (list "PNG" "JPG" "JPEG"))
(define acceptable-mediaobject-notations
  (list "EPS" "BMP" "GIF" "linespecific"))
(define %graphic-default-extension% 
  "png")

; === Rendering ===

;; use symbols for Caution|Important|Note|Tip|Warning
(define %admon-graphics% #t)
(define %admon-graphics-path% "../../stylesheet-images/")

;; Don't combine the first section with the preceeding titlepage
;; and/or table of contents.
(define (chunk-skip-first-element-list) '())

;; Use nav-up to link back to the tutorials toc page.  The first
;; define statement defines the HTML for the nav-up link that we want.
;; The second define statement says to use that for the nav-up link.
;; The third define statement says to always include a nav-up link
;; (even on the title page).
(define %nltk-tutorial-footer%
    (make element gi: "center"
          (make element
                gi: "a"
                attributes: (list (list "href" "../index.html"))
                (literal "NLTK Tutorials"))))
(define (nav-up elemnode) %nltk-tutorial-footer%)
(define (nav-up? elemnode) #t)

;; By default, the "nav-home" link just says "Home".  But we'd prefer
;; to make it explicit that it's linking to the top of the current
;; tutorial.  Also, it's nice to have the name of the current tutorial
;; on the page somewhere.  So use the title of the article as the
;; text for the link.  This *should* be easy, but for reasons that I
;; dont understand, the obvious code "(element-title-sosofo home)"
;; doesn't seem to do the right thing.  So we have to find the
;; articleinfo/bookinfo nade, and get *it's* title, instead.
(define (gentext-nav-home home)
  (let* ((clist (children home))
         (ainfo (select-elements clist (normalize "articleinfo")))
         (binfo (select-elements clist (normalize "boookinfo")))
         (info (if (node-list-empty? ainfo)
                   (if (node-list-empty? binfo) clist binfo)
                   ainfo)))
    (element-title-sosofo (node-list-first info))))

;; Use the stylesheet for tutorials
(define %stylesheet% "../../tutorial.css")

;; Add the standard navbar at the top of tutorials; and wrap the
;; contents of each tutorial in a [div class="body"]...[/div].
;; To add the navigation bar, we first define its contents (in a
;; somewhat akward fashion) and store them in %nltk-navbar%.  We
;; then use $html-body-start$ and $html-body-end$ to insert the
;; navbar, and to wrap the body in a DIV element with CSS class
;; "body".
(define %nltk-navbar%
 (make sequence
   (make element gi: "table"
        attributes: '(("width" "100%") ("class" "navbox") ("cellpadding" "1")
                      ("cellspacing" "0"))
     (make element gi: "tr"
       (make element gi: "td"
             attributes: '(("align" "center") ("width" "16.6%")
                           ("class" "navbutton"))
             (make element gi: "a"
                   attributes: '(("class" "nav") ("href" "../../index.html"))
                   (literal "Home")))
       (make element gi: "td"
             attributes: '(("align" "center") ("width" "16.6%")
                           ("class" "navbutton"))
             (make element gi: "a"
                   attributes: '(("class" "nav") ("href" "../../install.html"))
                   (literal "Installation")))
       (make element gi: "td"
             attributes: '(("align" "center") ("width" "16.6%")
                           ("class" "navbutton"))
             (make element gi: "a"
                   attributes: '(("class" "nav") ("href" "../../docs.html"))
                   (literal "Documentation")))
       (make element gi: "td"
             attributes: '(("align" "center") ("width" "16.6%")
                           ("class" "navbutton"))
             (make element gi: "a"
                   attributes: '(("class" "nav") ("href" "../../teach.html"))
                   (literal "Teaching")))
       (make element gi: "td"
             attributes: '(("align" "center") ("width" "16.6%")
                           ("class" "navbutton"))
             (make element gi: "a"
                   attributes: '(("class" "nav") ("href" "../../contrib.html"))
                   (literal "Contributing")))
       (make element gi: "td"
             attributes: '(("align" "center") ("width" "16.6%")
                           ("class" "navbutton"))
             (make element gi: "a"
                 attributes: '(("href" "http://sourceforge.net/projects/nltk"))
		 (make empty-element gi: "img"
		       attributes: '(("src" "../../sflogo.png")
				     ("width" "88") ("height" "26")
				     ("border" "0") ("alt" "SourceForge")
				     ("align" "top")))))))))
(define ($html-body-start$) %nltk-navbar%)
(define ($html-body-content-start$)
  (make sequence    
    (make formatting-instruction data: "&#60;")
    (literal "div class=\"body\"")
    (make formatting-instruction data: "&#62;")))
(define ($html-body-content-end$) 
  (make sequence
    (make formatting-instruction data: "&#60;")
    (literal "/div")
    (make formatting-instruction data: "&#62;")))

; === Books only ===

(define %generate-book-titlepage% #t)
(define %generate-book-toc% #t)

;; never generate a chapter TOC in books
(define ($generate-chapter-toc$) #f)

;; Define the contents of the title page.
(define (book-titlepage-recto-elements)
  (list (normalize "title")
	(normalize "subtitle")
	(normalize "corpauthor")
	(normalize "authorgroup")
	(normalize "author")
	(normalize "releaseinfo")
	(normalize "copyright")
	(normalize "pubdate")
	(normalize "revhistory")
	(normalize "abstract")
        (normalize "legalnotice")))

; === Articles only ===

;; Articles include a table of contents & a titlepage.
(define %generate-article-titlepage% #t)
(define %generate-article-toc% #t)      

;; Define the contents of the title page.
(define (article-titlepage-recto-elements)
  (list (normalize "title")
	(normalize "subtitle")
	(normalize "corpauthor")
	(normalize "authorgroup")
	(normalize "author")
	(normalize "releaseinfo")
	(normalize "copyright")
	(normalize "pubdate")
	(normalize "revhistory")
	(normalize "abstract")
        (normalize "legalnotice")))

;; End HTML Parameters
;; ===================================================================
    </STYLE-SPECIFICATION-BODY>
  </STYLE-SPECIFICATION>

  <EXTERNAL-SPECIFICATION ID="DOCBOOK" DOCUMENT="docbook.dsl">

</STYLE-SHEET>
