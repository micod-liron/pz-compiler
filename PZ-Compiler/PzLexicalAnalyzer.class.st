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
	| char row col |
	row := codeStreamer col.
	col := codeStreamer row.
	char := codeStreamer getNextChar.
	[ char isSeparator & codeStreamer isEndOfText not ] whileTrue: [
		row := codeStreamer row.
		col := codeStreamer col.
		char := codeStreamer getNextChar
	].
	codeStreamer isEndOfText ifTrue: [ ^nil ].
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
