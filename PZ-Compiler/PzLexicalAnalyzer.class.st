Class {
	#name : #PzLexicalAnalyzer,
	#superclass : #Object,
	#instVars : [
		'codeStreamer',
		'keywords',
		'specialSymbols'
	],
	#category : #'PZ-Compiler'
}

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
	keywords := #('public' 'private' 'class' 'int' 'string' 'bool' 'if' 'while' 'true' 'false').
	specialSymbols := #('(' ')' '[' ']' '{' '}' '&&' '||' '+' '-' '*' '/' '%' '.' ',').
]

{ #category : #streaming }
PzLexicalAnalyzer >> ungetLastToken [
	^nil.
]
