# bump-version
This github action create new tag based on the version number contain in the version file.  
New tag is created only if:
- Version contained in the version file is in the [SemVer](https://semver.org/) format
- Version in the version file is higher than the last version published in a git tag

Additionally, this action can be used to only check the version value in the version file and not publish the tag by 
setting the input parameter `check-only` to `yes`

## Inputs
- `version-file`: path to the version file. Default is `.VERSION`
- `check-only`: if `yes` no new tag will be published. The action will only validate that 
the version is a valid SemVer format and it's a higher version than the last version published in a tag.

## Outputs
- `new-version`: version contained in the version file
- `last-version`: last version found in the git tag from the repository

## Development workflow
- You do some work
- When ready to do a PR, you edit the version file in your repository (typically `.VERSION`) according to
  the changes you made (major, minor or patch)
- Push and create a PR
- Use `bump-version` action with `check-only` to `yes` to check that the version file has been well updated and is
  ready to be merged
- Validate the PR and merge
- Use `bump-version` action to publish a new tag based on the version contained in the version file

## Example
Check version on PR on `dev` branch:
```yaml
name: Check Version
on:
  pull_request:
    branches: [dev]
jobs:
  check-version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - id: check
        name: Bump Version
        uses: Interstellar-Lab/bump-version@v0.9
        with:
          version-file: '.VERSION'
          check-only: 'yes'
```
Publish new tag on merge in `dev` branch:
```yaml
name: Bump Version
on:
  push:
    branches: [dev]
jobs:
  check-version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - id: check
        name: Bump Version
        uses: Interstellar-Lab/bump-version@v0.9
        with:
          version-file: '.VERSION'
```
