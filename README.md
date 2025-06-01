This package provides a minimal, work in progress GT package to connect to a Kubernetes cluster from GT.
## Installation

1. Clone the repo
1. Load the included Lepiter database
1. Check the included examples
## Limitations

Many :)

The most notable limitations are the following:

- The setup assumes that you want to see your currently active cluster defined at the default kubeconfig location (~/.kube/config)
- The package uses Python, as a result it does not work on Windows
## Todo

Use Metacello to load the package and Lepiter:


```st
Metacello new
	repository: 'github://nagyv/gt-k8s-dashboard:main/src';
	baseline: 'GtK8sDashboard';
	load
```

## Load Lepiter

After installing with Metacello, you will be able to execute

```
#BaselineOfGtK8sDashboard asClass loadLepiter
```

