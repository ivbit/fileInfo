#!/usr/bin/mksh

# Intellectual property information START
# 
# Copyright (c) 2021 Ivan Bityutskiy 
# 
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# 
# Intellectual property information END

# Description START
#
# The script displays information about file.
# Only single argument with a filename is allowed.
#
# Description END

(( $# != 1 )) ||
  [ ! -e "$1" ] && {
    print -u2 -- 'one argument = filename, file must exist'
    exit 1
  }

# Name of the file
typeset fName="$(stat -c '%N' "$1")"

# Type of the file
typeset fType="$(print -- "$(stat -c '%F' "$1")" | sed 's/./\U&/')"

# Size of the file
typeset fSize="$(du -sh "$1")"

# Owner information
typeset usrGrp="$(stat -c '%U:%G' "$1")"

# Numeric permissions
typeset -Z3 numericPerms="$(stat -c '%a' "$1")"

# String permissions
typeset -R9 pStr="$(stat -c '%A' "$1")"
typeset -L3 pUser="${pStr}"
typeset -L3 pGroup="${pStr#???}"
typeset -R3 pOther="${pStr}"

# Binary permissions
typeset -i2 highBits="${numericPerms%[[:digit:]][[:digit:]]}"
typeset -i2 lowBits="${numericPerms#[[:digit:]][[:digit:]]}"
typeset tempStr="${numericPerms#[[:digit:]]}"
typeset -i2 medBits="${tempStr%[[:digit:]]}"
typeset -Z3 uBin="${highBits#*#}"
typeset -Z3 gBin="${medBits#*#}"
typeset -Z3 oBin="${lowBits#*#}"

# Print result
print -- "\nFile: ${fName}\nType: ${fType}\nSize: ${fSize%%[[:blank:]]*}\nOwner: ${usrGrp}\nPermissions: ${numericPerms}\n|  u  |  g  |  o  |\n| $pUser | $pGroup | $pOther |\n| $uBin | $gBin | $oBin |\n"

# END OF SCRIPT
