#!/bin/bash

# مسیر فایل شل که می‌خواهید اضافه کنید
SOURCE_PATH="./cargof.sh"
# مسیر فایل تکمیل
COMPLETION_SOURCE_PATH="./completion.sh"

# مقصد نصب
DESTINATION_PATH="/usr/local/bin"
# مسیر نصب تکمیل
COMPLETION_DESTINATION_PATH="/etc/profile.d"

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

# جایگزینی فایل شل در مسیر مقصد و اعطای مجوز اجرایی
if [ -f "$DESTINATION_PATH/$PRIMARY_NAME" ]; then
  echo "Replacing existing script $DESTINATION_PATH/$PRIMARY_NAME"
fi
cp "$SOURCE_PATH" "$DESTINATION_PATH/$PRIMARY_NAME"
chmod +x "$DESTINATION_PATH/$PRIMARY_NAME"

# ایجاد یا به‌روزرسانی لینک‌های سمبلیک
if [ -L "$DESTINATION_PATH/$ALIAS_NAME" ]; then
  echo "Updating symbolic link $DESTINATION_PATH/$ALIAS_NAME"
else
  echo "Creating symbolic link $DESTINATION_PATH/$ALIAS_NAME"
fi
ln -sf "$DESTINATION_PATH/$PRIMARY_NAME" "$DESTINATION_PATH/$ALIAS_NAME"

# بررسی وجود پوشه bash_completion.d و ایجاد آن در صورت عدم وجود
if [ ! -d "$COMPLETION_DESTINATION_PATH" ]; then
  echo "Directory $COMPLETION_DESTINATION_PATH does not exist. Creating it."
  mkdir -p "$COMPLETION_DESTINATION_PATH"
fi

# جایگزینی فایل تکمیل
if [ -f "$COMPLETION_DESTINATION_PATH/$COMPLETION_NAME.sh" ]; then
  echo "Replacing existing completion script $COMPLETION_DESTINATION_PATH/$COMPLETION_NAME.sh"
fi
cp "$COMPLETION_SOURCE_PATH" "$COMPLETION_DESTINATION_PATH/$COMPLETION_NAME.sh"

# تایید نصب
echo "Script has been installed as $PRIMARY_NAME and $ALIAS_NAME."
echo "Completion script has been installed as $COMPLETION_NAME in $COMPLETION_DESTINATION_PATH."

echo ""
echo "\"\""
echo "  try in your shell/bash/zsh/etc. :"
echo ""
echo "      cf [TAB]"
echo "      cf [TAB]"
echo ""
echo "\"\""
echo ""
echo "finish installion"
