#!/bin/bash

# مسیر فایل شل که می‌خواهید اضافه کنید
SOURCE_PATH="./cargof.sh"

# مقصد نصب
DESTINATION_PATH="/usr/local/bin"

# نام‌های دلخواه
PRIMARY_NAME="cargof"
ALIAS_NAME="cf"

# بررسی اینکه اسکریپت با دسترسی root اجرا می‌شود
if [ "$(id -u)" -ne "0" ]; then
  echo "This script must be run as root. Use 'sudo' to run it."
  exit 1
fi

# بررسی وجود فایل مبدأ
if [ ! -f "$SOURCE_PATH" ]; then
  echo "Source file $SOURCE_PATH does not exist."
  exit 1
fi

# کپی فایل به مسیر مقصد و اعطای مجوز اجرایی
cp "$SOURCE_PATH" "$DESTINATION_PATH/$PRIMARY_NAME"
chmod +x "$DESTINATION_PATH/$PRIMARY_NAME"

# ایجاد لینک‌های سمبلیک برای نام‌های اضافی
ln -sf "$DESTINATION_PATH/$PRIMARY_NAME" "$DESTINATION_PATH/$ALIAS_NAME"

# تایید نصب
echo "Script has been installed as $PRIMARY_NAME and $ALIAS_NAME."
