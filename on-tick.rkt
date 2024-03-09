;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname on-tick) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES IMPORTED
(require 2htdp/image)
(require 2htdp/universe)
(require "definitions.rkt")
(require "base.rkt")
(require racket/list)
(require "collision-physics.rkt")
(require "gui.rkt")


; Function gravity

;; DATA TYPE DEFINITION
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT
; Signature:
; update-pos : GameState -> GameState

; Purpose statement:
; Function updating the character's position according to the gravitaional pull (in a given GameState)

; Header:
; (define (gravity state) state)

;; EXAMPLES:
; Test 1 - character on a block
(check-expect (gravity (make-game-state #true
                                        (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                          (make-character (make-posn 100 416)
                                                                          "DrAdriano"
                                                                          #false
                                                                          (make-posn 64 64)
                                                                          3
                                                                          (make-posn 0 10))
                                                          #false
                                                          (make-posn 0 0)
                                                          (make-posn 0 10)
                                                          (rectangle 0 0 "solid" "white"))
                                        '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 100 416)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 0)); ! the downwards momentum is set to 0, because the player is on top of a block
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 2 - character in freefall
(check-expect (gravity (make-game-state #true
                                        (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                          (make-character (make-posn 128 128)
                                                                          "DrAdriano"
                                                                          #false
                                                                          (make-posn 64 64)
                                                                          3
                                                                          (make-posn 0 0))
                                                          #false
                                                          (make-posn 0 0)
                                                          (make-posn 0 10)
                                                          (rectangle 0 0 "solid" "white"))
                                        '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 (+ 0 (/ GRAVITY FPS)))) ; ! the character momentum is increased by the gravitational pull, according to the frame count
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

;; TEMPLATE:
;(define (gravity state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...)

;; IMPLEMENTATION:
(define (gravity state)
  (if (legal-movement? (character-size (level-state-character (game-state-active-state state)))
                       (make-posn (posn-x (character-pos (level-state-character (game-state-active-state state))))
                                  (round (+ (posn-y (character-pos (level-state-character (game-state-active-state state))))
                                            (posn-y (character-momentum (level-state-character (game-state-active-state state)))))))
                       (level-state-grid (game-state-active-state state))
                       GRID-SIZE
                       ""); check if the character doesn't have a block beneath
      (make-game-state (game-state-is-running state)
                       (make-level-state (level-state-grid (game-state-active-state state))
                                         (make-character (character-pos (level-state-character (game-state-active-state state)))
                                                         (character-type (level-state-character (game-state-active-state state)))
                                                         (character-states (level-state-character (game-state-active-state state)))
                                                         (character-size (level-state-character (game-state-active-state state)))
                                                         (character-lives (level-state-character (game-state-active-state state)))
                                                         (make-posn (posn-x (character-momentum (level-state-character (game-state-active-state state))))
                                                                    (+ (posn-y (character-momentum (level-state-character (game-state-active-state state))))
                                                                       (/ GRAVITY FPS)))); increase the vertical momentum, because pulled by gravity  
                                         (level-state-enemies (game-state-active-state state))
                                         (level-state-startpos (game-state-active-state state))
                                         (level-state-timer (game-state-active-state state))
                                         (level-state-background (game-state-active-state state)))
                       (game-state-key-pressed state))
      (make-game-state (game-state-is-running state)
                       (make-level-state (level-state-grid (game-state-active-state state))
                                         (make-character (make-posn (posn-x (character-pos (level-state-character (game-state-active-state state))))
                                                                    (- (* (+ (quotient (posn-y (character-pos (level-state-character (game-state-active-state state)))) GRID-SIZE) 1) GRID-SIZE) (/ CHARACTER-SIZE 2)))
                                                         (character-type (level-state-character (game-state-active-state state)))
                                                         (character-states (level-state-character (game-state-active-state state)))
                                                         (character-size (level-state-character (game-state-active-state state)))
                                                         (character-lives (level-state-character (game-state-active-state state)))
                                                         (make-posn (posn-x (character-momentum (level-state-character (game-state-active-state state))))
                                                                    0)) ; reset the vertical momentum to 0, because there is a block beneath, so NO gravitational pull
                                         (level-state-enemies (game-state-active-state state))
                                         (level-state-startpos (game-state-active-state state))
                                         (level-state-timer (game-state-active-state state))
                                         (level-state-background (game-state-active-state state)))
                       (game-state-key-pressed state))))


; Function friction

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT:
; Signature:
; friction : GameState -> GameState

; Purpose statement:
; Slow down the player x momentum during time

; Header:
; (define (friction state) state)

;; EXAMPLES:
; Test 1 - the character is moving to the right
(check-expect (friction (make-game-state #true
                                         (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                           (make-character (make-posn 128 128)
                                                                           "DrAdriano"
                                                                           #false
                                                                           (make-posn 64 64)
                                                                           3
                                                                           (make-posn 8 0)); ! the horizontal momentum is positive, because the character is moving right
                                                           #false
                                                           (make-posn 0 0)
                                                           (make-posn 0 10)
                                                           (rectangle 0 0 "solid" "white"))
                                         '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 7 0)); ! the horizontal momentum is decreased by 1, because of friction
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 2 - the character is moving to the left
(check-expect (friction (make-game-state #true
                                         (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                           (make-character (make-posn 128 128)
                                                                           "DrAdriano"
                                                                           #false
                                                                           (make-posn 64 64)
                                                                           3
                                                                           (make-posn -8 0)); ! the horizontal momentum is negative, because the character is moving left
                                                           #false
                                                           (make-posn 0 0)
                                                           (make-posn 0 10)
                                                           (rectangle 0 0 "solid" "white"))
                                         '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn -7 0)); ! the horizontal momentum is increased by 1, because of friction
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 3 - the character is NOT moving 
(check-expect (friction (make-game-state #true
                                         (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "" "" "" "" "" "" "" "" "" "")
                                                                 (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                           (make-character (make-posn 128 128)
                                                                           "DrAdriano"
                                                                           #false
                                                                           (make-posn 64 64)
                                                                           3
                                                                           (make-posn 0 0)); ! the horizontal momentum is 0, because the character is NOT moving
                                                           #false
                                                           (make-posn 0 0)
                                                           (make-posn 0 10)
                                                           (rectangle 0 0 "solid" "white"))
                                         '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 0)); ! the horizontal momentum remains the same
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

;; TEMPLATE:
;(define (friction state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...)

;; IMPEMENTATION:
(define (friction state)
  (make-game-state (game-state-is-running state)
                   (make-level-state (level-state-grid (game-state-active-state state))
                                     (make-character (character-pos (level-state-character (game-state-active-state state)))
                                                     (character-type (level-state-character (game-state-active-state state)))
                                                     (character-states (level-state-character (game-state-active-state state)))
                                                     (character-size (level-state-character (game-state-active-state state)))
                                                     (character-lives (level-state-character (game-state-active-state state)))
                                                     (make-posn (cond [(> (posn-x (character-momentum (level-state-character (game-state-active-state state)))) 0)
                                                                       (- (posn-x (character-momentum (level-state-character (game-state-active-state state)))) 1)]
                                                                      [(< (posn-x (character-momentum (level-state-character (game-state-active-state state)))) 0)
                                                                       (+ (posn-x (character-momentum (level-state-character (game-state-active-state state)))) 1)]
                                                                      [else (posn-x (character-momentum (level-state-character (game-state-active-state state))))])
                                                                (posn-y (character-momentum (level-state-character (game-state-active-state state))))))
                                     (level-state-enemies(game-state-active-state state))
                                     (level-state-startpos (game-state-active-state state))
                                     (level-state-timer (game-state-active-state state))
                                     (level-state-background (game-state-active-state state)))
                   (game-state-key-pressed state)))



; Function move-right
  
;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
;
;; INPUT/OUTPUT:
; Signature:
; move-right : GameState -> GameState

; Purpose statement:
; Returns a GameState with an updated player position (using CHARACTER-SPEED, such that the character moves right, in the positive x)
; (only if it is considered a legal movement - i.e. there is no obstacle in the way)

; Header:
; (define (move-right state) state)

;;EXAMPLES:
; Test 1 - the character is accelerating
(check-expect (move-right (make-game-state #true
                                           (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                             (make-character (make-posn 128 128)
                                                                             "DrAdriano"
                                                                             (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                             (make-posn 64 64)
                                                                             3
                                                                             (make-posn 0 0)); ! the horizontal momentum has not yet reached the CHARACTER-SPEED
                                                             #false
                                                             (make-posn 0 0)
                                                             (make-posn 0 10)
                                                             (rectangle 0 0 "solid" "white"))
                                           '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 1 0)); ! the horizontal momentum is increased by 1, because the character accelerated
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 2 - the character at max speed
(check-expect (move-right (make-game-state #true
                                           (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                             (make-character (make-posn 128 128)
                                                                             "DrAdriano"
                                                                             (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                             (make-posn 64 64)
                                                                             3
                                                                             (make-posn CHARACTER-SPEED 0)); ! the horizontal momentum has reached the CHARACTER-SPEED
                                                             #false
                                                             (make-posn 0 0)
                                                             (make-posn 0 10)
                                                             (rectangle 0 0 "solid" "white"))
                                           '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Right" 0 RUN-RIGHT #false 0)(make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn CHARACTER-SPEED 0)); ! the horizontal momentum remains the same
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 3 - the character hit a block
(check-expect (move-right (make-game-state #true
                                           (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "b1" "" "" "" "" "" "" "")
                                                                   (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                             (make-character (make-posn 96 416)
                                                                             "DrAdriano"
                                                                             (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                             (make-posn 64 64)
                                                                             3
                                                                             (make-posn CHARACTER-SPEED 0)); ! the horizontal momentum is positive, because the character is moving right
                                                             #false
                                                             (make-posn 0 0)
                                                             (make-posn 0 10)
                                                             (rectangle 0 0 "solid" "white"))
                                           '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "b1" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 96 416)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 0)); ! the horizontal momentum is set to 0
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

;; TEMPLATE:
;(define (move-right state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...)

;; IMPLEMENTATION
(define (move-right state)
  (if (legal-movement? (character-size (level-state-character (game-state-active-state state)))
                       (make-posn (round (+ (posn-x (character-pos (level-state-character (game-state-active-state state))))
                                            (+ (posn-x (character-momentum (level-state-character (game-state-active-state state)))) 1)))
                                  (posn-y (character-pos (level-state-character (game-state-active-state state)))))
                       (level-state-grid (game-state-active-state state))
                       GRID-SIZE
                       "")
      (make-game-state (game-state-is-running state)
                       (make-level-state (level-state-grid (game-state-active-state state))
                                         (make-character (character-pos (level-state-character (game-state-active-state state)))
                                                         (character-type (level-state-character (game-state-active-state state)))
                                                         (append (remove-state (remove-state (character-states (level-state-character (game-state-active-state state)))
                                                                                             "Left") "Idle")
                                                                 (list (make-character-state "Right" 0 RUN-RIGHT #false 0)))
                                                         (character-size (level-state-character (game-state-active-state state)))
                                                         (character-lives (level-state-character (game-state-active-state state)))
                                                         (make-posn (if (< (posn-x (character-momentum (level-state-character (game-state-active-state state)))) CHARACTER-SPEED)
                                                                        (+ (posn-x (character-momentum (level-state-character (game-state-active-state state)))) 1)
                                                                        (posn-x (character-momentum (level-state-character (game-state-active-state state)))))
                                                                    (posn-y (character-momentum (level-state-character (game-state-active-state state))))))
                                         (level-state-enemies(game-state-active-state state))
                                         (level-state-startpos (game-state-active-state state))
                                         (level-state-timer (game-state-active-state state))
                                         (level-state-background (game-state-active-state state)))
                       (game-state-key-pressed state))
      (make-game-state (game-state-is-running state)
                       (make-level-state (level-state-grid (game-state-active-state state))
                                         (make-character (character-pos (level-state-character (game-state-active-state state)))
                                                         (character-type (level-state-character (game-state-active-state state)))
                                                         (character-states (level-state-character (game-state-active-state state)))
                                                         (character-size (level-state-character (game-state-active-state state)))
                                                         (character-lives (level-state-character (game-state-active-state state)))
                                                         (make-posn 0
                                                                    (posn-y (character-momentum (level-state-character (game-state-active-state state))))))
                                         (level-state-enemies(game-state-active-state state))
                                         (level-state-startpos (game-state-active-state state))
                                         (level-state-timer (game-state-active-state state))
                                         (level-state-background (game-state-active-state state)))
                       (game-state-key-pressed state))))



; Function move-left

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT:
; Signature:
; move-left : GameState -> GameState

; Purpose statement:
; Returns a GameState with an updated player position (using CHARACTER-SPEED, such that the character moves left, in the negative x)
; (only if it is considered a legal movement - i.e. there is no obstacle in the way)

; Header:
; (define (move-right state) state)

;; EXAMPLES:
; Test 1 - the character is accelerating
(check-expect (move-left (make-game-state #true
                                          (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                            (make-character (make-posn 128 128)
                                                                            "DrAdriano"
                                                                            (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                            (make-posn 64 64)
                                                                            3
                                                                            (make-posn 0 0)); ! the horizontal momentum has not yet reached the CHARACTER-SPEED
                                                            #false
                                                            (make-posn 0 0)
                                                            (make-posn 0 10)
                                                            (rectangle 0 0 "solid" "white"))
                                          '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Left" 0 RUN-LEFT #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn -1 0)) ; ! the horizontal momentum is decreased by 1, because the character accelerated
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 2 - the character at max speed
(check-expect (move-left (make-game-state #true
                                          (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                            (make-character (make-posn 128 128)
                                                                            "DrAdriano"
                                                                            (list (make-character-state "Left" 0 RUN-LEFT #false 0))
                                                                            (make-posn 64 64)
                                                                            3
                                                                            (make-posn (* -1 CHARACTER-SPEED) 0)); ! the horizontal momentum has reached the CHARACTER-SPEED
                                                            #false
                                                            (make-posn 0 0)
                                                            (make-posn 0 10)
                                                            (rectangle 0 0 "solid" "white"))
                                          '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Left" 0 RUN-LEFT #false 0)(make-character-state "Left" 0 RUN-LEFT #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn (* -1 CHARACTER-SPEED) 0)); ! the horizontal momentum remains the same
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 3 - the character hit a block
(check-expect (move-left (make-game-state #true
                                          (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "" "" "" "" "" "" "" "")
                                                                  (list "" "" "b1" "" "" "" "" "" "" "")
                                                                  (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                            (make-character (make-posn 224 416)
                                                                            "DrAdriano"
                                                                            (list (make-character-state "Left" 0 RUN-LEFT #false 0))
                                                                            (make-posn 64 64)
                                                                            3
                                                                            (make-posn (* -1 CHARACTER-SPEED) 0)); ! the horizontal momentum is negative, because the character is moving left
                                                            #false
                                                            (make-posn 0 0)
                                                            (make-posn 0 10)
                                                            (rectangle 0 0 "solid" "white"))
                                          '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "b1" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 224 416)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Left" 0 RUN-LEFT #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 0)); ! the horizontal momentum is set to 0
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))
   
;; TEMPLATE:
;(define (move-left state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...)

;; IMPLEMENTATION
(define (move-left state)
  (if (legal-movement? (character-size (level-state-character (game-state-active-state state)))
                       (make-posn (round (+ (posn-x (character-pos (level-state-character (game-state-active-state state))))
                                            (- (posn-x (character-momentum (level-state-character (game-state-active-state state)))) 1)))
                                  (posn-y (character-pos (level-state-character (game-state-active-state state)))))
                       (level-state-grid (game-state-active-state state))
                       GRID-SIZE
                       "")
      (make-game-state (game-state-is-running state)
                       (make-level-state (level-state-grid (game-state-active-state state))
                                         (make-character (character-pos (level-state-character (game-state-active-state state)))
                                                         (character-type (level-state-character (game-state-active-state state)))
                                                         (append (remove-state (remove-state (character-states (level-state-character (game-state-active-state state)))
                                                                                             "Right") "Idle")
                                                                 (list (make-character-state "Left" 0 RUN-LEFT #false 0)))
                                                         (character-size (level-state-character (game-state-active-state state)))
                                                         (character-lives (level-state-character (game-state-active-state state)))
                                                         (make-posn (if (> (posn-x (character-momentum (level-state-character (game-state-active-state state)))) (* -1 CHARACTER-SPEED))
                                                                        (- (posn-x (character-momentum (level-state-character (game-state-active-state state)))) 1)
                                                                        (posn-x (character-momentum (level-state-character (game-state-active-state state)))))
                                                                    (posn-y (character-momentum (level-state-character (game-state-active-state state))))))
                                         (level-state-enemies(game-state-active-state state))
                                         (level-state-startpos (game-state-active-state state))
                                         (level-state-timer (game-state-active-state state))
                                         (level-state-background (game-state-active-state state)))
                       (game-state-key-pressed state))
      (make-game-state (game-state-is-running state)
                       (make-level-state (level-state-grid (game-state-active-state state))
                                         (make-character (character-pos (level-state-character (game-state-active-state state)))
                                                         (character-type (level-state-character (game-state-active-state state)))
                                                         (character-states (level-state-character (game-state-active-state state)))
                                                         (character-size (level-state-character (game-state-active-state state)))
                                                         (character-lives (level-state-character (game-state-active-state state)))
                                                         (make-posn 0
                                                                    (posn-y (character-momentum (level-state-character (game-state-active-state state))))))
                                         (level-state-enemies(game-state-active-state state))
                                         (level-state-startpos (game-state-active-state state))
                                         (level-state-timer (game-state-active-state state))
                                         (level-state-background (game-state-active-state state)))
                       (game-state-key-pressed state))))


; Function jump

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
;
;; INPUT/OUTPUT:
; Signature:
; jump : GameState -> GameState

; Purpose statement:
; Returns a GameState with an updated player position (using CHARACTER-SPEED, such that the character moves up, in the positive y)
; (only if it is considered a legal movement - i.e. there is no obstacle in the way)

; Header:
; (define (jump state) state)

;; EXAMPLES:
; Test 1 - the character is on the floor and jumps
(check-expect (jump (make-game-state #true
                                     (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                       (make-character (make-posn 96 416)
                                                                       "DrAdriano"
                                                                       (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                       (make-posn 64 64)
                                                                       3
                                                                       (make-posn 0 0)); ! the vertcal momentum is set to 0
                                                       #false
                                                       (make-posn 0 0)
                                                       (make-posn 0 10)
                                                       (rectangle 0 0 "solid" "white"))
                                     '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 96 416)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 (* -1 JUMP-POWER))); ! the vertical momentum is set to the JUMP-POWER (negative because it has to go up)
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 2 - the character is in the air an jumps
(check-expect (jump (make-game-state #true
                                     (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                       (make-character (make-posn 96 128)
                                                                       "DrAdriano"
                                                                       (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                       (make-posn 64 64)
                                                                       3
                                                                       (make-posn 0 0)); ! the vertcal momentum is set to 0
                                                       #false
                                                       (make-posn 0 0)
                                                       (make-posn 0 10)
                                                       (rectangle 0 0 "solid" "white"))
                                     '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 96 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 0)); ! the vertical momentum remains the same, because the character cannot jump while in the air
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))



;;TEMPLATE:
; (define (jump state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...)

;; IMPLEMENTATION:
(define (jump state)
  (if (and (equal? 0 (posn-y (character-momentum (level-state-character (game-state-active-state state)))))
           (not (legal-movement? (character-size (level-state-character (game-state-active-state state)))
                                 (make-posn (posn-x (character-pos (level-state-character (game-state-active-state state))))
                                            (round (+ (posn-y (character-pos (level-state-character (game-state-active-state state)))) JUMP-POWER)))
                                 (level-state-grid (game-state-active-state state))
                                 GRID-SIZE
                                 "")))
      (make-game-state (game-state-is-running state)
                       (make-level-state (level-state-grid (game-state-active-state state))
                                         (make-character  (character-pos (level-state-character (game-state-active-state state)))
                                                          (character-type (level-state-character (game-state-active-state state)))
                                                          (character-states (level-state-character (game-state-active-state state)))
                                                          (character-size (level-state-character (game-state-active-state state)))
                                                          (character-lives (level-state-character (game-state-active-state state)))
                                                          (make-posn (posn-x (character-momentum (level-state-character (game-state-active-state state))))
                                                                     (* -1 JUMP-POWER)))
                                         (level-state-enemies(game-state-active-state state))
                                         (level-state-startpos (game-state-active-state state))
                                         (level-state-timer (game-state-active-state state))
                                         (level-state-background (game-state-active-state state)))
                       (remove "w" (remove-duplicates (game-state-key-pressed state))))
      state))


; Function idle
; 100% completed

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT:
; Signature:
; idle : GameState -> GameState

; Purpose statement:
; returns the same GameState but with the CharacterState set to Idle

; Header:
; (define (idle state) state)

;; EXAMPLES:
; Test 1 - the character is already in idle
(check-expect (idle (make-game-state #true
                                     (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                       (make-character (make-posn 96 128)
                                                                       "DrAdriano"
                                                                       (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                       (make-posn 64 64)
                                                                       3
                                                                       (make-posn 0 0)); ! the vertcal momentum is set to 0
                                                       #false
                                                       (make-posn 0 0)
                                                       (make-posn 0 10)
                                                       (rectangle 0 0 "solid" "white"))
                                     '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 96 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 0)); ! the vertical momentum remains the same, because the character cannot jump while in the air
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 2 - the character is i another state
(check-expect (idle (make-game-state #true
                                     (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                       (make-character (make-posn 96 128)
                                                                       "DrAdriano"
                                                                       (list (make-character-state "Right" 0 RUN-RIGHT #false 0)); ! the state is set to right
                                                                       (make-posn 64 64)
                                                                       3
                                                                       (make-posn 0 0))
                                                       #false
                                                       (make-posn 0 0)
                                                       (make-posn 0 10)
                                                       (rectangle 0 0 "solid" "white"))
                                     '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 96 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0)); ! the state changes to idle
                                                                 (make-posn 64 64)
                                                                 3
                                                                 (make-posn 0 0))
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

;; TEMPLATE:
;(define (idle state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...)

;; IMPEMENTATION:
(define (idle state)
  (make-game-state (game-state-is-running state)
                   (make-level-state (level-state-grid (game-state-active-state state))
                                     (make-character (character-pos (level-state-character (game-state-active-state state)))
                                                     (character-type (level-state-character (game-state-active-state state)))
                                                     (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0)); change the state to idle
                                                     (character-size (level-state-character (game-state-active-state state)))
                                                     (character-lives (level-state-character (game-state-active-state state)))
                                                     (character-momentum (level-state-character (game-state-active-state state))))
                                     (level-state-enemies(game-state-active-state state))
                                     (level-state-startpos (game-state-active-state state))
                                     (level-state-timer (game-state-active-state state))
                                     (level-state-background (game-state-active-state state)))
                   (game-state-key-pressed state)))

; Function restart

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT:
; Signature:
; restart : GameState -> GameState

; Purpose statement:
; Decrease the lives count of the character in the given GameState - if the lives is now 0, it also returns a state with the GameOver screen.

; Header:
; (define (restart state) state)

;; EXAMPLES:
; Test 1 - the character has still some lives left
(check-expect (restart (make-game-state #true
                                        (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                          (make-character (make-posn 96 128)
                                                                          "DrAdriano"
                                                                          (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                          (make-posn 64 64)
                                                                          3 ; ! lives are set to 3
                                                                          (make-posn 0 0))
                                                          #false
                                                          (make-posn 0 0)
                                                          (make-posn 0 10)
                                                          (rectangle 0 0 "solid" "white"))
                                        '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character INITIAL-POS
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                 (make-posn 64 64)
                                                                 2 ; ! lives are decreased by 1 
                                                                 (make-posn 0 0))
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 2 - the character doesn't have any more lives
(check-expect (restart (make-game-state #true
                                        (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "" "" "" "" "" "" "" "" "" "")
                                                                (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                          (make-character (make-posn 96 128)
                                                                          "DrAdriano"
                                                                          (list (make-character-state "Right" 0 RUN-RIGHT #false 0)); ! the state is set to right
                                                                          (make-posn 64 64)
                                                                          0 ; ! the character has no lives left
                                                                          (make-posn 0 0))
                                                          #false
                                                          (make-posn 0 0)
                                                          (make-posn 0 10)
                                                          (rectangle 0 0 "solid" "white"))
                                        '()))
              (make-game-state #true ; ! the GAMEOVER menu is returned
                               (make-menu-state (menu-state-buttons GAMEOVER)
                                                (menu-state-text GAMEOVER)
                                                (menu-state-background GAMEOVER)
                                                (+ 3 (current-seconds))
                                                (menu-state-endtime-action GAMEOVER)
                                                (menu-state-key-actions GAMEOVER))
                               '()))

;; TEMPLATE:
;(define (restart state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...)

;; IMPEMENTATION:
(define (restart state)
  (if (> (character-lives (level-state-character (game-state-active-state state))) 1) ; the character has still some lives left
      (make-game-state (game-state-is-running state)
                       (make-level-state (level-state-grid (game-state-active-state state))
                                         (make-character  INITIAL-POS
                                                          (character-type (level-state-character (game-state-active-state state)))
                                                          (character-states (level-state-character (game-state-active-state state)))
                                                          (character-size (level-state-character (game-state-active-state state)))
                                                          (- (character-lives (level-state-character (game-state-active-state state))) 1)
                                                          (make-posn 0 0))        
                                         (level-state-enemies(game-state-active-state state))
                                         (level-state-startpos (game-state-active-state state))
                                         (level-state-timer (game-state-active-state state))
                                         (level-state-background (game-state-active-state state)))
                       '())
      (make-game-state (game-state-is-running state)
                       (make-menu-state (menu-state-buttons GAMEOVER)
                                        (menu-state-text GAMEOVER)
                                        (menu-state-background GAMEOVER)
                                        (+ 3 (current-seconds))
                                        (menu-state-endtime-action GAMEOVER)
                                        (menu-state-key-actions GAMEOVER))
                       (game-state-key-pressed state))))


; Function update-frames

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT:
; Signature:
; update-frames : GameState -> GameState

; Purpose statement:
; Updates all the animation frames inside the states of the character

; Header:
; (define (update-frames state) state)

;; EXAMPLES:
; Test 1 - only one characteState present
(check-expect (update-frames (make-game-state #true
                                              (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                                (make-character (make-posn 96 128)
                                                                                "DrAdriano"
                                                                                (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0)); ! the frame count is set to 0
                                                                                (make-posn 64 64)
                                                                                3
                                                                                (make-posn 0 0))
                                                                #false
                                                                (make-posn 0 0)
                                                                (make-posn 0 10)
                                                                (rectangle 0 0 "solid" "white"))
                                              '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 96 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 1 DRADRIANO-IDLE #false 0)); ! the frame count is increased by 1
                                                                 (make-posn 64 64)
                                                                 3 
                                                                 (make-posn 0 0))
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 2 - more than one CharacterState present
(check-expect (update-frames (make-game-state #true
                                              (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                                (make-character (make-posn 96 128)
                                                                                "DrAdriano"
                                                                                (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0)
                                                                                      (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0)
                                                                                      (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0)); ! the frame count is set to 0 for all states
                                                                                (make-posn 64 64)
                                                                                3 
                                                                                (make-posn 0 0))
                                                                #false
                                                                (make-posn 0 0)
                                                                (make-posn 0 10)
                                                                (rectangle 0 0 "solid" "white"))
                                              '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 96 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 1 DRADRIANO-IDLE #false 0)
                                                                       (make-character-state "Idle" 1 DRADRIANO-IDLE #false 0)
                                                                       (make-character-state "Idle" 1 DRADRIANO-IDLE #false 0)); ! the frame count is increased by 1 for all states
                                                                 (make-posn 64 64)
                                                                 3 
                                                                 (make-posn 0 0))
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 3 - the frame counter reached the FPS
(check-expect (update-frames (make-game-state #true
                                              (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "" "" "" "" "" "" "" "" "" "")
                                                                      (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                                (make-character (make-posn 96 128)
                                                                                "DrAdriano"
                                                                                (list (make-character-state "Idle" (- FPS 1) DRADRIANO-IDLE #false 0)); ! the frame count is set to one less the FPS
                                                                                (make-posn 64 64)
                                                                                3
                                                                                (make-posn 0 0))
                                                                #false
                                                                (make-posn 0 0)
                                                                (make-posn 0 10)
                                                                (rectangle 0 0 "solid" "white"))
                                              '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 96 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0)); ! the frame count is reset to 0
                                                                 (make-posn 64 64)
                                                                 3 
                                                                 (make-posn 0 0))
                                                 #false
                                                 (make-posn 0 0)
                                                 (make-posn 0 10)
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

;; TEMPLATE:
;(define (update-frames state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...)

;; IMPEMENTATION:
(define (update-frames state)
  (local [(define (update lst) (map (lambda (s) (make-character-state (character-state-statename s)
                                                                      (if (< (character-state-frame s) (- FPS 1))
                                                                          (+ (character-state-frame s) 1)
                                                                          0)
                                                                      (character-state-sprite s)
                                                                      (character-state-new? s)
                                                                      (character-state-priority s))) lst))]
    (make-game-state (game-state-is-running state)
                     (make-level-state (level-state-grid (game-state-active-state state))
                                       (make-character (character-pos (level-state-character (game-state-active-state state)))
                                                       (character-type (level-state-character (game-state-active-state state)))
                                                       (update (character-states (level-state-character (game-state-active-state state))))
                                                       (character-size (level-state-character (game-state-active-state state)))
                                                       (character-lives (level-state-character (game-state-active-state state)))
                                                       (character-momentum (level-state-character (game-state-active-state state))))
                                       (level-state-enemies(game-state-active-state state))
                                       (level-state-startpos (game-state-active-state state))
                                       (level-state-timer (game-state-active-state state))
                                       (level-state-background (game-state-active-state state)))
                     (game-state-key-pressed state))))
                         
  


; Function key-handler

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
; String - built-in

;; INPUT/OUTPUT:
; Signature:
; key-handler: GameState String -> GameState

; Purpose statement:
; Handles all key presses with respect to the current GameState (handles key presses for LevelState)

; Header:
; (define (key-handler state "test") state)

;;EXAMPLES:
; Test 0 - GameStop when the game is not running
(check-expect (key-handler NOT-WORKING-GAME-STATE "escape")
              NOT-WORKING-GAME-STATE)

; Test 1 - with the key "esc"
(check-expect (key-handler TEST-GAME-STATE "escape")
              (make-game-state #false
                               (make-level-state (level-state-grid (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-character (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-enemies(game-state-active-state TEST-GAME-STATE))
                                                 (level-state-startpos (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-timer (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-background (game-state-active-state TEST-GAME-STATE)))
                               (game-state-key-pressed TEST-GAME-STATE)))

; Test 2 - with the key "d"
(check-expect (key-handler TEST-GAME-STATE "d")
              (make-game-state (game-state-is-running TEST-GAME-STATE)
                               (make-level-state (level-state-grid (game-state-active-state TEST-GAME-STATE))
                                                 (make-character (character-pos (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (character-type (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (append (remove (get-state (character-states (level-state-character (game-state-active-state TEST-GAME-STATE))) "Left")
                                                                                 (remove-duplicates (character-states (level-state-character (game-state-active-state TEST-GAME-STATE)))))
                                                                         (list (make-character-state "Right" 0 RUN-RIGHT #false 0)))
                                                                 (character-size (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (character-lives (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (make-posn (+ (posn-x (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE)))) 1)
                                                                            (posn-y (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE))))))
                                                 (level-state-enemies(game-state-active-state TEST-GAME-STATE))
                                                 (level-state-startpos (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-timer (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-background (game-state-active-state TEST-GAME-STATE)))
                               (game-state-key-pressed TEST-GAME-STATE)))


; Test 3 - with the key "right"
(check-expect (key-handler TEST-GAME-STATE "right")
              (make-game-state (game-state-is-running TEST-GAME-STATE)
                               (make-level-state (level-state-grid (game-state-active-state TEST-GAME-STATE))
                                                 (make-character (character-pos (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (character-type (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (append (remove (get-state (character-states (level-state-character (game-state-active-state TEST-GAME-STATE))) "Left")
                                                                                 (remove-duplicates (character-states (level-state-character (game-state-active-state TEST-GAME-STATE)))))
                                                                         (list (make-character-state "Right" 0 RUN-RIGHT #false 0)))
                                                                 (character-size (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (character-lives (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (make-posn (+ (posn-x (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE)))) 1)
                                                                            (posn-y (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE))))))
                                                 (level-state-enemies(game-state-active-state TEST-GAME-STATE))
                                                 (level-state-startpos (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-timer (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-background (game-state-active-state TEST-GAME-STATE)))
                               (game-state-key-pressed TEST-GAME-STATE)))

; Test 4 - with the key "a"
(check-expect (key-handler TEST-GAME-STATE "a")
              (make-game-state (game-state-is-running TEST-GAME-STATE)
                               (make-level-state (level-state-grid (game-state-active-state TEST-GAME-STATE))
                                                 (make-character (character-pos (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (character-type (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (append (remove (get-state (character-states (level-state-character (game-state-active-state TEST-GAME-STATE))) "Right")
                                                                                 (remove-duplicates (character-states (level-state-character (game-state-active-state TEST-GAME-STATE)))))
                                                                         (list (make-character-state "Left" 0 RUN-LEFT #false 0)))
                                                                 (character-size (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (character-lives (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (make-posn (- (posn-x (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE)))) 1)
                                                                            (posn-y (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE))))))
                                                 (level-state-enemies(game-state-active-state TEST-GAME-STATE))
                                                 (level-state-startpos (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-timer (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-background (game-state-active-state TEST-GAME-STATE)))
                               (game-state-key-pressed TEST-GAME-STATE)))
     

; Test 5 - with the key "left"
(check-expect (key-handler TEST-GAME-STATE "left")
              (make-game-state (game-state-is-running TEST-GAME-STATE)
                               (make-level-state (level-state-grid (game-state-active-state TEST-GAME-STATE))
                                                 (make-character (character-pos (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (character-type (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (append (remove (get-state (character-states (level-state-character (game-state-active-state TEST-GAME-STATE))) "Right")
                                                                                 (remove-duplicates (character-states (level-state-character (game-state-active-state TEST-GAME-STATE)))))
                                                                         (list (make-character-state "Left" 0 RUN-LEFT #false 0)))
                                                                 (character-size (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (character-lives (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                 (make-posn (- (posn-x (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE)))) 1)
                                                                            (posn-y (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE))))))
                                                 (level-state-enemies(game-state-active-state TEST-GAME-STATE))
                                                 (level-state-startpos (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-timer (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-background (game-state-active-state TEST-GAME-STATE)))
                               (game-state-key-pressed TEST-GAME-STATE)))

; Test 6 - with the key " "
(check-expect (key-handler TEST-GAME-STATE " ")
              (make-game-state (game-state-is-running TEST-GAME-STATE)
                               (make-level-state (level-state-grid (game-state-active-state TEST-GAME-STATE))
                                                 (make-character  (character-pos (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                  (character-type (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                  (character-states (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                  (character-size (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                  (character-lives (level-state-character (game-state-active-state TEST-GAME-STATE)))
                                                                  (make-posn (posn-x (character-momentum (level-state-character (game-state-active-state TEST-GAME-STATE))))
                                                                             (* -1 JUMP-POWER)))
                                                 (level-state-enemies(game-state-active-state TEST-GAME-STATE))
                                                 (level-state-startpos (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-timer (game-state-active-state TEST-GAME-STATE))
                                                 (level-state-background (game-state-active-state TEST-GAME-STATE)))
                               (game-state-key-pressed TEST-GAME-STATE)))

; Test 7 - with any other key than "escape", "d", "right", "a", "left", " ", "up", "w"
(check-expect (key-handler TEST-GAME-STATE "f")
              TEST-GAME-STATE)


;;TEMPLATE:
; (define (key-handler state key)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...
;     ... key ...)
 

;; IMPLEMENTATION:
(define (key-handler state key)
  (cond
    ; 1th case check if the game running and esc key check
    [(equal? (game-state-is-running state) #false) state]; check if the game is running
    [(equal? key "escape") (make-game-state #false
                                            (game-state-active-state state)
                                            (game-state-key-pressed state))]; check if the game is started and the player push "esc"
    ; 2nd case with the movement keys
    [(or (equal? key "right") (equal? key "d")) (move-right state)] ;right movement
    [(or (equal? key "left") (equal? key "a")) (move-left state)] ;left movement
    [(or (equal? key "up") (equal? key "w") (equal? key " ")) (jump state)] ;jumping
    [else state]))


; Function update-keys

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT:
; Signature:
; update-keys : GameState -> GameState

; Purpose statement:
; Updates the keys in the key detection list of a GameState (keyPressed) and calls the movement methods for the character accordingly

; Header:
; (define (update-keys state) state)

;; EXAMPLES:
; Test 1 - moves left
(check-expect (update-keys (make-game-state #true
                                            (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" ""))
                                                              (make-character (make-posn 256 256)
                                                                              "DrAdriano"
                                                                              (list (make-character-state "Right" 0 DRADRIANO-IDLE #false 0))
                                                                              (make-posn 64 64)
                                                                              #false
                                                                              (make-posn 0 0))
                                                              #false
                                                              (make-posn 0 0)
                                                              60
                                                              (rectangle 0 0 "solid" "white"))
                                            '("a")))
               
              ; gets the same GameState, but with the "a" key inside the key-pressed list 
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" ""))
                                                 (make-character (make-posn 256 256)
                                                                 "DrAdriano"
                                                                 (list (make-character-state
                                                                        "Left"
                                                                        0
                                                                        RUN-LEFT
                                                                        #false
                                                                        0))
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn -1 0))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '("a")))

; Test 2 - moves right
(check-expect (update-keys (make-game-state #true
                                            (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" ""))
                                                              (make-character (make-posn 256 256)
                                                                              "DrAdriano"
                                                                              (list (make-character-state "Left" 0 RUN-RIGHT #false 0))
                                                                              (make-posn 64 64)
                                                                              #false
                                                                              (make-posn 0 0))
                                                              #false
                                                              (make-posn 0 0)
                                                              60
                                                              (rectangle 0 0 "solid" "white"))
                                            '("d")))
               
              ; gets the same GameState, but with the "a" key inside the key-pressed list 
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" ""))
                                                 (make-character (make-posn 256 256)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn 1 0))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '("d")))

; Test 3 - jumps
(check-expect (update-keys (make-game-state #true
                                            (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                              (make-character (make-posn 100 415)
                                                                              "DrAdriano"
                                                                              (list (make-character-state "Right" 0 DRADRIANO-IDLE #false 0))
                                                                              (make-posn 64 64)
                                                                              #false
                                                                              (make-posn 0 0))
                                                              #false
                                                              (make-posn 0 0)
                                                              60
                                                              (rectangle 0 0 "solid" "white"))
                                            '("w")))
               
              ; gets the same GameState, but with the "a" key inside the key-pressed list 
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 100 415)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 0 DRADRIANO-IDLE #false 0))
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn 0 (* -1 JUMP-POWER)))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; Test 4 - jumps right
(check-expect (update-keys (make-game-state #true
                                            (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                              (make-character (make-posn 100 415)
                                                                              "DrAdriano"
                                                                              (list (make-character-state "Left" 0 RUN-LEFT #false 0))
                                                                              (make-posn 64 64)
                                                                              #false
                                                                              (make-posn 0 0))
                                                              #false
                                                              (make-posn 0 0)
                                                              60
                                                              (rectangle 0 0 "solid" "white"))
                                            '("w" "d")))
               
              ; gets the same GameState, but with the "a" key inside the key-pressed list 
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 100 415)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn 1 (* -1 JUMP-POWER)))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '("d")))

; Test 5 - left jump
(check-expect (update-keys (make-game-state #true
                                            (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "" "" "" "" "" "" "" "" "" "")
                                                                    (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                              (make-character (make-posn 100 415)
                                                                              "DrAdriano"
                                                                              (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                              (make-posn 64 64)
                                                                              #false
                                                                              (make-posn 0 0))
                                                              #false
                                                              (make-posn 0 0)
                                                              60
                                                              (rectangle 0 0 "solid" "white"))
                                            '("a" "w")))
               
              ; gets the same GameState, but with the "a" key inside the key-pressed list 
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 100 415)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Left" 0 RUN-LEFT #false 0))
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn -1 (* -1 JUMP-POWER)))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '("a")))


;; TEMPLATE:
;(define (update-keys state key)
;     ... (game-state-is-running state) ...
;     ... (game-state-level-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...
;     ... key ...)


;; IMPEMENTATION:
(define (update-keys state)
  (local [(define (get-horizontal k) (or (equal? k "a") (equal? k "d") (equal? k "left") (equal? k "right")))
          (define (get-vertical k) (or (equal? k "w") (equal? k " ") (equal? k "up")))
          (define horizontal (findf get-horizontal (game-state-key-pressed state)))
          (define vertical (findf get-vertical (game-state-key-pressed state)))]

    (cond [(number? (index-of (game-state-key-pressed state) "escape"))
           (make-game-state #false (game-state-active-state state) (game-state-key-pressed state))]
          
          [(and (string? horizontal) (string? vertical) (or (string=? "a" horizontal) (string=? "left" horizontal)))
           (move-left (jump state))]
          
          [(and (string? horizontal) (string? vertical) (or (string=? "d" horizontal) (string=? "right" horizontal)))
           (move-right (jump state))]
          
          [(and (string? horizontal) (or (string=? "a" horizontal) (string=? "left" horizontal)))
           (move-left state)]
          
          [(and (string? horizontal) (or (string=? "d" horizontal) (string=? "right" horizontal)))
           (move-right state)]

          [(string? vertical)
           (friction (jump (idle state)))]
          
          [else (friction (idle state))])))



; Function update-pos

;; DATA TYPE DEFINITION
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT
; Signature:
; update-pos : GameState -> GameState

; Purpose statement:
; Is responsable for updating the character's position and momentum

; Header:
; (define (update-pos state) state)


;; EXAMPLES:
; Test 1 - Charecter doing nothing
(check-expect (update-pos (make-game-state #true
                                           (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" ""))
                                                             (make-character (make-posn 128 128)
                                                                             "DrAdriano"
                                                                             #false
                                                                             (make-posn 64 64)
                                                                             #false
                                                                             (make-posn 0 0))
                                                             #false
                                                             (make-posn 0 0)
                                                             60
                                                             (rectangle 0 0 "solid" "white"))
                                           '("a")))
                
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" ""))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn 0 0))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '("a")))
  
  

; Test 2 - Charecter falling
(check-expect (update-pos (make-game-state #true
                                           (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" ""))
                                                             (make-character (make-posn 128 128)
                                                                             "DrAdriano"
                                                                             #false
                                                                             (make-posn 64 64)
                                                                             #false
                                                                             (make-posn 0 10))
                                                             #false
                                                             (make-posn 0 0)
                                                             60
                                                             (rectangle 0 0 "solid" "white"))
                                           '("a")))
               
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" ""))
                                                 (make-character (make-posn 128 138)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn 0 10))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '("a")))
  

; Test 3 - Charecter going up
(check-expect (update-pos (make-game-state #true
                                           (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" ""))
                                                             (make-character (make-posn 128 128)
                                                                             "DrAdriano"
                                                                             #false
                                                                             (make-posn 64 64)
                                                                             #false
                                                                             (make-posn 0 -10))
                                                             #false
                                                             (make-posn 0 0)
                                                             60
                                                             (rectangle 0 0 "solid" "white"))
                                           '("a")))
               
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" ""))
                                                 (make-character (make-posn 128 118)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn 0 -10))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '("a")))

; Test 4 - Charecter standing on block with gravity
(check-expect (update-pos (make-game-state #true
                                           (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "" "" "" "" "" "" "" "" "" "")
                                                                   (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                             (make-character (make-posn 128 416)
                                                                             "DrAdriano"
                                                                             #false
                                                                             (make-posn 64 64)
                                                                             #false
                                                                             (make-posn 0 10))
                                                             #false
                                                             (make-posn 0 0)
                                                             60
                                                             (rectangle 0 0 "solid" "white"))
                                           '("a")))
               
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1" "b1"))
                                                 (make-character (make-posn 128 416)
                                                                 "DrAdriano"
                                                                 #false
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn 0 10))
                                                 #false
                                                 (make-posn 0 0)
                                                 60
                                                 (rectangle 0 0 "solid" "white"))
                               '("a")))


;; TEMPLATE
; (define (update-pos state)
;   ... (character-pos state) ...
;   ... (character-momentum state) ...
;   ... (character-lives state) ...
;   ... (character-type state) ...
;   ... (character-states state) ...
;   ... character ...)

;; IMPLEMENTATION
(define (update-pos state)
  (cond [(legal-movement? (character-size (level-state-character (game-state-active-state state)))
                          (make-posn (round (+ (posn-x (character-pos (level-state-character (game-state-active-state state))))
                                               (posn-x (character-momentum (level-state-character (game-state-active-state state))))))
                                     (round (+ (posn-y (character-pos (level-state-character (game-state-active-state state))))
                                               (posn-y (character-momentum (level-state-character (game-state-active-state state)))))))
                          (level-state-grid (game-state-active-state state))
                          GRID-SIZE
                          "")
         (make-game-state (game-state-is-running state)
                          (make-level-state (level-state-grid (game-state-active-state state))
                                            (make-character (make-posn(round (+ (posn-x (character-pos (level-state-character (game-state-active-state state))))
                                                                                (posn-x (character-momentum (level-state-character (game-state-active-state state))))))
                                                                      (round (+ (posn-y (character-pos (level-state-character (game-state-active-state state))))
                                                                                (posn-y (character-momentum (level-state-character (game-state-active-state state)))))))
                                                            (character-type (level-state-character (game-state-active-state state)))
                                                            (character-states (level-state-character (game-state-active-state state)))
                                                            (character-size (level-state-character (game-state-active-state state)))
                                                            (character-lives (level-state-character (game-state-active-state state)))
                                                            (character-momentum (level-state-character (game-state-active-state state))))
                                            (level-state-enemies(game-state-active-state state))
                                            (level-state-startpos (game-state-active-state state))
                                            (level-state-timer (game-state-active-state state))
                                            (level-state-background (game-state-active-state state)))
                          (game-state-key-pressed state))]
        [else state]))




; Function tick 

;; DATA TYPE DEFINITION
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT
; Signature:
; tick : GameState -> GameState

; Purpose statement:
; Is responsible for handling everything that should happen in real time such as gravity, collisions, animations, etc (applies these features to a given GameState, returns the updated version of the GameState)

; Header:
;(define (tick state) state)

;; EXAMPLES:
; Test 1 - The character starts to fall (only the momentum is updated NOT the position yet)
(check-expect (tick (make-game-state #true
                                     (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" "")
                                                             (list "" "" "" "" "" "" "" "" "" ""))
                                                       (make-character (make-posn 128 128)
                                                                       "DrAdriano"
                                                                       (list (make-character-state "Right" 0 RUN-RIGHT #false 0))
                                                                       (make-posn 64 64)
                                                                       #false
                                                                       (make-posn 0 0))
                                                       #false
                                                       (make-posn 0 0)
                                                       60
                                                       (rectangle 0 0 "solid" "white"))
                                     '()))
              (make-game-state #true
                               (make-level-state (list (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" "")
                                                       (list "" "" "" "" "" "" "" "" "" ""))
                                                 (make-character (make-posn 128 128)
                                                                 "DrAdriano"
                                                                 (list (make-character-state "Idle" 1 DRADRIANO-IDLE #false 0))
                                                                 (make-posn 64 64)
                                                                 #false
                                                                 (make-posn
                                                                  0
                                                                  (+ 0 (/ GRAVITY FPS))))
                                                 #false
                                                 (make-posn 0 0)
                                                 60 
                                                 (rectangle 0 0 "solid" "white"))
                               '()))

; See tests in all AUX functions used - no major other tests needed for on-tick.

;; TEMPLATE:
; (define (tick state)
;  ... (game-state-is-running state) ...
;  ... (game-state-active-state state) ...
;  ... (game-state-key-pressed state) ...
;  ... state ...)
 
;; IMPLEMENTATION:
(provide tick)
(define (tick state)
  (cond
    [(level-state? (game-state-active-state state))
     (cond [(>= (posn-y (character-pos (level-state-character (game-state-active-state state)))) (- SCREEN-HEIGHT (quotient (posn-y (character-size (level-state-character (game-state-active-state state)))) 2)))
            (restart state)]

           [(not (legal-movement? (character-size (level-state-character (game-state-active-state state)))
                                  (character-pos (level-state-character (game-state-active-state state)))
                                  (level-state-grid (game-state-active-state state))
                                  GRID-SIZE
                                  "end"))
            (make-game-state
             ; can treat as soft reset - defaults for game-state
             (game-state-is-running state)
             (make-menu-state
              (menu-state-buttons YOUWON)
              (menu-state-text YOUWON)
              (menu-state-background YOUWON)
              (+ (current-seconds) 3)
              (menu-state-endtime-action YOUWON)
              (menu-state-key-actions YOUWON)
              )
             (game-state-key-pressed state)
             )]
             
           [else (gravity (update-pos (update-frames (update-keys state))))])]
    [
     (menu-state? (game-state-active-state state))
     ; the current state is a menustate, so firstly check for high priority processes (timer, key presses, and clicks) and if there are no "actions" just return the same state
     (cond [
            ; check if the end time of the menu-state has been reached (current-seconds >= end)
            (and
             ; short circuit eval - check it's a number first, only if it's a number check it's also been elapsed
             (number? (menu-state-endtime (game-state-active-state state)))
             (<= (menu-state-endtime (game-state-active-state state)) (current-seconds))
             )
            ; menu-state has an endtime, HAS been reached / exceeded, so check the "action" for what to do next:
            (handle-action (menu-state-endtime-action (game-state-active-state state)) state)
            ]
           [
            ; no "relevant" timer - check key presses next
            ; IF there are relevant key presses... (keys which are relevant to that menu-state, AND being pressed right now)
            (and
             (list?
              (menu-state-key-actions (game-state-active-state state))) ; check there are actual actions to do 
             (not
              (empty?
               (menu-state-key-actions (game-state-active-state state)))) ; check there are actual actions to do 
             (not
              (empty?
               (filter
                (lambda (n) (member? (first n) (game-state-key-pressed state))) ; procedure - take first element of key-action pair and check for value in keypressed state
                (menu-state-key-actions (game-state-active-state state)) ; lst to check on - the key action pairs
                ; get actual keys pressed = (game-state-key-pressed state)
                ; get menu-state keys = (game-state-active-state (menu-state-key-actions state))
                )
               )
              )
             )
            ; we'll only handle "one action" at once, so even if multiple keys are pressed in menu, just accept the first one in list (key pressed first)
            (handle-action
             (list-ref
              ; take the SECOND element of that "first" list i.e. (not the key) but, the ACTION
              (first ; get the first action to handle
               (filter
                (lambda (n) (member? (first n) (game-state-key-pressed state))) ; procedure - take first element of key-action pair and check for value in keypressed state
                (menu-state-key-actions (game-state-active-state state)) ; lst to check on - the key action pairs
                )
               )
              1
              )
             state
             )
            ]
           [
            else
            ; no "relevant" timer, or key presses - check mouse next (look for mouse in rect field of buttons)

            ; check 1 - do we even have buttons?
            (cond
              [
               (not
                (or
                 (equal? #false (menu-state-buttons (game-state-active-state state))) ; no buttons
                 (not (empty? (menu-state-buttons (game-state-active-state state)))) ; no buttons expressed differently
                 )
                )
               

               ; if our mouse position is in any of the rectangular fields of any of the buttons...
               (local [
                       ; we only EVER have one mouse-key at most in the game...
                       (define CURSOR-POS (mouse-key-pos (first (filter mouse-key? (game-state-key-pressed)))))
                       (define CURSOR-STATUS (mouse-key-status (first (filter mouse-key? (game-state-key-pressed)))))
                       ]
                 (handle-action
                  (first ; do the first activated button's action
                   (filter
                    (not (boolean?)) ; keep only the actual action values and NOT the #false
                    (filter (lambda ; take all relevant buttons, and get relevant actions
                                (n)
                              (cond
                                [
                                 ; in trigger field & click active
                                 (and
                             
                                  ; action was a click
                                  (equal? CURSOR-STATUS "click")
                             
                                  ; trigger field exists
                                  (posn? (rectangular-button-element-trigger-field n))
                             
                                  ; mouse is in trigger field
                                  (in-rectangular-field?
                                   CURSOR-POS
                                   (rectangular-button-element-trigger-field n))
                                  )

                                 ; return the trigger action
                                 (rectangular-button-element-trigger-action n)
                                 ]
                                [
                                 (and
                              
                                  ; action was a hover
                                  (equal? CURSOR-STATUS "hover")

                                  ; hover field exists
                                  (posn? ((rectangular-button-element-hover-field n) n))
                              
                                  ; mouse is in hover field
                                  (in-rectangular-field?
                                   CURSOR-POS
                                   (rectangular-button-element-hover-field n))
                                  )

                                 ; return the hover action
                                 (rectangular-button-element-hover-action n)
                                 ]
                                [
                                 ; no field triggered
                                 else
                                 #false
                                 ]
                                )
                              )
                            (filter ; right now we only care about rectangular buttons [MVP++]
                             rectangular-button-element?
                             (menu-state-buttons (game-state-active-state state))
                             )
                            )
                    )
                   )
                  state
                  )
                 )
               ]
              [
               else
               state
               ]
              )
            ]
           )
     ]
    )
  )


; Function handle-action

;; DATA TYPE DEFINITION:
; String - built-in
; GameState - defined in definitions.rkt

;; INPUT/OUTPUT:
; Signature:
; handle-action : String GameState -> GameState

; Purpose statement:
; Returns an appropriately updated GameState depending on an action given (for example changes the entire state to a different screen)

; Header:
; (define (handle-action "test" state) state)

;; EXAMPLES:
; Test 1 - gets the LEVELONE
(check-expect (handle-action "start:LEVELONE" TEST-GAME-STATE)
              LEVELONE)

; Test 2 - gets the GAMEOVER menu
(check-expect (handle-action "start:gameOver" TEST-GAME-STATE)
              (make-game-state (game-state-is-running TEST-GAME-STATE)
                               (make-menu-state (menu-state-buttons GAMEOVER)
                                                (menu-state-text GAMEOVER)
                                                (menu-state-background GAMEOVER)
                                                (+ (current-seconds) 3)
                                                (menu-state-endtime-action GAMEOVER)
                                                (menu-state-key-actions GAMEOVER))
                               (game-state-key-pressed TEST-GAME-STATE)))

; Test 3 - gets the SPLASH menu
(check-expect (handle-action "start:SPLASH" TEST-GAME-STATE)
              (make-game-state #true 
                               (make-menu-state (menu-state-buttons SPLASH)
                                                (menu-state-text SPLASH)
                                                (menu-state-background SPLASH)
                                                (+ (current-seconds) 3)
                                                (menu-state-endtime-action SPLASH)
                                                (menu-state-key-actions SPLASH))
                               '()))

; Test 4 - gets the same state, because the action is incorrect
(check-expect (handle-action "test" TEST-GAME-STATE)
              TEST-GAME-STATE)

;; TEMPLATE:
;(define (handle-action action state)
;     ... (game-state-is-running state) ...
;     ... (game-state-active-state state) ...
;     ... (game-state-key-pressed state) ...
;     ... state ...
;     ... action ...)

;; IMPEMENTATION:
(define (handle-action action state)
  (cond
    [(equal? action "start:LEVELONE")
     LEVELONE]
    [(equal? action "start:gameOver")
     (make-game-state (game-state-is-running state)
                      (make-menu-state (menu-state-buttons GAMEOVER)
                                       (menu-state-text GAMEOVER)
                                       (menu-state-background GAMEOVER)
                                       (+ (current-seconds) 3)
                                       (menu-state-endtime-action GAMEOVER)
                                       (menu-state-key-actions GAMEOVER))
                      (game-state-key-pressed state))]
    ; can treat as soft reset - defaults for game-state
    [(equal? action "start:SPLASH")
     (make-game-state #true 
                      (make-menu-state (menu-state-buttons SPLASH)
                                       (menu-state-text SPLASH)
                                       (menu-state-background SPLASH)
                                       (+ (current-seconds) 3)
                                       (menu-state-endtime-action SPLASH)
                                       (menu-state-key-actions SPLASH))
                      '())]
    ; action is invalid - do nothing / return the normal state
    [else state]))