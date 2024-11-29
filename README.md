# oh-action
The `oh-action` is a GitHub Action that streamlines OpenHarmony development workflows by setting up the necessary development environment. It automatically installs the OpenHarmony SDK and provides essential command-line tools, enabling developers to build, test, and manage their OpenHarmony applications in CI/CD pipelines.

## Requirements
- macOS runner (`runs-on: macos-latest`)
- OpenHarmony project with valid structure
- Valid `hvigorw` file in project root

## Features
- 🚀 Automatically installs OpenHarmony (SDK v4.1)
- 🛠️ Sets up command-line tools including:
  - 📦 `ohpm` (OpenHarmony Package Manager) for dependency management
  - 🔨 `hvigorw` for building applications
  - 🔄 More tools coming soon!
- ⚙️ Configures the necessary environment variables and paths
- ✅ Validates project structure and requirements
- 📁 Supports custom working directories for monorepo setups

## Supported Versions
| OpenHarmony | SDK Version | ohpm | hvigor | Supported |
|-------------|-------------|------|--------|-----------|
| v4.1        | v11         | 1.4  | 3.2.4  | ✔         |

## Example Usage

``` yaml
name: Build OpenHarmony Application
on:
  push:
    branches:
      - main # Trigger workflow on push events to main branch
  pull_request:
    branches:
      - main # Trigger workflow on pull request events targeting main branch

jobs:
  build:
    runs-on: macos-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4 
          
      - name: Setup OpenHarmony environment
      - uses: Snapp-Mobile/oh-action@v0.1

      - name: Install dependencies
        run: ohpm install --all

      - name: Build project
        run: |
          hvigorw --version --accept-license
          hvigorw clean --no-parallel --no-daemon
          hvigorw assembleHap --mode module -p product=default --stacktrace --no-parallel --no-daemon

```


## Inputs

| Input                 | Description                                         | Required | Default |
|---------------------  |-----------------------------------------------------|----------|---------|
| working-directory     | Working directory relative to repository root       | false    | "."     |
| install-dependencies  | Install dependencies using ohpm install --all       | false    | "true"  |


### using custom working directory
If your project is located in a subdirectory of the repository, you can specify the `working-directory` input to set the correct path. For example, if your project is located in the `app` directory, you can set the `working-directory` input as follows:

```yaml
name: Build OpenHarmony Application

# Default configurations for running commands in this workflow
# Every step in this workflow will run in the context of the working directory
defaults:
  run:
    working-directory: ./Sample

# Define when this workflow should run
on:
  push:
    branches:
      - main # Trigger workflow on push events to main branch
  pull_request:
    branches:
      - main # Trigger workflow on pull request events targeting main branch

jobs:
  build:
    runs-on: macos-latest # Use the latest version of macOS for this job

    steps:
      - name: Checkout code
        uses: actions/checkout@v4 # Checkout the repository content to the runner

      - name: Build Project Using oh-action
        uses: Snapp-Mobile/oh-action@main
        with:
          working-directory: ./Sample

      - name: Install dependencies
        run: ohpm install --all

      - name: Build project
        run: |
          hvigorw --version --accept-license
          hvigorw clean --no-parallel --no-daemon
          hvigorw assembleHap --mode module -p product=default --stacktrace --no-parallel --no-daemon
```

## Support

If you encounter any issues:
- 🐛 Open an issue in the GitHub repository
- 📝 Provide detailed error messages and logs
- 💻 Share your workflow configuration

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
