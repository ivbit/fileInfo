#!/bin/ksh

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
typeset fName="$(stat -f '%SN%SY' "$1")"

# Size of the file
typeset fSize="$(du -sh "$1")"

# Owner information
typeset usrGrp="$(stat -f '%Su:%Sg' "$1")"

# Numeric permissions
typeset numericPerms="$(stat -f '%Lp' "$1")"

# String permissions
typeset pStr="$(stat -f '| %SHp | %SMp | %SLp |' "$1")"

# Binary permissions
typeset -i2 highBits="${numericPerms%[[:digit:]][[:digit:]]}"
typeset -i2 lowBits="${numericPerms#[[:digit:]][[:digit:]]}"
typeset tempStr="${numericPerms#[[:digit:]]}"
typeset -i2 medBits="${tempStr%[[:digit:]]}"
typeset -Z3 uBin="${highBits#*#}"
typeset -Z3 gBin="${medBits#*#}"
typeset -Z3 oBin="${lowBits#*#}"

# Print result
print -- "\nFile: ${fName}\nSize: ${fSize%%[[:blank:]]*}\nOwner: ${usrGrp}\nPermissions: ${numericPerms}\n|  u  |  g  |  o  |\n${pStr}\n| $uBin | $gBin | $oBin |\n"

# END OF SCRIPT

