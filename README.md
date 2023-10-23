# bump-version
This github action create new tag based on the version number contained in the version file.  
New tag is created only if:
- Version contained in the version file is in the [SemVer](https://semver.org/) format
- Version in the version file is higher than the last version published in a git tag

Version in git tags are always prefixed with a "v": if version file contains "1.2.3" git tag will be "v1.2.3"

Additionally, this action can be used to only check the version value in the version file; 
only read the versions (file and tag) or release a version that was in "pre-release". See "Inputs" for more details.

## Inputs
- `version-file`: path to the version file. Default is `.VERSION`
- `check-only`: if `yes`, no new tag will be published. The action will only validate that 
the version is a valid SemVer format and it's a higher version than the last version published in a tag.
- `read-only`: if `yes`, the action will simply read the version numbers and return the values in the outputs:
  - version file value can be accessed with the `new-version` output
  - last version in git tag can be accessed with the `last-version` output.
- `release-only`: if `yes`, the action will try to release the last version: 
  - It will look for the last publish version in git tags
  - Check if the last published version has a "pre-release" suffix; it returns an error if not
  - Check if the version in the version file match the last published version in git tag; it returns an error if not
  - Publish a new version tag that matches the last version but without "pre-release" suffix
- `suffix`: a string that will be appended to the version number in git tag:
  - if version in version file is "1.2.3" and suffix is "my_suffix"; the git tag will be "v1.2.3-my_suffix" 
  - use "pre-release" suffix to mark a version as pre-release that can later be released with the `release-only` option

`check-only`, `read-only`, `release-only` option are mutually exclusive: only one of them can be set to `yes` at the same time

## Outputs
- `new-version`: version contained in the version file
- `last-version`: last version found in the git tag from the repository in the SemVer format without prefix nor suffix
  - if the last version tag is "v1.2.3-pre-release" the value of `last-version` will be "1.2.3"

# Prefix
The version tag in git will be created with "v" prefix:
- if the version file contains "1.2.3" ; the tag added in git will be "v1.2.3"  

No prefix allowed in the version file:
- if the version file contains "v1.2.3" it will return an error as it is not a SemVer

# Suffix
Suffix delimiter is the dash `-`.  
A suffix can be added by using the input `suffix`:
- if the version file contains "1.2.3" and the `suffix` input is "pre-release", 
the tag added in git will be "v1.2.3-pre-release"  

No suffix is allowed in the version file:
- if the version file contains "1.2.3-pre-release" it will return an error as it is not a SemVer

Note that a version with a suffix is not newer than the same version without suffix. Bump-version compare version without suffix:
- if version file contains "1.2.3" and last version found in git tags is "1.2.3-pre-release" bump-version will return an error saying that version is not new

If you want to release a version currently in pre-release:
- Set the input `release` to `yes`
- bump-version will check that the last version found in git tags has a "pre-release" suffix and publish a new tag without the suffix

## Development workflow
### Simple workflow
- You do some work
- When ready to do a PR, you edit the version file in your repository (typically `.VERSION`) according to
  the changes you made (major, minor or patch)
- Push and create a PR
- Use `bump-version` action with `check-only` to `yes` to check that the version file has been well updated and is
  ready to be merged
- Validate the PR and merge
- Use `bump-version` action to publish a new tag based on the version contained in the version file
### Workflow with "pre-release" suffix
- You do some work on a custom branch `feature/demo`
- When ready to do a PR, you edit the version file in your repository (typically `.VERSION`) according to
  the changes you made (major, minor or patch)
- Push and create a PR from branch `feature/demo` to `dev`
- Use `bump-version` action with `check-only` to `yes` to check that the version file has been well updated and is
  ready to be merged
- Validate the PR and merge
- Use `bump-version` action with `suffix` set to `pre-release` to publish a new tag based
on the version contained in the version file with the `pre-release` suffix
- Create a PR from `dev` to `main` and merge
- Use `bump-version` action with `release-only` to `yes` to publish the version in pre-release

With this workflow git tags will look like this:
```
v0.0.1-pre-release
v0.0.2-pre-release
v0.1.0-pre-release
v0.1.0
v0.1.1-pre-release
v0.1.1
v0.1.2-pre-release
v0.1.3-pre-release
v0.1.3
```
where only the version without the "pre-release" tag have been merged in `main` branch

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
