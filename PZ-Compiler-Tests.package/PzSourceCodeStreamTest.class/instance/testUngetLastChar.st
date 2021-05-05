tests
testUngetLastChar
	| codeStreamer |
	codeStreamer := PzSourceCodeStream new.
	codeStreamer code: 'ab'.
	codeStreamer getNextChar.
	codeStreamer ungetLastChar.
	self assert: codeStreamer getNextChar equals: $a.