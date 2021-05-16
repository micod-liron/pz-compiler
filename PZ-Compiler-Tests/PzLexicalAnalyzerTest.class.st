Class {
	#name : #PzLexicalAnalyzerTest,
	#superclass : #TestCase,
	#instVars : [
		'lexer'
	],
	#category : #'PZ-Compiler-Tests'
}

{ #category : #running }
PzLexicalAnalyzerTest >> setUp [
	super setUp.
	lexer := PzLexicalAnalyzer new.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testClassify [
	self assert: (PzLexicalAnalyzer classify: 'public') equals: #keyword.
	self assert: (PzLexicalAnalyzer classify: 'foo') equals: #identifier.
	self assert: (PzLexicalAnalyzer classify: '&&') equals: #specialSymbol.
	self assert: (PzLexicalAnalyzer classify: 'f§ug.b§') equals: #invalid.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testIsDouble [
	self assert: (lexer class isDouble: '42.42').
	self assert: (lexer class isDouble: '42') not.
	self assert: (lexer class isDouble: 'abc') not.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testIsIdentifier [
	self assert: (PzLexicalAnalyzer isIdentifier: 'foo') equals: true.
	self assert: (PzLexicalAnalyzer isIdentifier: '_foo') equals: true.
	self assert: (PzLexicalAnalyzer isIdentifier: 'foo1') equals: true.
	self assert: (PzLexicalAnalyzer isIdentifier: '_foo1') equals: true.
	self assert: (PzLexicalAnalyzer isIdentifier: '_fo_o1') equals: true.
	self assert: (PzLexicalAnalyzer isIdentifier: '1foo') equals: false.
	self assert: (PzLexicalAnalyzer isIdentifier: 'foo.') equals: false.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testIsIncomplete [
	self assert: (lexer class isIncomplete: '"hello').
	self assert: (lexer class isIncomplete: 'abc') not.
	self assert: (lexer class isIncomplete: '123') not.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testIsInteger [
	self assert: (lexer class isInteger: '42').
	self assert: (lexer class isInteger: 'abc') not.
	self assert: (lexer class isInteger: '42abc') not.
	self assert: (lexer class isInteger: 'abc42') not.
	self assert: (lexer class isInteger: '42.42') not.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testIsKeyword [
	self assert: (PzLexicalAnalyzer isKeyword: 'public') equals: true.
	self assert: (PzLexicalAnalyzer isKeyword: 'politics') equals: false.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testIsSpecialSymbol [
	self assert: (PzLexicalAnalyzer isSpecialSymbol: '&&') equals: true.
	self assert: (PzLexicalAnalyzer isSpecialSymbol: '^') equals: false.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testIsString [
	self assert: (lexer class isString: '"hello world"').
	self assert: (lexer class isString: '"hello') not.
	self assert: (lexer class isString: '"hello"w') not.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testIsValidToken [
	self assert: (lexer class isValidToken: 'abc').
	self assert: (lexer class isValidToken: '42').
	self assert: (lexer class isValidToken: '42.42').
	self assert: (lexer class isValidToken: '(').
	self assert: (lexer class isValidToken: '"abc"').
	self assert: (lexer class isValidToken: '"abc') not.
	self assert: (lexer class isValidToken: '42..42') not.
]

{ #category : #tests }
PzLexicalAnalyzerTest >> testOnlyIdentifierChars [
	self assert: (PzLexicalAnalyzer onlyIdentifierChars: '_a1') equals: true.
	self assert: (PzLexicalAnalyzer onlyIdentifierChars: '_a1!') equals: false.
]
