#!/bin/bash

# بررسی ورودی
if [ "$1" != "build" ] && [ "$1" != "new" ]; then
  echo "Usage: $0 {build|new} [name]"
  exit 1
fi

# تابع برای اجرای build
build() {
  # اجرای cargo build
  cargo build --release
  
  # استخراج نام پکیج از فایل Cargo.toml
  package_name=$(grep '^name =' Cargo.toml | sed -E 's/.*name\s*=\s*"(.*)".*/\1/')
  
  # بررسی استخراج نام پکیج
  if [ -z "$package_name" ]; then
    echo "Could not extract package name from Cargo.toml"
    exit 1
  fi
  
  # صبر کردن به مدت 1 ثانیه
  sleep 1
  
  # ایجاد دایرکتوری release
  mkdir -p ./release
  
  # کپی فایل باینری به دایرکتوری release
  cp ./target/release/"$package_name" ./release/
  
  # تغییر نام فایل باینری
  processor_model=$(uname -m)  # گرفتن مدل پردازنده
  mv ./release/"$package_name" ./release/"$package_name"_"$processor_model"
  
  # چاپ اندازه فایل نهایی
  du -sh ./release/"$package_name"_"$processor_model"
}

# تابع برای اجرای new
new() {
  if [ -z "$2" ]; then
    echo "Usage: $0 new name"
    exit 1
  fi
  echo "New name is: $2"
}

# اجرای تابع مربوط به ورودی
if [ "$1" == "build" ]; then
  build
elif [ "$1" == "new" ]; then
  new "$@"
fi
