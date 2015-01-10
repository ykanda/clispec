":"; exec csi -ss $0 ${1+"$@"} 
;; #!/usr/local/bin/csi -ss
(use args)
(use posix)
(use srfi-41)


(define exit-status 1)
(define pstdout "")
(define pstderr "")


(define (exit-code expect-exit-code)
  (eq? exit-status expect-exit-code))

(define (stdout-contain expect)
  (not (eq? (string-contains pstdout expect) #f)))

(define (stderr-contain expect)
  (not (eq? (string-contains pstdout expect) #f)))



(define (run-spec spec)
  (if (not (null? (car spec)))
    (begin
      (let ((eval-result (eval (car spec) #;(find-module 'clispec))))
        (print (car spec) " : " (if eval-result "OK" "NG"))
        (if (not (null? (cdr spec)))
          (run-spec(cdr spec)
        ))))))

(define (port->string port)
  (list->string (stream->list (port->stream port))))


(define (test command spec)
  (receive (stdout-subprocess stdin-subprocess subprocess-id stderr-subprocess)
    (process* command)
    (receive (pid result status)
        (process-wait subprocess-id)
        (if result
          (begin
            (print #\escape "[31m")
            (set! exit-status status)
            (set! pstdout (port->string stdout-subprocess))
            (set! pstderr (port->string stderr-subprocess))
            (print #\escape "[32m")
            (run-spec spec)
            (print #\escape "[39m")
            )))))

(define (load-spec-file specfile)
  (begin
    (load specfile)))

(define app-name "clispec")
(define app-version-major 0)
(define app-version-minor 0)


(define (usage)
  (with-output-to-port 
    (current-error-port)
    (lambda ()
      (print app-name " " app-version-major "." app-version-minor)
      (print "by Yasuhiro KANDA (@kandayasu)")))
      (print (args:usage opts))
  (exit 1))



(define opts
  (list
    (args:make-option 
      (h help) #:none "Show help" (usage))
    (args:make-option 
      (s specfile) (#:required "SPECFILE") "Path to specfile" (print arg))
    ;(args:make-option (e elephant)  #:required "flatten the argument"
      ;(print "elephant: arg is " arg))
    ))



(define (main args)
  (receive (options operands)
    (args:parse (command-line-arguments) opts)
    ; (print "options  " options)
    ; (print "operands " operands)
    (load-spec-file (alist-ref 'specfile options))
    ; (print "-e -> " (alist-ref 'elephant options))) ;; 'e or 'elephant both work
  ))

(cond-expand
  (chicken-compile-shared)
  (compiling (main (command-line-arguments)))
  (else))
