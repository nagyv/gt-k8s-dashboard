from abc import ABC, abstractmethod
from gtoolkit_bridge import gtView
from kubernetes import client, config

"Use to find how to call more APIs: https://github.com/kubernetes-client/python/blob/master/kubernetes/docs/CoreV1Api.md"

class ListView(ABC):
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
		table.title("Namespaces")
		table.priority(10)
		table.items(lambda: self.items)
		table.column("Name", lambda item: str(item.metadata.name))
		table.column("Status", lambda item: str(item.status.phase))
#		table.column("Age", lambda index: str(self.namespaces[index].metadata.age))
		table.set_accessor(lambda item: PodList(self.items[item].metadata.name))
		return table

class Namespaces(ListView):

	@property
	def list(self):
		v1 = client.CoreV1Api()
		return v1.list_namespace

class PodList(ListView):

	def __init__(self, namespace):
		super().__init__()
		self._namespace = namespace

	@property
	def list(self):
		v1 = client.CoreV1Api()
		return lambda: v1.list_namespaced_pod(self._namespace)
