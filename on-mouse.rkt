;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname on-mouse) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES IMPORTED
(require 2htdp/image)
(require 2htdp/universe)
(require "definitions.rkt")
(require "base.rkt")

; !!! THIS FUNCTION IS NOT YET COMPLETED !!!
; We ran out of time, but this doesn't have any consequences on the final product, it was just a small detail :)

;; Function mouse-handler

;; DATA TYPE DEFINITION
; GameState - previously defined
; Integer - Built-in
; String - Built-in

;; INPUT/OUTPUT
; Signature:
; mouse-handler : GameState Integer Integer String -> GameState

; Purpose statement:
; Is responsable for handling the mouse events and changing the state of the game accordingly

; Header:
; (define (mouse-handler state 1 2 "ciao") state)

;; EXAMPLES:

;; TEMPLATE
; (define (mouse-handler state mx my me)
;   ... (game-state-is-running state) ...
;   ... (game-state-active-state state) ...
;   ... (game-state-key-pressed state) ...
;   ... mx ...
;   ... my ...
;   ... me ...)

;; IMPLEMENTATION
(provide mouse-handler)
(define (mouse-handler state mx my me)
  ; performance enhancement - mouse movement checking only needed in menustates
  (cond
    [
     (menu-state? (game-state-active-state state))
    
     ; start by updating the mouse position
     (cond
       [
        ; if the mouse has been moved
        (equal? state "move")

        ; return state
        (make-game-state
         (game-state-is-running state)
         (game-state-active-state state)
         ; move the mouse-hover state
         (append
          ; remove all old mousepos from the list
          (filter (not (mouse-key?)) (game-state-key-pressed state))
          ; add mouse pos to new list
          (make-mouse-key (make-posn mx my) "hover")
          )
         )
        ]
       [
        ; if the mouse has been clicked
        (equal? state "button-down")

        ; return state
        (make-game-state
         (game-state-is-running state)
         (game-state-active-state state)
         ; move the mouse-hover state
         (append
          ; remove all old mousepos from the list
          (filter (not (mouse-key?)) (game-state-key-pressed state))
          ; add mouse pos to new list
          (make-mouse-key (make-posn mx my) "click")
          )
         )
        ]
       [
        ; if the mouse has been unclicked
        (equal? state "button-up")

        ; return state
        (make-game-state
         (game-state-is-running state)
         (game-state-active-state state)
         ; move the mouse-hover state
         (append
          ; remove all old mousepos from the list
          (filter (not (mouse-key?)) (game-state-key-pressed state))
          ; add mouse pos to new list
          (make-mouse-key (make-posn mx my) "hover")
          )
         )
        ]
       [
        ; otherwise, it's an update that is irrelevant, return the same state
        else
        state
        ]
       )
     ]
    [
     else
     state
     ]
    )
  )