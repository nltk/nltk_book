<!-- This file defines the DocBook-utils Style Sheet for DocBook
     Eric Bischoff <eric@caldera.de>
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

;; Alternate which side the headers are on.  This doesn't seem to work.
(define %two-side% #t)

;; Decrease the indentation for section contents.
(define %body-start-indent% 2pi)

;; Place footnotes at the bottom of the page.
(define bop-footnotes #t)

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

;; Where do we keep the admon graphics (for <warn> etc)?
(define %admon-graphics-path%
  "../../stylesheet-images/")

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

; === Other options (see sgml/docbook/docbook-dsssl-1.78/print/dbparam.dsl ===

;; Don't list URLs (mainly of ref docs); they clutter up the text.
(define %show-ulinks% #f) 


    </STYLE-SPECIFICATION-BODY>
  </STYLE-SPECIFICATION>

  <STYLE-SPECIFICATION ID="HTML" USE="UTILS">
    <STYLE-SPECIFICATION-BODY>
;; ===================================================================
;; HTML Parameters
;; Call: jade -d docbook-utils.dsl#html

; === File names ===
(define %root-filename% "index")	;; name for the root html file
(define %html-ext% ".html")		;; default extension for html output files
(define %html-prefix% "section-")       ;; prefix for all filenames generated (except root)
(define %use-id-as-filename% #t)        ;; if #t uses ID value, if present, as filename
                                        ;;   otherwise a code is used to indicate level
                                        ;;   of chunk, and general element number
                                        ;;   (nth element in the document)
(define use-output-dir #f)              ;; output in separate directory?
(define %output-dir% "HTML")            ;; if output in directory, it's called HTML

; === HTML settings ===
(define %html-pubid% "-//W3C//DTD HTML 4.01 Transitional//EN") ;; Nearly true :-(
(define %html40% #t)

; === Media objects ===
(define preferred-mediaobject-extensions  ;; this magic allows to use different graphical
  (list "png" "jpg" "jpeg"))		;;   formats for printing and putting online
(define acceptable-mediaobject-extensions
  (list "bmp" "gif" "eps" "epsf" "avi" "mpg" "mpeg" "qt"))
(define preferred-mediaobject-notations
  (list "PNG" "JPG" "JPEG"))
(define acceptable-mediaobject-notations
  (list "EPS" "BMP" "GIF" "linespecific"))                                                                                                    
; === Rendering ===
(define %admon-graphics% #t)		;; use symbols for Caution|Important|Note|Tip|Warning

;; Don't combine the first section with the preceeding titlepage
;; and/or table of contents.
(define (chunk-skip-first-element-list)
  '())

; === Books only ===
(define %generate-book-titlepage% #t)
(define %generate-book-toc% #t)
(define ($generate-chapter-toc$) #f)	;; never generate a chapter TOC in books

; === Articles only ===
(define %generate-article-titlepage% #t)
(define %generate-article-toc% #t)      ;; make TOC

    </STYLE-SPECIFICATION-BODY>
  </STYLE-SPECIFICATION>

  <EXTERNAL-SPECIFICATION ID="DOCBOOK" DOCUMENT="docbook.dsl">

</STYLE-SHEET>
