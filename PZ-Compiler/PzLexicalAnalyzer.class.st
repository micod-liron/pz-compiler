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
	^(self isKeyword: aString) not & aString isNotNil & aString isNotEmpty & (aString first = $_ | (aString first isDigit not & aString first isAlphaNumeric)) & (aString size > 1 ifTrue: [self onlyIdentifierChars: aString] ifFalse: [true]).
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
	| token tokenStr kindOf wasValid validType validStr |
	self isEndOfText ifTrue: [ ^nil ].
	ungetTokens ifNotEmpty: [
		| ungetToken |
		ungetToken := ungetTokens pop.
		readTokens push: ungetToken.
		^ungetToken
	].
	tokenStr := ''.
	wasValid := false.
	[codeStreamer isEndOfText not and: [codeStreamer getNextChar isSeparator]] whileTrue.
	codeStreamer ungetLastChar.
	[codeStreamer isEndOfText] whileFalse: [ 
		| char |
		char := codeStreamer getNextChar.
		tokenStr := tokenStr copyWith: char.
		kindOf := self class classify: tokenStr.
		(kindOf ~= #invalid) ifTrue: [
			wasValid := true.
			validType := kindOf.
			validStr := tokenStr.
		]
		ifFalse: [
			wasValid ifTrue: [
				codeStreamer ungetLastChar.
				token := PzToken type: validType value: validStr row: 0 col: 0.
				readTokens push: token.
				^token.
			]
		]
	].
	kindOf := self class classify: tokenStr.
	token := PzToken type: kindOf value: tokenStr row: 0 col: 0.
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

{ #category : #streaming }
PzLexicalAnalyzer >> ungetLastToken [
	readTokens ifEmpty: [ ^nil ].
	^ungetTokens push: readTokens pop.
]
