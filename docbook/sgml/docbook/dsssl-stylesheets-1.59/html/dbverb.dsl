;; $Id$
;;
;; This file is part of the Modular DocBook Stylesheet distribution.
;; See ../README or http://www.berkshire.net/~norm/dsssl/
;;

(define ($inpre$)
  (let ((wrapper (ancestor-member (current-node)
				  (list (normalize "address")
					(normalize "funcsynopsisinfo")
					(normalize "literallayout")
					(normalize "programlisting")
					(normalize "screen")
					(normalize "synopsis")))))
    (if (or (and (equal? wrapper "literallayout")
		 (not (equal? (attribute-string "class" wrapper)
			      (normalize "monospaced"))))
	    (equal? wrapper "address"))
	#f
	#t)))

(define ($format-indent$ indent)
  ;; This code is made complex by the fact that we need an additional
  ;; wrapper and we have to translate spaces into nbsp entity-refs,
  ;; if we aren't in a PRE.
  ;; 
  (if ($inpre$)
      (literal indent)
      (make element gi: "CODE"
	    ($sp-to-nbsp-sosofo$ indent))))

(define ($format-linenumber$ linenumber)
  ;; This code is made complex by the fact that we need an additional
  ;; wrapper and we have to translate spaces into nbsp entity-refs,
  ;; if we aren't in a PRE.
  ;; 
  (if (equal? (remainder linenumber %linenumber-mod%) 0)
      (if ($inpre$)
	  (make sequence
	    (literal (pad-string (format-number linenumber "1") 
				 %linenumber-length% %linenumber-padchar%))
	    ($linenumber-space$))
	  (make element gi: "CODE"
		($sp-to-nbsp-sosofo$ 
		 (pad-string (format-number linenumber "1") 
			     %linenumber-length% %linenumber-padchar%))
		($linenumber-space$)))
      (if ($inpre$)
	  (make sequence
	    (literal (pad-string "" %linenumber-length% " "))
	    ($linenumber-space$))
	  (make element gi: "CODE"
		($sp-to-nbsp-sosofo$ 
		 (pad-string "" %linenumber-length% " "))
		($linenumber-space$)))))

(define ($line-start$ indent line-numbers? #!optional (line-number 1))
  (make sequence
    (if indent
	($format-indent$ indent)
	(empty-sosofo))
    (if line-numbers?
	($format-linenumber$ line-number)
	(empty-sosofo))))

(define ($sp-to-nbsp-sosofo$ string)
  ;; Given a string, return it as a sosofo, but replace spaces with 
  ;; nbsp entity-refs.
  (make sequence
    (let loop ((charlist (string->list string))
	       (res (empty-sosofo)))
      (if (null? charlist)
	  res
	  (loop
	   (cdr charlist)
	   (let ((c (car charlist)))
	     (if (equal? c #\ )
		 (sosofo-append res
				(make entity-ref name: "nbsp"))
		 (sosofo-append res (literal (list->string (list c)))))))))))

(define ($verbatim-display$ indent line-numbers?)
  (let ((content (make element gi: "PRE"
		       attributes: (list
				    (list "CLASS" (gi)))
		       (if (or indent line-numbers?)
			   ($verbatim-line-by-line$ indent line-numbers?)
			   (process-children)))))
    (if %shade-verbatim%
	(make element gi: "TABLE"
	      attributes: ($shade-verbatim-attr$)
	      (make element gi: "TR"
		    (make element gi: "TD"
			  content)))
	content)))

(define ($verbatim-line-by-line$ indent line-numbers?)
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
				($line-start$ indent 
					      line-numbers?
					      (+ linecount 1)))
		 (sosofo-append res (process-node-list c)))))))))

(define ($linespecific-display$ indent line-numbers?)
  (make element gi: "P"
	attributes: (list (list "CLASS" (gi)))
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
				      (make empty-element gi: "br")
				      (process-node-list c)
				      ($line-start$ indent 
						    line-numbers? 
						    (+ linecount 1)))
		       (if (char=? (node-property 'char c default: #\U-0000) 
				   #\U-0020)
			   (sosofo-append res
					  (make entity-ref name: "nbsp"))
			   (sosofo-append res (process-node-list c)))))))))))

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

