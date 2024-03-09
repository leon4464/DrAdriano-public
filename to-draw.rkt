;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname to-draw) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; LIBRARIES IMPORTED
(require 2htdp/image)
(require 2htdp/universe)
(require racket/sequence)
(require "definitions.rkt")
(require "base.rkt")


; Function move-level
; 80% completed

; Missing:
; - tests

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
; Number - built-in


;; INPUT/OUTPUT:
; Signature:
; move-level : GameState -> Number

; Purpose statement:
; Is responsible for moving the background, making the illusion that the player is moving

; Header:
;(define (move-level state) 0)

;; EXAMPLES:
; not needed because we can clearly see if something doesn't work by starting the game window

;; TEMPLATE:
;(define (move-level state)
;   ... (game-state-is-running state) ...
;   ... (game-state-active-state state) ...
;   ... (game-state-key-pressed state) ...
;   ... state ...)

;; IMPLEMENTATION:
(define (move-level state)
  (cond [(> (/ SCREEN-WIDTH 2) (posn-x (character-pos (level-state-character (game-state-active-state state))))) (/ DYNAMIC-BACKGROUND-WIDTH 2)]
        [(< (- DYNAMIC-BACKGROUND-WIDTH (/ SCREEN-WIDTH 2)) (posn-x (character-pos (level-state-character (game-state-active-state state))))) (* -1 (/ DYNAMIC-BACKGROUND-WIDTH))]
        [else (- (/ DYNAMIC-BACKGROUND-WIDTH 2) (* -1 (/ SCREEN-WIDTH 2)) (posn-x (character-pos (level-state-character (game-state-active-state state)))))]))


; Function draw-level

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
; Image - built-in

;; INPUT/OUTPUT:
; Signature:
; draw-level : GameState -> Image

; Purpose statement:
; returns an image containing all the blocks of the level at the right place

; Header:
; (define (draw-level state) Image)

;; EXAMPLES:
; not needed because we can clearly see if something doesn't work by starting the game window

;; TEMPLATE:
;(define (draw-level state)
;        ... (game-state-is-running state) ...
;        ... (game-state-active-state state) ...
;        ... (game-state-key-pressed state) ...
;        ... state ...)

;; IMPEMENTATION:
(define (draw-level state)
  (local [(define lst (level-state-grid (game-state-active-state state)))
          (define img (rectangle (* GRID-SIZE (length lst)) 720 0 "white"))]
    (begin (for ([l lst]
                 [r (sequence->list (in-range 0 (length lst)))])
             (for ([e l]
                   [c (sequence->list (in-range 0 (length l)))])
               (set! img (underlay/xy img
                                      (* GRID-SIZE c)
                                      (* GRID-SIZE r)
                                      (cond [(string=? e "b1") BLOCK1]
                                            [(string=? e "bT") BEAN-TOP]
                                            [(string=? e "bM") BEAN-MIDDLE]
                                            [(string=? e "g1") GROUND1]
                                            [(string=? e "g2") GROUND2]
                                            [(string=? e "gL") HOLE-LEFT-TOP]
                                            [(string=? e "gl") HOLE-LEFT-BOTTOM]
                                            [(string=? e "gR") HOLE-RIGHT-TOP]
                                            [(string=? e "gr") HOLE-RIGHT-BOTTOM]
                                            [(string=? e "p1") PLATFORM1]
                                            [(string=? e "pL") PLATFORM-LEFT]
                                            [(string=? e "pR") PLATFORM-RIGHT]
                                            [(string=? e "e0") END0]
                                            [(string=? e "e1") END1]
                                            [(string=? e "e2") END2]
                                            [(string=? e "e3") END3]
                                            [(string=? e "e4") END4]
                                            [(string=? e "e5") END5]
                                            [(string=? e "e6") END6]
                                            [(string=? e "e7") END7]
                                            [(string=? e "e8") END8]
                                            [(string=? e "s0") SIGN]
                                            [(string=? e "n0") BRIDGE0]
                                            [(string=? e "n1") BRIDGE1]
                                            [(string=? e "n2") BRIDGE2]
                                            [(string=? e "n3") BRIDGE3]
                                            [(string=? e "n4") BRIDGE4]
                                            [(string=? e "n5") BRIDGE5]
                                            [(string=? e "n6") BRIDGE6]
                                            [(string=? e "n7") BRIDGE7]
                                            [(string=? e "n8") BRIDGE8]
                                            [(string=? e "n9") BRIDGE9]
                                            [(string=? e "h0") HOLE0]
                                            [(string=? e "h1") HOLE1]
                                            [(string=? e "  ") (rectangle GRID-SIZE GRID-SIZE 0 "black")]
                                            [else (rectangle GRID-SIZE GRID-SIZE 128 "pink")])))))
           img)))


