from abc import ABC, abstractmethod
from gtoolkit_bridge import gtView
from kubernetes import client, config

"Use to find how to call more APIs: https://github.com/kubernetes-client/python/blob/master/kubernetes/docs/CoreV1Api.md"

class ContextawareK8sClient:

    def __init__(self, config_file=None, context_name=None):
        self._config_file = config_file
        self._context_name = context_name
        self.configuration = client.Configuration()
        config.load_kube_config(self._config_file, self._context_name, self.configuration, persist_config=False)

        self._client = None

    @property
    def client(self):
        if self._client is None:
            self._client = client.ApiClient(self.configuration)
        return self._client


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

    @property
    def accessor(self):
        return False

    @gtView
    def gtViewList(self, aBuilder):
        table = aBuilder.columnedList()
        table.title(self.title)
        table.priority(10)
        table.items(lambda: self.items)
        table.column("Name", lambda item: str(item.metadata.name))
        table.column("Status", lambda item: str(item.status.phase))
#        table.column("Age", lambda index: str(self.namespaces[index].metadata.age))
        if self.accessor:
            table.set_accessor(self.accessor)
        return table


class Namespaces(ListView):
    title = "Namespaces"

    def __init__(self, config_file: str = None, context_name: str = None):
        super().__init__()
        self._client = ContextawareK8sClient(config_file=config_file, context_name=context_name).client

    @property
    def list(self):
        v1 = client.CoreV1Api(self._client)
        return v1.list_namespace

    @property
    def accessor(self):
        return lambda item: Namespace(self.items[item].metadata.name, client=self._client)


class Namespace:

    def __init__(self, namespace, client=None):
        self.namespace = namespace
        if client == None:
            client = ContextawareK8sClient().client
        self._client = client

    @gtView
    def podList(self, aBuilder):
        table = aBuilder.columnedList()
        table.title("Pods")
        table.priority(10)
        table.items(lambda: client.CoreV1Api(self._client).list_namespaced_pod(self.namespace).items)
        table.column("Name", lambda item: str(item.metadata.name))
        table.column("Status", lambda item: str(item.status.phase))
        return table

    @gtView
    def deploymentList(self, aBuilder):
        table = aBuilder.columnedList()
        table.title("Deployments")
        table.priority(20)
        table.items(lambda: client.AppsV1Api(self._client).list_namespaced_deployment(self.namespace).items)
        table.column("Name", lambda item: str(item.metadata.name))
        table.column("Condition", lambda item: str(item.status.conditions[0].message))
        return table