# Simple React app
A demo app with a CI/CD pipe line within Google ecosystem:
* Cloud Build for building and publishing Docker image
* Container registry for hosting the Docker image
* Kubernetes engine (GKE) for deploying the production cluster

## Local development
### Start up docker env
```shell
docker-compose -f docker-compose.dev.yaml up --build
```
Then access development server at `localhost:3000`.

Try to update something e.g. on `App.js` -> Save -> The app should hot-reload.

## Production deployment
The CI/CD pipeline is tightly integrated within Google ecosystem (Cloud Build -> Container registry -> GKE). Thus to deploy this to production, we need to:
1. Create new project on Google Cloud
2. Enable APIs (Cloud build, Container registry and Kubernetes API)
3. Create new Kubernetes cluster for the project
4. Setup a new build trigger on Cloud build
  * In the trigger settings, add 2 substitution variables `_COMPUTE_ZONE` and `_CONTAINER_CLUSTER`. They are used in [cloudbuild.yaml](./cloudbuild.yaml).
  * Their values should indicate the [`zone`](https://cloud.google.com/compute/docs/regions-zones) and `name` of the Kubernetes cluster. For example `europe-west1-b` and `production-cluster`.
5. Commit something to `main` branch and push. The build should be triggered. 

## Useful commands for locally testing
### Submit a build config
```shell
gcloud builds submit --config my_build_config.yaml
```

## Some issues with M1 Macs
### Run locally-built image in GKE clusters
GCP does not support Docker images built in ARM64 architecture. Thus we can get `exec format error` if we try to:
1. Locally build the Docker image `docker build -t gcr.io/my-app:latest .`
2. Push the image to container registry `docker push gcr.io/my-app:latest .`
3. Use that image in Kubernetes deployment config e.g. [`deployment.yaml`](./k8s/deployment.yaml)\
4. Test the deployment by applying it: `kubectl apply -f .`

In order to have that "workflow" above, we need to build an `amd64` image:
```shell
docker buildx build --platform linux/amd64 -t gcr.io/my-app:latest .
docker push gcr.io/my-app:latest
```

To verify the image's architecture, inspect the pushed Docker image:
```shell
docker inspect gcr.io/my-app:latest
```

### Useful resources
https://stackoverflow.com/questions/66920645/exec-format-error-when-running-containers-build-with-apple-m1-chip-arm-based
https://medium.com/geekculture/from-apple-silicon-to-heroku-docker-registry-without-swearing-36a2f59b30a3

## Useful docs and tutorials
https://cloud.google.com/build/docs/build-push-docker-image
https://kubernetes.io/docs/reference/kubectl/cheatsheet/
https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app#option_a_use
https://medium.com/bb-tutorials-and-thoughts/gcp-deploying-react-app-with-nginx-on-gke-466e9a465516