; Function player-stats

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
; Image - built-in

;; INPUT/OUTPUT:
; Signature:
; player-stats : GameState -> Image

; Purpose statement:
; Given a GameState returns an Image displaying the hears remaining

; Header:
; (define (player-stats state) Image)

;; EXAMPLES:
; not needed because we can clearly see if something doesn't work by starting the game window

;; TEMPLATE:
;(define (player-stats state)
;        ... (game-state-is-running state) ...
;        ... (game-state-active-state state) ...
;        ... (game-state-key-pressed state) ...
;        ... state ...)

;; IMPEMENTATION:
(define (player-stats state)
   (local [(define img STATIC-BACKGROUND)
           (define hearts (make-list (character-lives (level-state-character (game-state-active-state state))) "h"))
           (define no-hearts (make-list (- (character-lives (level-state-character (game-state-active-state LEVELONE))) (character-lives (level-state-character (game-state-active-state state)))) "n"))
           (define lst (append hearts no-hearts))]
     (begin (for ([i lst]
                  [x (sequence->list (in-range 0 (length lst)))])
              (cond [(equal? i "h")
                     (set! img (underlay/xy img
                                            (+ 10 (* 40 x))
                                            10
                                            HEART))]
                    [(equal? i "n")
                     (set! img (underlay/xy img
                                            (+ 10 (* 40 x))
                                            10
                                            NO-HEART))]))
           img)))


; Function render-character

;; DATA TYPE DEFINITION:
; GameState - defined in definitions.rkt
; Image - built-in

;; INPUT/OUTPUT:
; Signature:
; render-character : GameState -> Image

; Purpose statement:
; returns the right image of the character according to his states

; Header:
; (define (render-character state) Image)

;; EXAMPLES:
; not needed because we can clearly see if something doesn't work by starting the game window

;; TEMPLATE:
;(define (render-character state)
;        ... (game-state-is-running state) ...
;        ... (game-state-active-state state) ...
;        ... (game-state-is-running state) ...
;        ... state ...)

