<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY docbook.dsl SYSTEM "../print/docbook.dsl" CDATA DSSSL>
]>

<style-sheet>
<style-specification id="docbook-plain" use="docbook">
<style-specification-body>

(define %generate-toc% #f)
(define %generate-lot-list% '())
(define %generate-titlepage% #f)

(define %two-side% #t)

</style-specification-body>
</style-specification>

<external-specification id="docbook" document="docbook.dsl">

</style-sheet>
