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
KubernetesExamples >> showDashboardForColima [
	<gtExample>
	| myK8s |
	myK8s := Kubernetes withContext: 'colima'.
	myK8s setup.
	^ myK8s showDashboard
]

{ #category : #'as yet unclassified' }
KubernetesExamples >> showDashboardForTestConfig [
	<gtExample>
	| myK8s |
	myK8s := Kubernetes withConfig: '/Users/nagyv/tmp/test_kube_config.yaml'.
	myK8s setup.
	^ myK8s showDashboard
]

{ #category : #'as yet unclassified' }
KubernetesExamples >> showDashboardForTestConfigAndColima [
	<gtExample>
	| myK8s |
	myK8s := Kubernetes withConfigAndContext: '/Users/nagyv/tmp/test_kube_config.yaml' contextName: 'colima'.
	myK8s setup.
	^ myK8s showDashboard
]

{ #category : #'as yet unclassified' }
KubernetesExamples >> showNamespace [
	<gtExample>
	| myK8s |
	myK8s := Kubernetes new setup.
	^ myK8s showNamespace: 'kube-system'
]
