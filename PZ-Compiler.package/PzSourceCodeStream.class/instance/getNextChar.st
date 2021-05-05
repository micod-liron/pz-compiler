streaming
getNextChar
	(pos between: 1 and: code size)
		ifTrue: [ | ret |
			ret := code at: pos.
			pos := pos + 1.
			^ret
		]
		ifFalse: [ ^nil ]