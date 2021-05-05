tests
testCode
	| codeStreamer text |
	codeStreamer := PzSourceCodeStream new.
	text := 'abcd'.
	codeStreamer code: text.
	self assert: codeStreamer code equals: text.