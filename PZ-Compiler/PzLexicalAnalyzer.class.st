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
	| char row col type |
	self removeWhitespace.
	codeStreamer isEndOfText ifTrue: [ ^nil ].
	"TODO: repeatedly get and classify"
	
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

{ #category : #testing }
PzLexicalAnalyzer >> isValidToken: aString [
	^(self class isIdentifier: aString) or: [(self class isKeyword: aString) or: [self class isSpecialSymbol: aString]]
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
