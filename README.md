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
- `read-only`: if `yes` the action will simply read the version-file and
return successfully

## Outputs
- `new-version`: version contained in the version file
- `last-version`: last version found in the git tag from the repository

# Prefix
The version tag in git will be created with "v" prefix:
- if the version file contains "1.2.3" ; the tag added in git will be "v1.2.3"  

No prefix allowed in the version file:
- if the version file contains "v1.2.3" it will return an error as it is not a SemVer

# Suffix
Suffix delimiter is the dash `-`.  
A suffix can be added by using the input `suffix`:
- if the version file contains "1.2.3" and the `suffix` input is "pre-release", the tag added in git will be "v1.2.3-pre-release"  

No suffix is allowed in the version file:
- if the version file contains "1.2.3-pre-release" it will return an error as it is not a SemVer

If the last version found in git tags has a suffix and the new version in the version

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
        name: Check Version
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
  bump-version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - id: check
        name: Bump Version
        uses: Interstellar-Lab/bump-version@v0.9
        with:
          version-file: '.VERSION'
```
