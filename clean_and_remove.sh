#!/bin/bash

# مسیر فایل شل که قبلاً نصب شده است
PRIMARY_NAME="cargof"
ALIAS_NAME="cf"
COMPLETION_NAME="cargof_completion"

# مقصد نصب
DESTINATION_PATH="/usr/local/bin"
# مسیر نصب تکمیل
COMPLETION_DESTINATION_PATH="/etc/profile.d"

# بررسی اینکه اسکریپت با دسترسی root اجرا می‌شود
if [ "$(id -u)" -ne "0" ]; then
  echo "This script must be run as root. Use 'sudo' to run it."
  exit 1
fi

# حذف فایل اجرایی اصلی
if [ -f "$DESTINATION_PATH/$PRIMARY_NAME" ]; then
  echo "Removing executable file $DESTINATION_PATH/$PRIMARY_NAME"
  rm "$DESTINATION_PATH/$PRIMARY_NAME"
else
  echo "Executable file $DESTINATION_PATH/$PRIMARY_NAME does not exist."
fi

# حذف لینک سمبلیک
if [ -L "$DESTINATION_PATH/$ALIAS_NAME" ]; then
  echo "Removing symbolic link $DESTINATION_PATH/$ALIAS_NAME"
  rm "$DESTINATION_PATH/$ALIAS_NAME"
else
  echo "Symbolic link $DESTINATION_PATH/$ALIAS_NAME does not exist."
fi

# حذف فایل تکمیل
if [ -f "$COMPLETION_DESTINATION_PATH/$COMPLETION_NAME.sh" ]; then
  echo "Removing completion script $COMPLETION_DESTINATION_PATH/$COMPLETION_NAME.sh"
  rm "$COMPLETION_DESTINATION_PATH/$COMPLETION_NAME.sh"
else
  echo "Completion script $COMPLETION_DESTINATION_PATH/$COMPLETION_NAME.sh does not exist."
fi

# بررسی و حذف پوشه bash_completion.d اگر خالی است
if [ "$(ls -A $COMPLETION_DESTINATION_PATH)" ]; then
  echo "Completion directory $COMPLETION_DESTINATION_PATH is not empty. Not removing."
else
  echo "Removing empty directory $COMPLETION_DESTINATION_PATH"
  rmdir "$COMPLETION_DESTINATION_PATH"
fi

# تایید حذف
echo "Uninstallation complete."
echo "for complete remove (_completions helper).. You need to logout OR reboot"
