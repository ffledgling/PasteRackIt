#lang racket

(require net/url
         net/uri-codec
         racket/cmdline)

;; Initialize parameter defaults

(define poster (make-parameter ""))
(define title (make-parameter ""))
(define no-eval (make-parameter #f))
(define alert-irc (make-parameter #f))


;; Parse command-line args and set parameters accordingly
; filename: (or/c string? null?)
(define filename
  (command-line
    #:once-each 
    [("--poster" "-p") p "Name of the Author of this paste" (poster p)]
    [("--title" "-t") t "Title for this paste" (title t)]
    [("--no-eval" "-n") "Paste as text only, do not evaluate" (no-eval #t)]
    [("--alert-irc" "-a") "Alert #racket on Freenode about this paste" (alert-irc #t)]
    #:args ([fname null])
    fname))


;; Reads a file or from stdin depending on CLI args
; (get-contents filename) -> string?
; filename: (or/c string? null?)

(define (get-contents filename)
  (cond
    [(null? filename) (apply string (sequence->list (in-port read-char (current-input-port))))]
    [(file-exists? filename) (file->string filename #:mode 'text)]
    [else (error "Error: File does not exist")]))

;; Uploads "content" to http://pasterack.org
; (upload-contents content) -> string?
; content: string?

(define (upload-contents content)
  (let*
    ([base-url (string->url "http://www.pasterack.org")]
     [post-action (last
                    (regexp-match 
                      (pregexp "action=\"(.*?)\"")
                      (call/input-url base-url
                                      get-pure-port
                                      port->string)))]
     [post-data (string->bytes/utf-8
                  (alist->form-urlencoded
                    (append 
                      (list
                        (cons 'name (title))
                        (cons 'paste content)
                        (cons 'fork-from "")
                        (cons 'nick (poster))
                        (cons 'x "32")
                        (cons 'y "32"))
                      (if (no-eval) (list (cons 'astext "off")) empty)
                      (if (alert-irc) (list (cons 'irc "off")) empty))))]

     [post-url (combine-url/relative base-url post-action)]
     [response-port (post-pure-port post-url post-data)])
    (last (regexp-match (pregexp "location\\.href=\\\"(.*?)\\\"") (port->string response-port)))))

;; Print the paste's URL
(printf "~a~n" (upload-contents (get-contents filename)))
