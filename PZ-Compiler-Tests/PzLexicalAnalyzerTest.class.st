Class {
	#name : #PzLexicalAnalyzerTest,
	#superclass : #TestCase,
	#category : #'PZ-Compiler-Tests'
}

{ #category : #tests }
PzLexicalAnalyzerTest >> testClassify [
	self assert: (PzLexicalAnalyzer classify: 'public') equals: #keyword.
	self assert: (PzLexicalAnalyzer classify: 'foo') equals: #identifier.
	self assert: (PzLexicalAnalyzer classify: '&&') equals: #specialSymbol.
	self assert: (PzLexicalAnalyzer classify: 'f§ug.b§') equals: #invalid.
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
PzLexicalAnalyzerTest >> testOnlyIdentifierChars [
	self assert: (PzLexicalAnalyzer onlyIdentifierChars: '_a1') equals: true.
	self assert: (PzLexicalAnalyzer onlyIdentifierChars: '_a1!') equals: false.
]
