# kubectl docker image

## Usage

To use kubectl you should need a kubeconfig file and a service account key. You can find this files examples in `credentials/` directory in this repo. The easiest way is to use your `~/.kube/config` file (actually you don't have other good ways). If you use this one, make sure `current-context` is the one you need and there's no `cmd` in `user.auth-provider.config`, or you will need gcloud command to be here. After preparing the files, let's try the image:

```bash
docker run -v `pwd`/kubeconfig:/root/.kube/config     \
           -v `pwd`/token:/token                      \
           -e GOOGLE_APPLICATION_CREDENTIALS='/token' \
           kaigara/kubectl get po
```

You should mount token file to the path from `GOOGLE_APPLICATION_CREDENTIALS`.

## Troubleshouting

Here are some problems we know how to fix:

* __kube/config is a directory__

  ```
  error: Error loading config file "/root/.kube/config": read /root/.kube/config: is a directory
  ```

  You use wrong path while mounting the config file (`-v some_dir/token:/token`). You should use full file path when mounting single files in docker ([link](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-file-as-a-data-volume)).

* __error executing access token command__

  ```
  Unable to connect to the server: error executing access token command "/home/user/gcloud-sdk/bin/gcloud config config-helper --format=json": err=fork/exec /home/user/gcloud-sdk/bin/gcloud: no such file or directory output=
  ```

  You have a command to execute in kube config:

  ```yaml
  - name: gke_test-project_europe-west1-c_a-cluster
    user:
      auth-provider:
        config:
          access-token: 0000000
          cmd-args: config config-helper --format=json
          cmd-path: /home/user/gcloud-sdk/bin/gcloud
          expiry: 2017-10-10T10:10:10Z
          expiry-key: '{.credential.token_expiry}'
          token-key: '{.credential.access_token}'
        name: gcp
  ```

  Remove `cmd-args` and `cmd-path` lines.
