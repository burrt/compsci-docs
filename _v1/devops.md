---
layout: compsci-note
title: DevOps Notes
categories: [devops]
description: Some notes on DevOps
sitemap: false
favorite: true
---

## DevOps

This is a pretty broad topic but I will mostly cover some basic deployments use in CI/CD pipelines. Software engineers are increasingly exposed, and to be responsible for, deployments and to a degree, environment management (and yes, we still get paid the same!).

Some of this may affect the application's architecture, code changes etc. I hardly see this as a positive but perhaps a necessary evil and it has already gained substantial mass - resisting would not be prudent.

## Deployment strategies

* [Blue Green](#blue-green)
* [Rolling upgrade](#rolling-upgade)
* [Canary release](#canary-release)

### Blue Green

1. leave `N` VMs with `v1` (`group1`)
2. allocate `N` VMs with `v2` (`group2`)
3. once `group1` becomes stable, route all traffic to `group2`
4. release `group2`

Notes:

* both groups connect to the same DB
  * if there are DB migrations, they **must** be BG compatible
* the app could have it's own load balancer and it's own ersion

Pros:

* only **one** version of the service is available to clients
  * this means there will be consistent interaction of your service to end users
* resource allocation/availability will be the same during the rollout
* rollback is easy

Cons:

* requires `2N` VMs

### Rolling upgrade

1. alocate a new VM with `v2`
2. release one VM with `v1`
3. repeat

Pros:

* simple
* requires only `N+1` VMs
  * or you can upgrade an existing VM for the cost of performance on VMs on `v1`

Cons:

* mulitple versions of the service will be available
* rollback can be tricky during a rollout

### Canary release

1. allocate a new VM with `v2-test`
2. route specific traffic to `v2-test`
3. if stable, continue to full release

Notes:

* this is similar to rolling upgrade but with the intention to expose only a subset of users to `v2-test` - usually this is done with internal employees/users. An alternative approach is by partition e.g. region.
* enables A/B testing
  * multiple versions of the service will co-exist, this can be difficult to manage
  * it may take a long time before enough data is collected for the A/B test to be satisfactory
* intention is to monitor the `v2-test` closely in production to determine whether it negatively affects the service
