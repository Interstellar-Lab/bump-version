# check-version
This github action will check that the version number contained in the version file is greater than the latest tag version number. Version should be semVer format. 
It can be used in your development workflow to automatically tag version number.  
## Development workflow
- You do some work
- When ready to do a PR, you edit the version file in your repository (typically `.VERSION`) according to the changes you made (major, minor or patch)
- Push and create a PR
- The CI will check the version file and if the version is in the good format and greater than the previous version, it will create a tag with the new version and publish it

## Inputs:
- `version-file`: path the version file. Default is `.VERSION`

## Outputs:
- `new-version`: version contained in the version file
- `last-version`: last version found in the git tag from the repository

## How to use
You can use this action to automatically tag your repository based on the version number written in the version file:
```yaml
bump-version:
    runs-on: ubuntu-latest
    name: Check version number and bump if version is new
    outputs:
      last-version: ${{ steps.check.outputs.last-version }}
      new-version: ${{ steps.check.outputs.test }}
    steps:
      - uses: actions/checkout@v3
      - id: check
        name: Check Version
        uses: Interstellar-Lab/check-version@v0.3
        with:
          version-file: '.VERSION'
      - name: Tag new version
        if: ${{ steps.check.outputs.new-version > steps.check.outputs.last-version }}
        run: |
          git config user.name "GitHub Actions Bot"
          git config user.email "<>"
          git tag -a v${{ steps.check.outputs.new-version }} -m "Realse version ${{ steps.check.outputs.new-version }}"
          git push origin v${{ steps.check.outputs.new-version }}
          echo "::notice:: new tag published: 'v${{ steps.check.outputs.new-version }}'"
```
