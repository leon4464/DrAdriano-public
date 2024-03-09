;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES IMPORTED
(require 2htdp/image)
(require 2htdp/universe)

(require "on-key.rkt")
(require "on-tick.rkt")
(require "on-mouse.rkt")
(require "to-draw.rkt")
(require "definitions.rkt")


; Function should-stop?

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
; Boolean - built-in

;; INPUT/OUTPUT
; Signature:
; should-stop? : GameState -> Boolean

; Purpose statement:
; Predicate answering whether or not the game should exit (if is-running variable is set to false) based on the GameState

; Header:
; (define (should-stop? state) #false)

;; EXAMPLES
; Test 1 - quit returns #false when is-running is #true
(check-expect (should-stop?
               (make-game-state #true ; !!! is-running is #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" ""))
                                                (make-character (make-posn 20 0)
                                                                "DrAdriano"
                                                                #false
                                                                (make-posn 64 64)
                                                                3
                                                                (make-posn 0 0))
                                                #false
                                                (make-posn 20 0)
                                                (make-posn 90 0)
                                                (rectangle 1280 720 "solid" "white"))
                               '()))
               #false) ; we shouldn't stop the game, because we haven't reached the end nor the game stopped running

; Test 2 - quit returns #true when is-running is #false
(check-expect (should-stop?
               (make-game-state #false ; !!! is-running is #false
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                      (list "" "" "" "" "" "" "" "" "" ""))
                                                (make-character (make-posn 20 0)
                                                                "DrAdriano"
                                                                #false
                                                                (make-posn 64 64)
                                                                3
                                                                (make-posn 0 0))
                                                #false
                                                (make-posn 20 0)
                                                (make-posn 90 0)
                                                (rectangle 1280 720 "solid" "white"))
                               '()))
              #true) ; we should stop the game, because the game is NOT running anymore

;; TEMPLATE
;(define (should-stop? state)
;  ... (game-state-is-running state) ...
;  ... (game-state-active-state state) ...
;  ... (game-state-key-pressed state) ...
;  ... state ...
;  )

;; IMPLEMENTATION
(define (should-stop? state)
  (not (game-state-is-running state))) ; return #true if is-running is #false


; Function big-bang

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT:
; Signature:
; big-bang : GameState -> -

; Purpose statement:
; Takes the INITIAL-GAME-STATE GameState and passes it with various handler functions in order to play DrAdriano

; Header:
; (big-bang INITIAL-GAME-STATE)

;; EXAMPLES:
; no automated tests written - extensive other testing completed

;; TEMPLATE:
; (big-bang INITIAL-GAME-STATE
;  ... tick ...
;  ... key-down ...
;  ... on-release ...
;  ... key-up ...
;  ... mouse-handler ...
;  ... draw ...
;  ... should-stop? ...
; )

;; IMPLEMENTATION
(big-bang INITIAL-GAME-STATE
  (on-tick tick (/ 1 FPS))
  (on-key key-down)
  (on-release key-up)
  (on-mouse mouse-handler)
  (to-draw draw SCREEN-WIDTH SCREEN-HEIGHT)
  (close-on-stop #true)
  (stop-when should-stop?)
  (name "DrAdriano"))