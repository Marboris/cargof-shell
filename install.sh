#!/bin/bash

# مسیر فایل شل که می‌خواهید اضافه کنید
SOURCE_PATH="./cargof.sh"
# مسیر فایل تکمیل
COMPLETION_SOURCE_PATH="./completion.sh"

# مقصد نصب
DESTINATION_PATH="/usr/local/bin"
# مسیر نصب تکمیل
COMPLETION_DESTINATION_PATH="/etc/bash_completion.d"

# نام‌های دلخواه
PRIMARY_NAME="cargof"
ALIAS_NAME="cf"
COMPLETION_NAME="cargof_completion"

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

# بررسی وجود فایل تکمیل
if [ ! -f "$COMPLETION_SOURCE_PATH" ]; then
  echo "Completion file $COMPLETION_SOURCE_PATH does not exist."
  exit 1
fi

# کپی فایل به مسیر مقصد و اعطای مجوز اجرایی
cp "$SOURCE_PATH" "$DESTINATION_PATH/$PRIMARY_NAME"
chmod +x "$DESTINATION_PATH/$PRIMARY_NAME"

# ایجاد لینک‌های سمبلیک برای نام‌های اضافی
ln -sf "$DESTINATION_PATH/$PRIMARY_NAME" "$DESTINATION_PATH/$ALIAS_NAME"

# کپی فایل تکمیل به مسیر bash_completion.d
cp "$COMPLETION_SOURCE_PATH" "$COMPLETION_DESTINATION_PATH/$COMPLETION_NAME.sh"

# تایید نصب
echo "Script has been installed as $PRIMARY_NAME and $ALIAS_NAME."
echo "Completion script has been installed as $COMPLETION_NAME in /etc/bash_completion.d."