;; IMPEMENTATION:
(define (render-character state)
  (local [(define states (character-states (level-state-character (game-state-active-state state))))
          (define right (get-state states "Right"))
          (define left (get-state states "Left"))
          (define jump (get-state states "Jump"))
          (define idle (get-state states "Idle"))
          (define jump-left (get-state states "JumpLeft"))
          (define jump-right (get-state states "JumpRight"))
          (define frames 3)]
    
    (cond [(character-state? right)
           (local [(define frame (quotient (character-state-frame right)
                                               (quotient FPS
                                                         (* frames (length (character-state-sprite right))))))]
                 (list-ref (character-state-sprite right)
                           (- frame
                              (* 2 (quotient frame
                                             (length (character-state-sprite right)))))))]
              
              [(character-state? left)
               (local [(define frame (quotient (character-state-frame left)
                                               (quotient FPS
                                                         (* frames (length (character-state-sprite left))))))]
                 (list-ref (character-state-sprite left)
                           (- frame
                              (* 2 (quotient frame
                                             (length (character-state-sprite left)))))))]
              
              [(character-state? jump)
               (local [(define frame (quotient (character-state-frame jump)
                                               (quotient FPS
                                                         (* frames (length (character-state-sprite jump))))))]
                 (list-ref (character-state-sprite jump)
                           (- frame
                              (* 2 (quotient frame
                                             (length (character-state-sprite jump)))))))]
              [(character-state? jump-left)
               (local [(define frame (quotient (character-state-frame jump-left)
                                               (quotient FPS
                                                         (* frames (length (character-state-sprite jump-left))))))]
                 (list-ref (character-state-sprite jump-left)
                           (- frame
                              (* 2 (quotient frame
                                             (length (character-state-sprite jump-left)))))))]
              [(character-state? jump-right)
               (local [(define frame (quotient (character-state-frame jump-right)
                                               (quotient FPS
                                                         (* frames (length (character-state-sprite jump-right))))))]
                 (list-ref (character-state-sprite jump-right)
                           (- frame
                              (* 2 (quotient frame
                                             (length (character-state-sprite jump-right)))))))]
              
              [(character-state? idle)
               (local [(define frame (quotient (character-state-frame idle)
                                               (quotient FPS
                                                         (* frames (length (character-state-sprite idle))))))]
                 (list-ref (character-state-sprite idle)
                           (- frame
                              (* 2 (quotient frame
                                             (length (character-state-sprite idle)))))))]
              
              [else (rectangle 64 64 "solid" "red")])))
         


; Function draw

;; DATA TYPE DEFINITION
; GameState - defined in definitions.rkt
; Image - built-in

;; INPUT/OUTPUT
; Signature:
; draw : GameState -> Image

; Purpose statement:
; Is responsable for drawing the game

; Header:
; (define (draw state) image)

;; EXAMPLES:
; not needed because we can clearly see if something doesn't work by starting the game window

;; TEMPLATE
;(define (draw state)
;   ... (game-state-is-running state) ...
;   ... (game-state-active-state state) ...
;   ... state ...)

;; IMPLEMENTATION
(provide draw)
(define (draw state)
  (cond
    [(level-state? (game-state-active-state state))
     (place-image (place-image (render-character state)
                               (posn-x (character-pos (level-state-character (game-state-active-state state))))
                               (posn-y (character-pos (level-state-character (game-state-active-state state))))
                               (draw-level state))
                  (move-level state)
                  (/ DYNAMIC-BACKGROUND-HEIGHT 2)
                  (player-stats state))]
    [else
     (render-text
      (render-buttons
       (bitmap/file "img/Background.png")
       (menu-state-buttons (game-state-active-state state)))
      (menu-state-text (game-state-active-state state)))]))




; !!! THOSE FUNCTIONS ARE NOT YET COMPLETED !!!
; We ran out of time, so those functions are not yet tested. Run them at your own risk :|
; This doesn't have any consequences on the final product, it was just a detail :)


; function render-buttons - owner Leon - AUX method of draw (used to render menuStates)
; completed, needs testing and docs validation

;; DATA TYPE DEFINITIONS
; An img is an Image
; A buttons is a maybe<list<buttons>>
;
;
; interpretation:
; img          - an Image on which to render the button list given
; buttons      - is one of:
;     - a list<Button> consisting of buttons to render on the Image ; there are buttons to render
;     - #false                                                       ; there are no (more) buttons to render

;; INPUT/OUTPUT
; Signature:
; place-button : Image maybe<list<Button>> -> Image

;; PROBLEM STATEMENT
; Takes an Image, and a maybe<list<Button>>, and recursively goes through the list of buttons in order
; to render them onto the Image - i.e. rendering bg image of the buttons (& their text if applicable)
; (onto the correct part in terms of size and dimensions) of the Image)
;
; Where: The first button given is rendered first (so higher priority buttons to render should be first in the list)

;; HEADER
; (define (render-buttons Image list) Image)


