Class {
	#name : #KubernetesExamples,
	#superclass : #Object,
	#category : #'GtK8sDashboard-Examples'
}

{ #category : #accessing }
KubernetesExamples >> showDashboard [
	<gtExample>
	| myK8s |
	myK8s := Kubernetes new setup.
	^ myK8s showDashboard
]

{ #category : #'as yet unclassified' }
KubernetesExamples >> showNamespace [
	<gtExample>
	| myK8s |
	myK8s := Kubernetes new setup.
	^ myK8s showNamespace: 'kube-system'
]
