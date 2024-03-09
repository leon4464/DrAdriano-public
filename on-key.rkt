;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname on-key) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES IMPORTED
(require 2htdp/image)
(require 2htdp/universe)
(require racket/list)
(require "definitions.rkt")
(require "base.rkt")



; Function key-down

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
; Sting - built-in

;; INPUT/OUTPUT:
; Signature:
; key-down : GameState String -> GameState

; Purpose statement:
; Add the current key to the list of key pressed in the GameState

; Header:
; (define (key-down state "test") state)

;; EXAMPLES:
; Test 1 - test if the current key pressed is inserted correctly in the key-pressed list
(check-expect (key-down (make-game-state #true
                                        #false
                                        '())
                        "a")
               
              ; gets the same GameState, but with the "a" key inside the key-pressed list
              (make-game-state #true
                               #false
                               '("a")))

; Test 2 - check the case where the player has pressed the "a" key and now wonts to press the "d" key
(check-expect (key-down (make-game-state #true
                                        #false
                                        '("a"))
                        "d")
               
              ; gets the GameState with the keys "a" and "d" inside the list
              (make-game-state #true
                               #false
                               '("a" "d")))

;; TEMPLATE:
;(define (key-down state key)
;        ... (game-state-is-running state) ...
;        ... (game-state-level-state state) ...
;        ... (game-state-key-pressed state) ...
;        ... state ...
;        ... key ...)


;; IMPEMENTATION:
(provide key-down)
(define (key-down state key)
  (make-game-state (game-state-is-running state)
                   (game-state-active-state state)
                   (remove-duplicates (append (game-state-key-pressed state) (list key)))))





; Function key-up

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
; String - built-in

;; INPUT/OUTPUT:
; Signature:
; key-up : GameState String -> GameState

; Purpose statement:
; removes the current key, and all the key that are the same, from the list of key pressed in the GameState

; Header:
; (define (key-down state "state") state)

;; EXAMPLES:
; Test 1 - test if key is removed correctly from the first position
(check-expect (key-up (make-game-state #true
                                      #false
                                      '("a" "w" "d"))
                      "a")
               
              ; gets the GameState with the "a" key removed
              (make-game-state #true
                               #false
                               '("w" "d")))

; Test 2 - test if key is removed correctly from a random position
(check-expect (key-up (make-game-state #true
                                      #false
                                      '("a" "w" "d"))
                      "w")
               
              ; gets the GameState with the "a" key removed
              (make-game-state #true
                               #false
                               '("a" "d")))

; Test 3 - test if key is removed correctly when the list remains empty
(check-expect (key-up (make-game-state #true
                                      #false
                                      '("w"))
                      "w")
               
              ; gets the GameState with the "a" key removed
              (make-game-state #true
                               #false
                               '()))

; Test 4 - test if returns the same GameState if the key is not present in the list
(check-expect (key-up (make-game-state #true
                                      #false
                                      '("a" "b"))
                      "w")
               
              ; gets the GameState with the "a" key removed
              (make-game-state #true
                               #false
                               '("a" "b")))


;; TEMPLATE:
;(define (key-up state key)
;        ... (game-state-is-running state) ...
;        ... (game-state-level-state state) ...
;        ... (game-state-key-pressed state) ...
;        ... state ...
;        ... key ...)


;; IMPEMENTATION:
(provide key-up)
(define (key-up state key)
  (if (and (list? (game-state-key-pressed state)) (not (empty? (game-state-key-pressed state))))
      (make-game-state (game-state-is-running state)
                       (game-state-active-state state)
                       (remove key (remove-duplicates (game-state-key-pressed state))))
            state))
