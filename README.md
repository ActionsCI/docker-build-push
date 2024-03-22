# Docker Build and Push GitHub Action

This GitHub Action allows you to build a Docker image from a Dockerfile and push it to a Docker registry. It encapsulates the process into a reusable action, simplifying the CI/CD pipeline setup for projects that use Docker.

## Features
- Build a Docker image from a specified Dockerfile.
- Push the built image to a specified Docker registry.
- Supports custom build arguments.
- Flexible authentication using either a password/token or a Docker Hub token.

## Usage

To use this action in your workflow, you'll need to specify the required inputs, including the image name, version, Dockerfile path, and registry credentials.

### Inputs

- `dockerfile`: **Required**. The path to the Dockerfile.
- `version`: **Required**. The version of the Docker image. This will be used as the tag for the image.
- `image_name`: **Required**. The name of the Docker image.
- `directory`: **Required**. The path to the directory containing the Dockerfile.
- `build_args`: Optional. Build arguments for the Docker image, space-separated.
- `registry_url`: **Required**. The URL of the Docker registry where the image will be pushed.
- `registry_username`: **Required**. The username for the Docker registry.
- `registry_password`: **Required**. The password or token for the Docker registry. This can also be a Docker Hub token if preferred.

### Example Workflow

Here's an example of how you can incorporate this action into a GitHub workflow:

```yaml
name: Build and Push Docker Image
on: [push]

jobs:
  docker-build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Build and Push Docker Image
        uses: your-organization/docker-build-and-push-action@0.1.1
        with:
          dockerfile: ./Dockerfile
          version: 1.0.0
          image_name: my-image
          directory: .
          build_args: 'ARG1=value1 ARG2=value2'
          registry_url: docker.io
          registry_username: ${{ secrets.REGISTRY_USERNAME }}
          registry_password: ${{ secrets.REGISTRY_PASSWORD }}
```

This workflow checks out the code, then builds and pushes a Docker image named `my-image` with version `1.0.0` to Docker Hub using the Dockerfile located at the root of the repository.

## Contributing

Contributions to the action are welcome! Please feel free to submit a pull request or open an issue if you have any suggestions or find any bugs.

## License

This project is licensed under the [MIT License](LICENSE).
