;; $Id$
;;
;; This file is part of the Modular DocBook Stylesheet distribution.
;; See ../README or http://www.berkshire.net/~norm/dsssl/
;;

(define verbatim-style
  (style
      font-family-name: %mono-font-family%
      font-size:        (* (inherited-font-size) 
			   (if %verbatim-size-factor%
			       %verbatim-size-factor%
			       1.0))
      font-weight:      'medium
      font-posture:     'upright
      line-spacing:     (* (* (inherited-font-size) 
			      (if %verbatim-size-factor%
				  %verbatim-size-factor%
				  1.0))
			   %line-spacing-factor%)
      first-line-start-indent: 0pt
      lines: 'asis
      input-whitespace-treatment: 'preserve))

(define linespecific-style
  (style
      first-line-start-indent: 0pt
      lines: 'asis
      input-whitespace-treatment: 'preserve))

(define ($format-indent$ indent)
  (literal indent))

(define ($format-linenumber$ linenumber)
  ;; A line-field would make more sense here, and allow proportional
  ;; fonts, but you can't put line-fields in the middle of a paragraph
  ;; in the current RTF backend of Jade
  (let ((%factor% (if %verbatim-size-factor%
		      %verbatim-size-factor%
		      1.0)))
    (if (equal? (remainder linenumber %linenumber-mod%) 0)
	(make sequence
	  use: verbatim-style
	  (literal (pad-string (format-number linenumber "1") 
			       %linenumber-length% %linenumber-padchar%))
	  ($linenumber-space$))
	(make sequence
	  use: verbatim-style
	  (literal (pad-string "" %linenumber-length% " "))
	  ($linenumber-space$)))))

(define ($line-start$ indent line-numbers? #!optional (line-number 1))
  (make sequence
    (if indent
	($format-indent$ indent)
	(empty-sosofo))
    (if line-numbers?
	($format-linenumber$ line-number)
	(empty-sosofo))))

(define ($linespecific-display$ indent line-numbers?)
  (let ((vspace (if (INBLOCK?)
		   0pt
		   (if (INLIST?) 
		       %para-sep% 
		       %block-sep%))))
    (make paragraph
      use: linespecific-style
      space-before: (if (and (string=? (gi (parent)) (normalize "entry"))
 			     (absolute-first-sibling?))
			0pt
			vspace)
      space-after:  (if (and (string=? (gi (parent)) (normalize "entry"))
 			     (absolute-last-sibling?))
			0pt
			vspace)
      start-indent: (if (INBLOCK?)
			(inherited-start-indent)
			(+ %block-start-indent% (inherited-start-indent)))
      (if (or indent line-numbers?)
	  ($linespecific-line-by-line$ indent line-numbers?)
	  (process-children)))))

(define ($linespecific-line-by-line$ indent line-numbers?)
  (make sequence
    ($line-start$ indent line-numbers? 1)
    (let loop ((kl (children (current-node)))
	       (linecount 1)
	       (res (empty-sosofo)))
      (if (node-list-empty? kl)
	  res
	  (loop
	   (node-list-rest kl)
	   (if (char=? (node-property 'char (node-list-first kl)
				      default: #\U-0000) #\U-000D)
	       (+ linecount 1)
	       linecount)
	   (let ((c (node-list-first kl)))
	     (if (char=? (node-property 'char c default: #\U-0000) 
			 #\U-000D)
		 (sosofo-append res
				(process-node-list c)
				($line-start$ indent line-numbers?
					      (+ linecount 1)))
		 (sosofo-append res (process-node-list c)))))))))

(define ($verbatim-display$ indent line-numbers?)
  (let* ((width-in-chars (if (attribute-string (normalize "width"))
			     (string->number (attribute-string (normalize "width")))
			     %verbatim-default-width%))
	 (fsize (lambda () (if (or (attribute-string (normalize "width"))
				   (not %verbatim-size-factor%))
			       (/ (/ (- %text-width% (inherited-start-indent))
				     width-in-chars) 
				  0.7)
			       (* (inherited-font-size) 
				  %verbatim-size-factor%))))
	 (vspace (if (INBLOCK?)
		     0pt
		     (if (INLIST?)
			 %para-sep% 
			 %block-sep%))))
    (make paragraph
      use: verbatim-style
      space-before: (if (and (string=? (gi (parent)) (normalize "entry"))
 			     (absolute-first-sibling?))
			0pt
			vspace)
      space-after:  (if (and (string=? (gi (parent)) (normalize "entry"))
 			     (absolute-last-sibling?))
			0pt
			vspace)
      font-size: (fsize)
      line-spacing: (* (fsize) %line-spacing-factor%)
      start-indent: (if (INBLOCK?)
			(inherited-start-indent)
			(+ %block-start-indent% (inherited-start-indent)))
      (if (or indent line-numbers?)
	  ($linespecific-line-by-line$ indent line-numbers?)
	  (process-children)))))

(element literallayout
  (if (equal? (attribute-string "class") (normalize "monospaced"))
      ($verbatim-display$
       %indent-literallayout-lines%
       %number-literallayout-lines%)
      ($linespecific-display$
       %indent-literallayout-lines%
       %number-literallayout-lines%)))


(element address        ($linespecific-display$
			 %indent-address-lines%
			 %number-address-lines%))

(element programlisting ($verbatim-display$
			 %indent-programlisting-lines%
			 %number-programlisting-lines%))

(element screen         ($verbatim-display$
			 %indent-screen-lines%
			 %number-screen-lines%))

(element screenshot (process-children))
(element screeninfo (empty-sosofo))

