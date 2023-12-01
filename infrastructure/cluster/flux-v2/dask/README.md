This deploymewnt allows multiple users to spawn multiple dask clusters by creating a scheduler each time a user asks for it, following the logic o fthe [Dask Gateway](https://gateway.dask.org/). 
The deployment is done on top of the `jhub` namespace where the deployment of the Jupyterhub service is. The Dask packages are available inthe image called Dask at notebooks' start up. 
If you decide to select this image, you can run a notebook and check that you can spawn a cluster by running:

```
import dask
import dask.distributed
from dask_gateway import Gateway
from dask_gateway import GatewayCluster
import dask.array as da
import requests
from dask_gateway import scheduler_preload
import os
```

To check the service of the `dask-gateway` is reachable, run:

```
requests.get("http://traefik-dask-dask-gateway/api/health").content
```

And then connect to the Gateway:

```
gateway = Gateway(address="http://traefik-dask-dask-gateway/",
    auth="jupyterhub")
gateway.list_clusters()
cluster = gateway.new_cluster()
cluster.scale(4)  # to create 4 worker nodes
```

You will see the scheduler and the worker pods appearing in the k8s cluster under the `jhub` namespace. 