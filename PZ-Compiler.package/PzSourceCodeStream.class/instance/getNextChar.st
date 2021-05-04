streaming
getNextChar
	(pos between: 1 and: code size)
		ifTrue: [ :ret |
			ret = code at: pos.
			pos < code size ifTrue: [ pos := pos + 1].
			^ret
		]
		ifFalse: [ ^nil ]