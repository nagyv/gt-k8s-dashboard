Class {
	#name : #Kubernetes,
	#superclass : #Object,
	#instVars : [
		'isSetup',
		'contextName',
		'configPath'
	],
	#category : #GtK8sDashboard
}

{ #category : #'as yet unclassified' }
Kubernetes class >> withConfig: configPath [
	^ self new initializeWithConfig: configPath

]

{ #category : #'as yet unclassified' }
Kubernetes class >> withConfigAndContext: configPath contextName: contextName [
	^ self new initializeWithConfigAndContext: configPath contextName: contextName

]

{ #category : #'as yet unclassified' }
Kubernetes class >> withContext: contextName [
	^ self new initializeWithContext: contextName

]

{ #category : #'as yet unclassified' }
Kubernetes >> initialize [
    super initialize.
    isSetup := false
]

{ #category : #'as yet unclassified' }
Kubernetes >> initializeWithConfig: aConfigPath [
	super initialize.
	configPath := aConfigPath.
	^ self
]

{ #category : #'as yet unclassified' }
Kubernetes >> initializeWithConfigAndContext: aConfigPath contextName: aContextName [
	super initialize.
	contextName := aContextName.
	configPath := aConfigPath.
	^ self
]

{ #category : #'as yet unclassified' }
Kubernetes >> initializeWithContext: aContextName [
	super initialize.
	contextName := aContextName.
	^ self
]

{ #category : #accessing }
Kubernetes >> isSetup [
	^ isSetup
]

{ #category : #accessing }
Kubernetes >> isSetup: anObject [
	isSetup := anObject
]

{ #category : #'as yet unclassified' }
Kubernetes >> reload [
  PBApplication isRunning ifTrue: [ PBApplication stop ].
  self isSetup: false.
  ^ self setup
]

{ #category : #accessing }
Kubernetes >> setup [
	"Initialize the environment"
	| location target pbDir |
	self isSetup ifFalse: [
		PBApplication isRunning ifFalse: [ PBApplication start ].
		PBApplication uniqueInstance installModule: 'kubernetes'.
		PBPlatform current workingDirectory ensureCreateDirectory.
		
		"Symlink the src dir under the python path"
		target := (GtResourceReference path: 'nagyv/gt-k8s-dashboard/src/k8s_dashboard') fileReference fullName.
		pbDir := PBApplication uniqueInstance workingDirectory fullName.
		LibC runCommand: 'cd ', pbDir , ' && ln -s ', target .
		
		self isSetup: true.
	].
	
	^ self
]

{ #category : #'as yet unclassified' }
Kubernetes >> showDashboard [
	| dashboardCode configFileParam contextNameParam |
	self isSetup ifFalse: [self setup ].
	
	configFileParam := configPath 
		ifNil: [ 'None' ]
		ifNotNil: [ '"', configPath, '"' ].
		
	contextNameParam := contextName
		ifNil: [ 'None' ]
		ifNotNil: [ '"', contextName, '"' ].
	
	dashboardCode := '
from k8s_dashboard import k8s_dashboard
from kubernetes import config

"Configs can be set in Configuration class directly or using helper utility"

view = k8s_dashboard.Namespaces(config_file=', configFileParam, ', context_name=', contextNameParam, ')'.
	^ PBApplication do: [ :application | 
		application newCommandStringFactory 
			script: dashboardCode; 
			resultExpression: 'view';
			sendAndWait ]
]

{ #category : #'as yet unclassified' }
Kubernetes >> showNamespace: aNamespace [
	| python |
	python := '
from k8s_dashboard import k8s_dashboard
from kubernetes import config

"Configs can be set in Configuration class directly or using helper utility"

view = k8s_dashboard.Namespace("', aNamespace, '")'.
	^ PBApplication do: [ :application | 
		application newCommandStringFactory 
			script: python; 
			resultExpression: 'view';
			sendAndWait ]
	
]
