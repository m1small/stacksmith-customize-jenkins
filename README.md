# Customization example for Bitnami Jenkins container image in Stacksmith

This is an example that shows how to customize a Bitnami container image in [Bitnami Stacksmith](https://stacksmith.bitnami.com).

## Package and deploy with Stacksmith

### Creating a new build of the application

1. Set your working directory to root directory of where your code is checked out
2. Make sure that you have stacksmith CLI installed ; please check [https://github.com/bitnami/stacksmith-cli](https://github.com/bitnami/stacksmith-cli)
3. Optionally, edit the `Stackerfile.yml` file and change `appVersion`
4. Run `stacksmith build`

### Create a new instance of application in Stacksmith

1. Go to [stacksmith.bitnami.com](https://stacksmith.bitnami.com)
2. Create a new application and select the _Generic _ stack template.
3. Select Kubernetes as the only target.
5. Upload an empty file as build script.
6. Click the <kbd>Create</kbd> button.
7. Once the build starts, copy the URL of the application - such as [https://stacksmith.bitnami.com/p/aws-demo-bitnami/apps/cf2e7010-23b4-0137-c291-3664dcd6e2cb](https://stacksmith.bitnami.com/p/aws-demo-bitnami/apps/cf2e7010-23b4-0137-c291-3664dcd6e2cb) and paste everything isnce `p/(project)/apps/(app-id)` into `Stackerfile.yml` as `appId` field.

## Files and scripts

The main logic for performing the customization is done from the `Stackerfile.yml` that defines how the application should be built.

The repository also provides a build script that performs customization of Jenkins.

### Stackerfile.yml

The `Stackerfile.yml` defines how the application should be built. It consists of several sections. The first one defines the project and application identifier for which the build should be performed along with the version of the built application:
```
appId: p/aws-demo-bitnami/apps/cf2e7010-23b4-0137-c291-3664dcd6e2cb
appVersion: "2.2.1"
```
This tells `stacksmith` CLI to run a build of [https://stacksmith.bitnami.com/p/aws-demo-bitnami/apps/cf2e7010-23b4-0137-c291-3664dcd6e2cb](https://stacksmith.bitnami.com/p/aws-demo-bitnami/apps/cf2e7010-23b4-0137-c291-3664dcd6e2cb) and set the version of the output to be `2.2.1`.

Next section provides a list of files to upload as well as paths to specific scripts.
```
files:
  userUploads:
    - job-dsl.hpi
  userScripts:
    build: stacksmith/user-scripts/build.sh
``

The `userUploads` specifies files to upload when building the image - in our case it is a Jenkins plugin file. The `build` element in `userScripts` specifies the path to script that should be run at build time.

Last part of the file specifies what image to use as the base image, what platform(s) to build and how:
```
baseImages:
  docker:
    name: 'bitnami/jenkins:2-ol-7'
buildOptions:
  assumeBaseImageFreshness: true
platforms:
  - target: docker
```

The first option specifies that the build should use a `bitnami/jenkins:2-ol-7` image - which is latest image Bitnami Jenkins, major version 2, on top of Oracle Linux 7.

The `assumeBaseImageFreshness` option specifies that updates of system packages should be skipped.

The last element specifies that Kubernetes platform should be built.

### build.sh

The [build.sh](stacksmith/user-scripts/build.sh) script performs customization of the image. It does the following things:

- installs Golang runtime to simplify building of Go-based applications
- forces `script-security` plugin to be installed in a specific version
- installs all plugins that have been uploaded as part of the build (such as the `job-dsl.hpi` plugin)
- installs Golang Jenkins plugin by downloading it from the [https://updates.jenkins.io](https://updates.jenkins.io) website
