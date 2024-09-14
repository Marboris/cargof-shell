#!/bin/bash

set -e

# رنگ قرمز
RED='\033[31m'
# بدون رنگ
NC='\033[0m'

# تابعی برای چاپ خطا
print_error() {
  echo -e "${RED}Error: $1${NC}"
}

if [ "$1" != "build" ] && [ "$1" != "new" ]; then
  print_error "Usage: $0 {build|new} [options]"
  exit 1
fi

build() {
  if ! cargo build --release; then
    print_error "Cargo build failed."
    exit 1
  fi

  package_name=$(grep '^name =' Cargo.toml | sed -E 's/.*name\s*=\s*"(.*)".*/\1/')

  if [ -z "$package_name" ]; then
    print_error "Could not extract package name from Cargo.toml."
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
    print_error "Usage: $0 new --name Name [other-options]"
    exit 1
  fi

  # Capture output and error
  if ! output=$(cargo new "$name" $additional_options 2>&1); then
    print_error "Error occurred while creating new project: \n"
    echo -e "${RED}$output${NC}"
    exit 1
  fi

  sleep 0.5

  cd "$name" || { print_error "Failed to enter directory $name"; exit 1; }

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
