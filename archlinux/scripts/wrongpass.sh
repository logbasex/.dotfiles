#!/bin/bash
# Do not add -eu, you need to allow empty variables here!

# To be used with PAM. Look in /etc/pam.d for the script that your
# screensaver etc uses. Typically it references common-account and common-auth.
#
# In common-auth, add this as the first line
#auth       optional     pam_exec.so debug /path/to/wrongpassword.sh
#
# In common-account, add this as the first line
#account    required     pam_exec.so debug /path/to/wrongpassword.sh
#

COUNTFILE=~/.failed_login_count

# Make sure file exists
if [[ ! -f "${COUNTFILE}" ]];then
  touch "${COUNTFILE}"
fi

# Read value in it
COUNT=$(cat "${COUNTFILE}")

if [[ "$COUNT" -ge "0" ]]; then
  # Increment it
  COUNT=$((COUNT+1))
else
  COUNT=0
fi

# if authentication
if [[ -n "$1" ]] && [[ "$1" == "success" ]]; then
  COUNT=0
fi

echo "${COUNT}" > "${COUNTFILE}"

# The count will be at 4 after 3 wrong tries
if [[ "$PAM_TYPE" == "auth" ]] && [[ "${COUNT}" -ge "10" ]]; then
  echo 0 > "${COUNTFILE}"
  /usr/bin/systemctl poweroff
fi

exit 0
