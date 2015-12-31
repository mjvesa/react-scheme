(load "react.scm")

(define my-items (list "item1" "item2" "item3"))

(define-component ListHeader
  (h1 (props "style" (props "fontWeight" "bold")) "Scheme TODO"))

(define-component ListItem
  (li no-props (get-prop "joku")))
  
(define-component ListItems
  (letrec ((makelist (lambda (items)
              (if (null? items)
                '()
                (cons (ListItem (props "joku" (car items)) no-children) (makelist (cdr items)))))))
    (ul (props "style" (props "width" "auto")) (list->vector (makelist (get-prop "content"))))))

(define input-value "")

(define-component ItemList
  (let ((tf (input (props "type" "text"
                          "onChange" (js-closure
                                       (lambda (event)
                                         (set! input-value (js-ref (js-ref event "target") "value"))))) no-children)))
        (div (props "style"
               (props "border" "2px solid black"
                      "backgroundColor" "lightblue"
                      "display" "inline-block"))
          (children (ListHeader no-props no-children)
                    (ListItems (props "content" my-items) no-children)
                    (span no-props
                      (vector
                        tf
                        (button (props "onClick" (js-closure
                                                   (lambda ()
                                                     (set! my-items (cons input-value my-items))))) "add")))))))

(define render-loop
  (js-closure
    (lambda ()
      (js-invoke ReactDOM "render" (ItemList) root)
      (js-invoke (js-eval "window") "requestAnimationFrame" render-loop))))

(js-invoke (js-eval "window") "requestAnimationFrame" render-loop)