Class {
	#name : #PzSourceCodeStream,
	#superclass : #Object,
	#instVars : [
		'code',
		'pos'
	],
	#category : 'PZ-Compiler'
}

{ #category : #accessing }
PzSourceCodeStream >> code [

	^ code
]

{ #category : #accessing }
PzSourceCodeStream >> code: aString [
	code := aString.
	pos := aString isEmpty ifTrue: [0] ifFalse: [1].
]

{ #category : #streaming }
PzSourceCodeStream >> getNextChar [
	(pos between: 1 and: code size)
		ifTrue: [ | ret |
			ret := code at: pos.
			pos := pos + 1.
			^ret
		]
		ifFalse: [ ^nil ]
]

{ #category : #initialization }
PzSourceCodeStream >> initialize [
	code := String new.
	pos := -1.
]

{ #category : #streaming }
PzSourceCodeStream >> ungetLastChar [
	pos := pos-1 max: 1
]
