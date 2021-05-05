Class {
	#name : #PzSourceCodeStreamTest,
	#superclass : #TestCase,
	#category : #'PZ-Compiler-Tests'
}

{ #category : #tests }
PzSourceCodeStreamTest >> testCode [
	| codeStreamer text |
	codeStreamer := PzSourceCodeStream new.
	text := 'abcd'.
	codeStreamer code: text.
	self assert: codeStreamer code equals: text.
]

{ #category : #tests }
PzSourceCodeStreamTest >> testGetNextChar [
	| codeStreamer |
	codeStreamer := PzSourceCodeStream new.
	codeStreamer code: 'ab'.
	self assert: codeStreamer getNextChar equals: $a.
	self assert: codeStreamer getNextChar equals: $b.
	self assert: codeStreamer getNextChar equals: nil.
]

{ #category : #test }
PzSourceCodeStreamTest >> testIsEndOfText [
	| codeStreamer |
	codeStreamer := PzSourceCodeStream new.
	codeStreamer code: 'a'.
	self assert: codeStreamer isEndOfText equals: false.
	codeStreamer getNextChar.
	self assert: codeStreamer isEndOfText equals: true.
]

{ #category : #tests }
PzSourceCodeStreamTest >> testUngetLastChar [
	| codeStreamer |
	codeStreamer := PzSourceCodeStream new.
	codeStreamer code: 'ab'.
	codeStreamer getNextChar.
	codeStreamer ungetLastChar.
	self assert: codeStreamer getNextChar equals: $a.
]
