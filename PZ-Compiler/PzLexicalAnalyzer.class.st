Class {
	#name : #PzLexicalAnalyzer,
	#superclass : #Object,
	#instVars : [
		'codeStreamer',
		'readTokens',
		'ungetTokens'
	],
	#classVars : [
		'keywords',
		'specialSymbols'
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
	keywords := #('public' 'private' 'class' 'int' 'string' 'bool' 'if' 'while' 'true' 'false').
	specialSymbols := #('(' ')' '[' ']' '{' '}' '&&' '||' '+' '-' '*' '/' '%' '.' ',').
]

{ #category : #testing }
PzLexicalAnalyzer class >> isIdentifier: aString [
	^(self isKeyword: aString) not & aString isNotNil & aString isNotEmpty & (aString first = $_ | (aString first isDigit not & aString first isAlphaNumeric)) & (aString size > 1 ifTrue: [self onlyIdentifierChars: aString] ifFalse: [true]).
]

{ #category : #testing }
PzLexicalAnalyzer class >> isKeyword: aString [
	^keywords includes: aString.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isSpecialSymbol: aString [
	^specialSymbols includes: aString.
]

{ #category : #testing }
PzLexicalAnalyzer class >> onlyIdentifierChars: aString [
	^aString allSatisfy: [ :c | c = $_ or: [ c isAlphaNumeric ]].
]

{ #category : #accessing }
PzLexicalAnalyzer >> code: aString [
	codeStreamer code: aString.
]

{ #category : #streaming }
PzLexicalAnalyzer >> getNextToken [
	| tokenStr kindOf wasValid validType validStr |
	ungetTokens isEmpty ifFalse: [ ^ungetTokens pop ].
	tokenStr := ''.
	wasValid := false.
	(codeStreamer isEndOfText) whileFalse: [ 
		| char |
		char := codeStreamer getNextChar.
		tokenStr := tokenStr copyWith: char.
		kindOf := PzLexicalAnalyzer classify: tokenStr.
		(kindOf ~= #invalid) ifTrue: [
			wasValid := true.
			validType := kindOf.
			validStr := tokenStr.
		]
		ifFalse: [
			wasValid ifTrue: [ 
				| token |
				codeStreamer ungetLastChar.
				token := PzToken type: validType value: validStr row: 0 col: 0.
				readTokens push: token.
				^token.
			]
		]
	].
	kindOf := PzLexicalAnalyzer classify: tokenStr. " TODO"
]

{ #category : #initialization }
PzLexicalAnalyzer >> initialize [
	codeStreamer := PzSourceCodeStream new.
	readTokens := Stack new.
	ungetTokens := Stack new.
]

{ #category : #streaming }
PzLexicalAnalyzer >> ungetLastToken [
	^nil.
]
