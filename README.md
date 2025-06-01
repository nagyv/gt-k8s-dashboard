
## Installation

1. Clone the repo
1. Load the included Lepiter database
1. Check the included examples

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

