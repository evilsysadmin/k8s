This setup is a simple poc , example of how to use several tools together to provide a kube cluster and deploy flow.

Some nice things to consider , in order to reuse this setup in prod:

- use a proper cloud kube cluster. Do it your own, our use EKS for example.
- use some continuous integration tool. Jenkins , circleci, whatever.
  - setup image build and deploy process there, triggered by git flow. Tag pushes, branch merges ,as desired.

- get some proper code! Bribe a developer , hug him , whatever. Do it
- add some logging and metrics infra. Prometheus ṕlus grafana,  why not. fluentd? check it out,see what you need.
- think on autoscaling . Depending on the cloud setup , think about scaling worker nordes , hpa scaling as well
