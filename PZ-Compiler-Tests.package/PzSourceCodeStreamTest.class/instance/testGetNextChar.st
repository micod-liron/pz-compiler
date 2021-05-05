tests
testGetNextChar
	| codeStreamer |
	codeStreamer := PzSourceCodeStream new.
	codeStreamer code: 'ab'.
	self assert: codeStreamer getNextChar equals: $a.
	self assert: codeStreamer getNextChar equals: $b.
	self assert: codeStreamer getNextChar equals: nil.