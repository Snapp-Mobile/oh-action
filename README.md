# oh-action

## Introduction
The `oh-action` is a GitHub Action designed for building OpenHarmony applications. It sets up the necessary environment, verifies required files, installs dependencies, and builds the application using the specified tools and SDK versions.

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
          
      - name: Build OpenHarmony Application
        uses: Snapp-Mobile/oh-action@v0.1
```