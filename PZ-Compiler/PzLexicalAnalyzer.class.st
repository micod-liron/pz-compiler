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
	(self isString: aString) ifTrue: [^#string].
	(self isInteger: aString) ifTrue: [^#integer].
	(self isDouble: aString) ifTrue: [^#double].
	(self isLineComment: aString) ifTrue: [^#lineComment].
	(self isBlockComment: aString) ifTrue: [^#blockComment].
	^#invalid.
]

{ #category : #'class initialization' }
PzLexicalAnalyzer class >> initialize [ 
	Keywords := #('public' 'private' 'class' 'int' 'string' 'bool' 'if' 'while' 'true' 'false').
	SpecialSymbols := #('(' ')' '[' ']' '{' '}' '&&' '||' '+' '-' '*' '/' '%' '.' ',').
]

{ #category : #testing }
PzLexicalAnalyzer class >> isBlockComment: aString [
	(aString isNil or: [aString isEmpty]) ifTrue: [^false].
	^(aString beginsWith: '/*') and: [(aString endsWith: '*/') and: [aString size >= 4]]
]

{ #category : #testing }
PzLexicalAnalyzer class >> isDouble: aString [
	| digits dots |
	digits := 0.
	dots := 0.
	aString do: [ :c |
		c isDigit ifTrue: [digits := digits+1].
		c = $. ifTrue: [dots := dots+1].
	].
	^dots = 1 and: [digits = (aString size-1)]
]

{ #category : #testing }
PzLexicalAnalyzer class >> isIdentifier: aString [
	(aString isNil | aString isEmpty) ifTrue: [^false].
	^(self isKeyword: aString) not & (aString first = $_ | (aString first isDigit not & aString first isAlphaNumeric)) & (aString size > 1 ifTrue: [self onlyIdentifierChars: aString] ifFalse: [true]).
]

{ #category : #testing }
PzLexicalAnalyzer class >> isIncomplete: aString [
	(aString isNil or: [aString isEmpty]) ifTrue: [^false].
	aString first = $" ifTrue: [^aString size > 1 and: [aString last ~= $"]].
	aString first = $/ ifTrue: [^true].
	((aString beginsWith: '/*') and: [(self isBlockComment: aString) not]) ifTrue: [^true].
	^false.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isInteger: aString [
	^aString isAllDigits.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isKeyword: aString [
	^Keywords includes: aString.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isLineComment: aString [ 
	(aString isNil or: [aString isEmpty]) ifTrue: [^false].
	^(aString beginsWith: '//') and: [aString last ~= Character cr]
]

{ #category : #testing }
PzLexicalAnalyzer class >> isSpecialSymbol: aString [
	^SpecialSymbols includes: aString.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isString: aString [
	^(aString isNotEmpty) and: [aString first = $" and: [(aString size > 1) and: [aString last = $"]]].
]

{ #category : #testing }
PzLexicalAnalyzer class >> isValidToken: aString [
	^(self classify: aString) ~= #invalid.
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
	| tokenString concat incomplete nextIsInvalid token|
	self removeWhitespace.
	codeStreamer isEndOfText ifTrue: [ ^nil ].
	concat := String new writeStream.
	incomplete := false.
	nextIsInvalid := false.
	[codeStreamer isEndOfText not and: [incomplete or: [nextIsInvalid not]]]
		whileTrue: [
			tokenString := concat contents.
			concat nextPut: codeStreamer getNextChar.
			incomplete := self class isIncomplete: tokenString.
			nextIsInvalid := (self class isValidToken: tokenString) and: [(self class isValidToken: concat contents) not].
	].
	nextIsInvalid ifTrue: [codeStreamer ungetLastChar].
	codeStreamer isEndOfText ifTrue: [tokenString := concat contents].
	token := PzToken type: (self class classify: tokenString) value: tokenString.
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
