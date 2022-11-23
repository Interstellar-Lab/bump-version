last='1.2.3'
new='10.0.2'

MAJOR_LAST=$(echo $last | cut -d '.' -f1)
MINOR_LAST=$(echo $last | cut -d '.' -f2)
PATCH_LAST=$(echo $last | cut -d '.' -f3)
MAJOR_NEW=$(echo $new | cut -d '.' -f1)
MINOR_NEW=$(echo $new | cut -d '.' -f2)
PATCH_NEW=$(echo $new | cut -d '.' -f3)
IS_NEW=true
if [[ $MAJOR_NEW -lt $MAJOR_LAST ]]; then
  echo "major"
  IS_NEW=false
elif [[ $MAJOR_NEW -eq $MAJOR_LAST ]] && [[ $MINOR_NEW -lt $MINOR_LAST ]]; then
  echo "minor"
  IS_NEW=false
elif [[ $MAJOR_NEW -eq $MAJOR_LAST ]] && [[ $MINOR_NEW -eq $MINOR_LAST ]] && [[ $PATCH_NEW -le $PATCH_LAST ]]; then
  echo "patch"
  IS_NEW=false
fi
if ! $IS_NEW; then
  echo "last version is:\tv$last"
  echo "new version is:\t\tv$new"
  echo "$new <= $last: version not new"
  echo "::error::no new version"
  exit 1
fi