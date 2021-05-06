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

{ #category : #'class initialization' }
PzLexicalAnalyzer class >> initialize [ 
	keywords := #('public' 'private' 'class' 'int' 'string' 'bool' 'if' 'while' 'true' 'false').
	specialSymbols := #('(' ')' '[' ']' '{' '}' '&&' '||' '+' '-' '*' '/' '%' '.' ',').
]

{ #category : #testing }
PzLexicalAnalyzer class >> isIdentifier: aString [
	^aString isNotNil and: [ aString isNotEmpty ].
]

{ #category : #testing }
PzLexicalAnalyzer class >> isKeyword: aString [
	^keywords contains: aString.
]

{ #category : #testing }
PzLexicalAnalyzer class >> isSpecialSymbol: aString [
	^specialSymbols contains: aString.
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
	^ 'token'.
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
