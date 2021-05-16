Class {
	#name : #PzToken,
	#superclass : #Object,
	#instVars : [
		'type',
		'value',
		'valueString'
	],
	#category : #'PZ-Compiler'
}

{ #category : #initialization }
PzToken class >> type: aType value: aValue [
	^ self new
		type: aType;
		value: aValue;
		valueString: aValue printString;
		yourself.
]

{ #category : #printing }
PzToken >> printString [
	^ self className,' ',type asString,' ',value printString.
]

{ #category : #accessing }
PzToken >> type [

	^ type
]

{ #category : #accessing }
PzToken >> type: anObject [

	type := anObject
]

{ #category : #accessing }
PzToken >> value: anObject [

	value := anObject
]

{ #category : #accessing }
PzToken >> valueString [

	^ valueString
]

{ #category : #accessing }
PzToken >> valueString: anObject [

	valueString := anObject
]
