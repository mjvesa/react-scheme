;; React experiments
(define root
  (js-invoke (js-eval "document") "getElementById" "main"))
  
(define React
    (js-eval "React"))

(define DOM
  (js-ref React "DOM"))

(define ReactDOM
    (js-eval "ReactDOM"))

(define (r-elem el)
  (lambda (text) 
    (js-invoke DOM (symbol->string el) (js-eval "null") text)))

(define (react-element el)
  (lambda (props children)
    (js-invoke React "createElement" (symbol->string el) props children)))

(define-macro (component name content)
  `(let ((comp (js-invoke React "createClass"
                  (js-obj
                    "displayName" ,name
                    "render" (js-closure2
                                (lambda (this)
                                  ,content))))))
        (lambda (props children) (js-invoke React "createElement" comp props children))))

(define-macro (define-component name content)
  `(define ,name
    (let ((comp (js-invoke React "createClass"
                  (js-obj
                    "displayName" ,name
                    "render" (js-closure2
                                (lambda (this)
                                  ,content))))))
        (lambda (props children) (js-invoke React "createElement" comp props children)))))

(define (string-capitalized? str)
    (let ((first (string-ref str 0)))
         (and (string>=? "A" first)
              (string<=? "Z" first))))

(define (react-whitelist-0 elems)
 (if (null? elems)
     '()
     (cons `(define ,(car elems) (react-element ',(car elems)))
           (react-whitelist-0 (cdr elems)))))

(define-macro (react-whitelist elems)
  (cons 'begin (react-whitelist-0 elems)))

(react-whitelist (p div span h1 h2 h3 h4 ul ol li button input))


(define null (js-eval "null"))

(define no-props null)
(define no-children null)

(define-macro (props . values)
  `(js-obj ,@values))

(define-macro (styles . values)
  (props values))

(define-macro (children . values)
  `(vector ,@values))

(define-macro (get-prop prop)
  `(js-ref (js-ref this "props") ,prop))

