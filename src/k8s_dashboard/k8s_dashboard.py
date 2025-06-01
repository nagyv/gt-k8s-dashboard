from abc import ABC, abstractmethod
from gtoolkit_bridge import gtView
from kubernetes import client, config

"Use to find how to call more APIs: https://github.com/kubernetes-client/python/blob/master/kubernetes/docs/CoreV1Api.md"

class ListView(ABC):
	title = "Resources"
	
	def __init__(self):
		self._items = None

	@property
	@abstractmethod
	def list(self):
		pass

	@property
	def items(self):
		if self._items == None:
			self._items = self.list().items
		return self._items

	@gtView
	def gtViewList(self, aBuilder):
		table = aBuilder.columnedList()
		table.title(self.title)
		table.priority(10)
		table.items(lambda: self.items)
		table.column("Name", lambda item: str(item.metadata.name))
		table.column("Status", lambda item: str(item.status.phase))
#		table.column("Age", lambda index: str(self.namespaces[index].metadata.age))
		table.set_accessor(lambda item: Namespace(self.items[item].metadata.name))
		return table

class NamespacedListView(ListView):
	def __init__(self, namespace):
		super().__init__()
		self._namespace = namespace
		
class Namespaces(ListView):
	title = "Namespaces"

	@property
	def list(self):
		v1 = client.CoreV1Api()
		return v1.list_namespace

class PodList(NamespacedListView):
	title = "Pods"

	@property
	def list(self):
		v1 = client.CoreV1Api()
		return lambda: v1.list_namespaced_pod(self._namespace)
		
class DeploymentList(NamespacedListView):
	title = "Deployments"
	
	@property
	def list(self):
		v1 = client.AppsV1Api()
		return lambda: v1.list_namespaced_deployment(self._namespace)
		
class Namespace:
	
	def __init__(self, namespace):
		self.namespace = namespace
	
	@gtView
	def podList(self, aBuilder):
		table = aBuilder.columnedList()
		table.title("Pods")
		table.priority(10)
		table.items(lambda: client.CoreV1Api().list_namespaced_pod(self.namespace).items)
		table.column("Name", lambda item: str(item.metadata.name))
		table.column("Status", lambda item: str(item.status.phase))
		return table
		
	@gtView
	def deploymentList(self, aBuilder):
		table = aBuilder.columnedList()
		table.title("Deployments")
		table.priority(20)
		table.items(lambda: client.AppsV1Api().list_namespaced_deployment(self.namespace).items)
		table.column("Name", lambda item: str(item.metadata.name))
		table.column("Condition", lambda item: str(item.status.conditions[0].message))
		return table