;; EXAMPLES
; Test mapping
;  1  - no buttons                                 -> unadjusted Image
; 2-3 - button(s) without text, with background    -> Image with buttons rendered
; 4-5 - button(s) with text                        -> Image with buttons & text rendered
;  6  - buttons with no background or text         -> unadjusted Image

; Test 1 - returns an Image with the given background, and no buttons, when given this Image and no buttons (buttons is #false)
(check-expect
 (render-buttons
  (bitmap/file "img/Background_Dynamic.png")
  #false)
 (bitmap/file "img/Background_Dynamic.png")
 )
  

; Test 2 - adds a button to a given Image when given a list consisting of a single button
(check-expect
 (render-buttons
  (bitmap/file "img/Background_Dynamic.png")
  (list
   (make-rectangular-button-element
    (make-posn 50 50) ; render at 50x50
    (make-posn 200 200) ; size 200x200 px
    (rectangle 200 200 "solid" "gray") ; simple BG (for now) to check
    #false ; NO TEXT (for now)
    #false ; trigger-field not needed for render testing
    #false ; hover-field not needed for render testing
    #false ; trigger-action not needed for render testing
    #false ; hover-action not needed for render testing
    )
   )
  )
 (place-image
  (rectangle 200 200 "solid" "gray") ; simple BG (for now) to check
  50
  50
  (bitmap/file "img/Background_Dynamic.png")
  )
 )
 

; Test 3 - adds two buttons to a given scene when given a list consisting of two buttons
(check-expect
 (render-buttons
  (bitmap/file "img/Background_Dynamic.png")
  (list
   (make-rectangular-button-element
    (make-posn 50 50) ; render at 50x50
    (make-posn 200 200) ; size 200x200 px
    (rectangle 200 200 "solid" "gray") ; simple BG (for now) to check
    #false ; NO TEXT (for now)
    #false ; trigger-field not needed for render testing
    #false ; hover-field not needed for render testing
    #false ; trigger-action not needed for render testing
    #false ; hover-action not needed for render testing
    )
   (make-rectangular-button-element
    (make-posn 300 300) ; render at 300x300
    (make-posn 200 150) ; size 200x200 px
    (rectangle 200 150 "solid" "blue") ; simple BG (for now) to check
    #false ; NO TEXT (for now)
    #false ; trigger-field not needed for render testing
    #false ; hover-field not needed for render testing
    #false ; trigger-action not needed for render testing
    #false ; hover-action not needed for render testing
    )
   )
  )
 (place-image
  (rectangle 200 150 "solid" "blue")
  300
  300
  (place-image
   (rectangle 200 200 "solid" "gray") ; simple BG (for now) to check
   50
   50
   (bitmap/file "img/Background_Dynamic.png")
   )
  )
 )

; Test 4 - correctly adds text and a button when given a single button with text
(check-expect
 (render-buttons
  (bitmap/file "img/Background_Dynamic.png")
  (list
   (make-rectangular-button-element
    (make-posn 50 50) ; render at 50x50
    (make-posn 200 200) ; size 200x200 px
    (rectangle 200 200 "solid" "gray") ; simple BG (for now) to check
    (make-text-element ; text starts at rect start
     (text "Test 4" 11 "white")
     (make-posn 50 50))
    #false ; trigger-field not needed for render testing
    #false ; hover-field not needed for render testing
    #false ; trigger-action not needed for render testing
    #false ; hover-action not needed for render testing
    )
   )
  )
 (place-image
  (text "Test 4" 11 "white")
  50
  50
  (place-image
   (rectangle 200 200 "solid" "gray") ; simple BG (for now) to check
   50
   50
   (bitmap/file "img/Background_Dynamic.png")
   )
  )
 )

; Test 5 - correctly adds text and a button when given two buttons with text
(check-expect
 (render-buttons
  (bitmap/file "img/Background_Dynamic.png")
  (list
   (make-rectangular-button-element
    (make-posn 50 50) ; render at 50x50
    (make-posn 200 200) ; size 200x200 px
    (rectangle 200 200 "solid" "gray") ; simple BG (for now) to check
    (make-text-element ; text starts at rect start
     (text "Test 5b1" 11 "white")
     (make-posn 50 50))
    #false ; trigger-field not needed for render testing
    #false ; hover-field not needed for render testing
    #false ; trigger-action not needed for render testing
    #false ; hover-action not needed for render testing
    )
   (make-rectangular-button-element
    (make-posn 400 400) ; render at 400x400
    (make-posn 100 100) ; size 100x100 px
    (rectangle 100 100 "solid" "gray") ; simple BG (for now) to check
    (make-text-element ; text starts at rect start
     (text "Test 5b2" 11 "white")
     (make-posn 400 400))
    #false ; trigger-field not needed for render testing
    #false ; hover-field not needed for render testing
    #false ; trigger-action not needed for render testing
    #false ; hover-action not needed for render testing
    )
   )
  )
 (place-image
  (text "Test 5b2" 11 "white")
  400
  400
  (place-image
   (text "Test 5b1" 11 "white")
   50
   50
   (place-image
    (rectangle 100 100 "solid" "gray") ; simple BG (for now) to check
    400
    400
    (place-image
     (rectangle 200 200 "solid" "gray") ; simple BG (for now) to check
     50
     50
     (bitmap/file "img/Background_Dynamic.png")
     )
    )
   )
  )
 )

; Test 6 - adds no buttons when given a list of one button with no background
(check-expect
 (render-buttons
  (bitmap/file "img/Background_Dynamic.png")
  (list
   (make-rectangular-button-element
    (make-posn 50 50) ; render at 50x50
    (make-posn 200 200) ; size 200x200 px
    #false ; NO BUTTON (for now)
    #false ; NO TEXT (for now)
    #false ; trigger-field not needed for render testing
    #false ; hover-field not needed for render testing
    #false ; trigger-action not needed for render testing
    #false ; hover-action not needed for render testing
    )
   )
  )
 (bitmap/file "img/Background_Dynamic.png")
 )

;; TEMPLATE
;
;(define (render-buttons img buttons)
;  (cond
;    [
;     (
;      (equal? buttons #false)
;      (equal? buttons '())
;      )
;     img
;     ]
;    [
;     else
;     (cond
;       [
;        (equal? (rectangular-button-element-text-element (first buttons)) #false)
;        (... (place-image (first buttons) ...
;                          (render-buttons img (rest buttons)) ...))
;        ]
;       [else
;        (... (place-image (first buttons) ...
;                          (render-buttons img (rest buttons)) ...))
;        ]
;       )
;     ]
;    )
;  )
  

;; IMPLEMENTATION
(define (render-buttons img buttons)
  (cond
    ; base case - buttons is empty (return img) OR not even a list
    [
     (or
      (equal? buttons #false)
      (equal? buttons '())
      )
     img
     ]
  
    [
     else
     ; recursive call - buttons is NOT empty
     (cond
       ; need to handle 3 types of buttons - (NO BG, NO TXT), (BG, NO TXT), (BG, TXT)
       [
        ; button has valid background (type Image)
        (image? (rectangular-button-element-background (first buttons)))

        (cond
          [
           ; IF button has valid background (type Image) and NO TEXT
           (and
            (image? (rectangular-button-element-background (first buttons)))
            (equal? (rectangular-button-element-text-element (first buttons)) #false)
            )
           ; render bg only
           (place-image
            (rectangular-button-element-background (first buttons))
            (posn-x (rectangular-button-element-pos (first buttons)))
            (posn-y (rectangular-button-element-pos (first buttons)))
            (render-buttons img (rest buttons)) ; recursive call - placing on the Image returned by call stack (last placed on top)
            )
           ]
          [
           ; IF button has valid background (type Image) and TEXT
           (and
            (image? (rectangular-button-element-background (first buttons)))
            (image? (text-element-text (rectangular-button-element-text-element (first buttons))))
            )
           ; render text second ("on top", second)
           (place-image
            (text-element-text (rectangular-button-element-text-element (first buttons)))
            (posn-x (text-element-pos (rectangular-button-element-text-element (first buttons))))
            (posn-y (text-element-pos (rectangular-button-element-text-element (first buttons))))

            ; render text here
            (place-image
             (rectangular-button-element-background (first buttons))
             (posn-x (rectangular-button-element-pos (first buttons)))
             (posn-y (rectangular-button-element-pos (first buttons)))
             (render-buttons img (rest buttons)) ; recursive call - placing on the Image returned by call stack (last placed on top)
             )
            )
           ]
          [else
           ; ALL OTHER CASES either an invalid combo or an empty button, so render nothing
           (render-buttons img (rest buttons)) ; recursive call - placing on the Image returned by call stack (last placed on top)
           ]
          )
        ]
       [else
        ; nothing "to-do" with the image, return the image
        img
        ]
       )
     ]
    )
  )

; function render-text - owner Leon - AUX method of draw (used to render menuStates)
; completed, needs testing and docs validation

;; DATA TYPE DEFINITIONS
; An img is an Image
; A texts is a maybe<list<texts>
;
;
; interpretation:
; img          - an Image on which to render the text list given
; text         - is one of:
;     - a list<Text> consisting of Text to render on the Image ; there is individual text to render
;     - #false                                                 ; there are no (more) buttons to render

;; INPUT/OUTPUT
; Signature:
; render-text : Image maybe<list<Text>> -> Image

;; PROBLEM STATEMENT
; Takes an Image, and a maybe<list<Text>>, and recursively goes through the list of text in order
; to render them onto the Image - i.e. rendering the text (onto the correct part in terms of size and dimensions)
; of the Image)
; 
; Where: The first text given is rendered first (so higher priority text to render should be first in the list)

;; HEADER
; (define (render-text Image list) Image)

;; EXAMPLES
; Test mapping
;  1   - no text
; 2-3  - text

; Test 1 - returns a given Image as is when no text is given (text is #false)
(check-expect
 (render-text
  (bitmap/file "img/Background.png")
  #false)
 (bitmap/file "img/Background.png")
 )

; Test 2 - returns a given Image with text when text is given in right pos
(check-expect
 (render-text
  (bitmap/file "img/Background.png")
  (list
   (make-text-element (text "Test 2" 11 "white")
                      (make-posn 640 480))
   )
  )
 (place-image
  (text "Test 2" 11 "white")
  640
  480
  (bitmap/file "img/Background.png")
  )
 )

; Test 3 - returns a given Image with 2 different correctly placed texts when given a list of 2 text-elements
(check-expect
 (render-text
  (bitmap/file "img/Background.png")
  (list
   (make-text-element (text "Test 3b" 11 "white")
                      (make-posn 640 480))
   (make-text-element (text "Test 3a" 11 "white")
                      (make-posn 0 0))
   )
  )
 (place-image
  (text "Test 3a" 11 "white")
  0
  0
  (place-image
   (text "Test 3b" 11 "white")
   640
   480
   (bitmap/file "img/Background.png")
   )
  )
 )

;; TEMPLATE
; not yet completed


;; IMPLEMENTATION
(define (render-text img texts)
  (cond
    ; base case - texts is empty (return img) OR #false (never text in first place so just return img)
    [
     (or
      (equal? texts #false)
      (equal? texts '())
      )
     img
     ]
  
    [
     else
     ; recursive call - texts is NOT empty
     ; render the text and move on
     (place-image
      (text-element-text (first texts))
      (posn-x (text-element-pos (first texts)))
      (posn-y (text-element-pos (first texts)))
      (render-text img (rest texts))
      )
     ]
    )
  )