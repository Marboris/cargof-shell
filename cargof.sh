#!/bin/bash

if [ "$1" != "build" ] && [ "$1" != "new" ]; then
  echo "Usage: $0 {build|new} [options]"
  exit 1
fi

build() {
  cargo build --release

  package_name=$(grep '^name =' Cargo.toml | sed -E 's/.*name\s*=\s*"(.*)".*/\1/')

  if [ -z "$package_name" ]; then
    echo "Could not extract package name from Cargo.toml"
    exit 1
  fi

  sleep 0.5

  mkdir -p ./release

  sleep 0.5

  cp ./target/release/"$package_name" ./release/

  sleep 0.5

  processor_model=$(uname -m)
  mv ./release/"$package_name" ./release/"$package_name"_"$processor_model"

  du -sh ./release/"$package_name"_"$processor_model"
}

new() {
  name=""
  additional_options=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --name)
        shift
        name=$1
        ;;
      *)
        additional_options="$additional_options $1"
        ;;
    esac
    shift
  done

  if [ -z "$name" ]; then
    echo "Usage: $0 new --name Name [other-options]"
    exit 1
  fi

  cargo new "$name" $additional_options

  sleep 0.5

  cd "$name" || exit

  cat <<EOL >>Cargo.toml

[profile.release]
opt-level = 3
lto = true
codegen-units = 1
EOL

  echo "Project $name created and profile settings added."
}

if [ "$1" == "build" ]; then
  build
elif [ "$1" == "new" ]; then
  shift
  new "$@"
fi
