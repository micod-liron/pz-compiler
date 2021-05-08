Class {
	#name : #PzToken,
	#superclass : #Object,
	#instVars : [
		'type',
		'value',
		'valueString',
		'row',
		'col'
	],
	#category : #'PZ-Compiler'
}

{ #category : #initialization }
PzToken class >> type: aType value: aValue row: aRow col: aCol [
	^ self new
		type: aType;
		value: aValue;
		valueString: aValue printString;
		row: aRow;
		col: aCol;
		yourself.
]

{ #category : #accessing }
PzToken >> col [

	^ col
]

{ #category : #accessing }
PzToken >> col: anObject [

	col := anObject
]

{ #category : #printing }
PzToken >> printString [
	^ type asString,' ',value printString,' ',row printString,':',col printString.
]

{ #category : #accessing }
PzToken >> row [

	^ row
]

{ #category : #accessing }
PzToken >> row: anObject [

	row := anObject
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
PzToken >> value1 [

	^ value
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
