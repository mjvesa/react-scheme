(load "react.scm")

(define item-counter 3)

(define (map-set map key value)
 (js-invoke map "set" key value))

(define my-items (js-new "Map"))

(map-set my-items "item1" "item1")
(map-set my-items "item2" "item2")
(map-set my-items "item3" "item3")

(define (remove-item key)
  (js-invoke my-items "delete" key))

(define (map-to-alist map)
  (let ((result '()))
    (js-invoke map "forEach" (js-closure (lambda (value key map)
      (set! result (cons (cons  key value) result)))))
    result))

(define (get-items)
 (map-to-alist my-items))

(define (new-item-key)
   (set! item-counter (+ item-counter 1))
    (string-append "item" (number->string item-counter)))

(define-component ListHeader
  ($h1 (props "style" (props "fontWeight" "bold")) "Scheme TODO"))

(define-component ListItem
  ($li (props "key" (car (get-prop "item"))
              "onClick" (js-closure
                          (lambda ()
                            (remove-item (car (get-prop "item"))))))
       (cdr (get-prop "item"))))

(define-component ListItems
  (letrec ((makelist (lambda (items)
              (if (null? items)
                '()
                (cons (ListItem (props "item" (car items)) no-children)
                                (makelist (cdr items)))))))
    ($ul no-props (list->vector
                        (makelist (get-prop "content"))))))
(define input-value "")

(define-component ItemList
  (let ((tf ($input (props "type" "text"
                           "key" "textfield"
                          "onChange" (js-closure
                                       (lambda (event)
                                         (set! input-value
                                           (js-ref (js-ref event "target") "value")))))
                   no-children)))
        ($div (props "style"
               (props "border" "2px solid black"
                      "backgroundColor" "lightblue"
                      "display" "inline-block"))
              (children (ListHeader (props "key" "header") no-children)
                        (ListItems (props "content" (get-items) "key" "items") no-children)
                        ($span no-props
                          (vector
                            tf
                            ($button (props "key" "button"
                                            "onClick" (js-closure
                                                        (lambda ()
                                                            (js-invoke my-items "set"
                                                              (new-item-key) input-value))))
                                "add")))))))

(define render-loop
  (js-closure
    (lambda ()
      (js-invoke ReactDOM "render" (ItemList) root)
      (js-invoke (js-eval "window") "requestAnimationFrame" render-loop))))

(js-invoke (js-eval "window") "requestAnimationFrame" render-loop)

