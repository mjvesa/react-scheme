(load "react.scm")

(define item-counter 3)

(define my-items (js-new "Immutable.Map"
                   (js-obj
                      "item1" "item1"
                      "item2" "item2"
                      "item3" "item3")))

(define (remove-item key)
  (set! my-items (js-invoke my-items "delete" key)))

(define (get-items)
 (js-obj->alist (js-invoke my-items "toObject")))

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
    ($ul (props "style" (props "width" "auto")) (list->vector
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
                                                          (set! my-items
                                                            (js-invoke my-items "set"
                                                              (new-item-key) input-value)
                                                              my-items))))
                                "add")))))))

(define render-loop
  (js-closure
    (lambda ()
      (js-invoke ReactDOM "render" (ItemList) root)
      (js-invoke (js-eval "window") "requestAnimationFrame" render-loop))))

(js-invoke (js-eval "window") "requestAnimationFrame" render-loop)

