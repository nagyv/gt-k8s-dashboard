This package provides a minimal, work in progress GT package to connect to a Kubernetes cluster from GT.
## Limitations

Many :)

The most notable limitations are the following:

- The setup assumes that you want to see your currently active cluster defined at the default kubeconfig location (~/.kube/config)
- The package uses Python, as a result it does not work on Windows. 
## Installation

Use Metacello to load the package and Lepiter:


```st
Metacello new
	repository: 'github://nagyv/gt-k8s-dashboard:main/src';
	baseline: 'GtK8sDashboard';
	load
```

## Examples

To see the examples, after installing with Metacello, you will be able to execute

```
#BaselineOfGtK8sDashboard asClass loadLepiter
```


and open the related page from the Lepiter knowledge base included in the repository.

Loading the knowledge base is not needed for generic usage.

