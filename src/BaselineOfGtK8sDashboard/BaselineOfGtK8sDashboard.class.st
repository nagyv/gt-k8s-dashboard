Class {
	#name : #BaselineOfGtK8sDashboard,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtK8sDashboard
}

{ #category : #loading }
BaselineOfGtK8sDashboard class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt-k8s-dashboard' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGtK8sDashboard >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'GtK8sDashboard'
		]
]
