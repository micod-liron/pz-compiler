Class {
	#name : #PzLexicalAnalyzer,
	#superclass : #Object,
	#instVars : [
		'codeStreamer',
		'readTokens',
		'ungetTokens'
	],
	#classVars : [
		'Keywords',
		'SpecialSymbols'
	],
	#category : #'PZ-Compiler'
}

{ #category : #testing }
PzLexicalAnalyzer class >> classify: aString [
	(self isIdentifier: aString) ifTrue: [ ^#identifier ].
	(self isKeyword: aString) ifTrue: [ ^#keyword ].
	(self isSpecialSymbol: aString) ifTrue: [ ^#specialSymbol ].
	^#invalid.
]

{ #category : #'class initialization' }
PzLexicalAnalyzer class >> initialize [ 
	Keywords := #('public' 'private' 'class' 'int' 'string' 'bool' 'if' 'while' 'true' 'false').
	SpecialSymbols := #('(' ')' '[' ']' '{' '}' '&&' '||' '+' '-' '*' '/' '%' '.' ',').
]

{ #category : #testing }
PzLexicalAnalyzer class >> isIdentifier: aString [
	^aString isEmpty not & (self isKeyword: aString) not & aString isNotNil & aString isNotEmpty & (aString first = $_ | (aString first isDigit not & aString first isAlphaNumeric)) & (aString size > 1 ifTrue: [self onlyIdentifierChars: aString] ifFalse: [true]).
]

{ #category : #testing }
PzLexicalAnalyzer class >> isIncomplete: aString [
	aString first = $" ifTrue: [^aString size > 1 and: [aString last ~= $"]].
	^false.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isKeyword: aString [
	^Keywords includes: aString.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isSpecialSymbol: aString [
	^SpecialSymbols includes: aString.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isValidToken: aString [
	^(self isIdentifier: aString) or: [(self isKeyword: aString) or: [self isSpecialSymbol: aString]]
]

{ #category : #testing }
PzLexicalAnalyzer class >> onlyIdentifierChars: aString [
	^aString allSatisfy: [ :c | c = $_ or: [ c isAlphaNumeric ]].
]

{ #category : #accessing }
PzLexicalAnalyzer >> code: aString [
	codeStreamer code: aString.
	readTokens removeAll.
	ungetTokens removeAll.
]

{ #category : #streaming }
PzLexicalAnalyzer >> getNextToken [
	| token |
	ungetTokens ifNotEmpty: [ ^readTokens push: ungetTokens pop ].
	self isEndOfText ifTrue: [ ^nil ].
	token := self getTokenFromStream.
	token ifNil: [ ^nil ] ifNotNil: [
		readTokens push: token.
		^token
	]
]

{ #category : #private }
PzLexicalAnalyzer >> getTokenFromStream [
	| row col tokenString concat incomplete nextIsInvalid token|
	self removeWhitespace.
	codeStreamer isEndOfText ifTrue: [ ^nil ].
	row := codeStreamer row.
	col := codeStreamer col.
	concat := String new writeStream.
	incomplete := false. "(self class isIncomplete: concat contents)"
	nextIsInvalid := false. "(self class isValidToken: tokenString) ~= true and: [(self class isValidToken: concat contents) ~= false]"
	[codeStreamer isEndOfText not and: [incomplete or: [nextIsInvalid not]]]
		whileTrue: [
			tokenString := concat contents.
			Transcript show: tokenString; cr.
			concat nextPut: codeStreamer getNextChar.
			incomplete := self class isIncomplete: concat contents.
			nextIsInvalid := (self class isValidToken: tokenString) = true and: [(self class isValidToken: concat contents) = false].
	].
	nextIsInvalid ifTrue: [codeStreamer ungetLastChar].
	token := PzToken type: (self class classify: tokenString) value: tokenString row: row col: col.
	readTokens push: token.
	^token.
]

{ #category : #initialization }
PzLexicalAnalyzer >> initialize [
	codeStreamer := PzSourceCodeStream new.
	readTokens := Stack new.
	ungetTokens := Stack new.
]

{ #category : #testing }
PzLexicalAnalyzer >> isEndOfText [
	^ungetTokens isEmpty and: [ codeStreamer isEndOfText ]
]

{ #category : #removing }
PzLexicalAnalyzer >> removeWhitespace [
	| char |
	[ codeStreamer isEndOfText not and: [char := codeStreamer getNextChar. char isSeparator]] whileTrue.
	char isSeparator ifFalse: [ codeStreamer ungetLastChar ]
]

{ #category : #streaming }
PzLexicalAnalyzer >> ungetLastToken [
	readTokens ifEmpty: [ ^nil ].
	^ungetTokens push: readTokens pop.
]
