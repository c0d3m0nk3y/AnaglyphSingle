; Define the function:
(define (script-fu-anaglyph-single inImg)
	(gimp-image-undo-group-start inImg)
	(gimp-context-push)

	(let*
		(
			(imgH
				(car (gimp-image-height inImg))
			)
			(imgW
				(car (gimp-image-width inImg))
			)
			(imgWPlus
				(+ imgW 10)
			)
			(back
				(aref (cadr (gimp-image-get-layers inImg)) 0)
			)
			(right
				(car (gimp-layer-new inImg imgW imgH RGBA-IMAGE "Right" 100 NORMAL-MODE))
			)
		)
		
		; Insert new layer
		(gimp-image-add-layer inImg right 0)
		
		; Copy background to right
		(gimp-rect-select inImg 0 0 imgW imgH 2 FALSE 0)
		(gimp-edit-copy back)
		(gimp-edit-paste right TRUE)
		(gimp-floating-sel-anchor (car (gimp-image-get-floating-sel inImg)))
		
		; Translate the right layer
		(gimp-drawable-transform-scale 
		  right
		  10 0 imgWPlus imgH
		  0 2 TRUE 3 0
		)
		(gimp-floating-sel-anchor (car (gimp-image-get-floating-sel inImg)))
		
		; Set the colours and fill each layer in screen mode
		(gimp-context-set-foreground '(0 255 255))
		(gimp-context-set-background '(255 0 0))
		(gimp-selection-all inImg)
		(gimp-edit-bucket-fill right FG-BUCKET-FILL SCREEN-MODE 100 0 FALSE 0 0)
		(gimp-edit-bucket-fill back BG-BUCKET-FILL SCREEN-MODE 100 0 FALSE 0 0)

		; Switch the top layer to multiply mode
		(gimp-layer-set-mode right MULTIPLY-MODE)
	)
	
	(gimp-displays-flush)
	(gimp-context-pop)
	(gimp-image-undo-group-end inImg)

) ; End Define

(script-fu-register
  "script-fu-anaglyph-single"                             ;func name
  "Anaglyph from single image"                                       ;menu label
  "Converts a single image to Red/Cyan Anaglyph."  ;description
  "Ricky Oswald"                                     ;author
  "copyright 2016, Ricky Oswald"                                 ;copyright notice
  "02/01/2016"                                         ;date created
  "RGB, RGBA"                                         ;image type that the script works on
  SF-IMAGE        "Image"    0
)

(script-fu-menu-register "script-fu-anaglyph-single" "<Image>/Stereo")

