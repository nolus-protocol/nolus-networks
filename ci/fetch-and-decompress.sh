#!/usr/bin/env sh

################################################################################
## This script shall conform to the POSIX.1 standard, a.k.a. IEEE Std 1003.1. ##
## When utilities defined in the standard are to be invoked, they shall only  ##
## be invoked utilizing functions defined by the standard, excluding any and  ##
## all extensions to the standard functions, e.g. GNU extensions.             ##
##                                                                            ##
## Version of the POSIX.1 standard used: POSIX.1-2008                         ##
## https://pubs.opengroup.org/onlinepubs/9699919799.2008edition/              ##
##                                                                            ##
## Used version of the standard should not be moved forward unless necessary  ##
## in order to keep the script as portable as possible between different      ##
## environments.                                                              ##
##                                                                            ##
## Used version of the standard should be moved backwards if possible in      ##
## order to keep the script as portable as possible between different         ##
## environments.                                                              ##
################################################################################
## Used utilities outside the POSIX standard:                                 ##
## busybox [with:]                                                            ##
##   * gunzip                                                                 ##
##   * wget                                                                   ##
################################################################################

set -eu

get_value() {
  "echo" "${2:?"No or empty value provided after \"${1:?}\" option flag!"}"
}

while :
do
  case "${#}" in
    ("0") break ;;
  esac

  case "${1?}" in
    ("-o"|"--owner")
      owner="$("get_value" "${@?}")"

      shift 2
      ;;
    ("-r"|"--repo"|"--repository")
      repository="$("get_value" "${@?}")"

      shift 2
      ;;
    ("-t"|"--rel"|"--release")
      release="$("get_value" "${@?}")"

      shift 2
      ;;
    ("-f"|"--file")
      file="$("get_value" "${@?}")"

      shift 2
      ;;
    (*)
      "echo" \
        "Unknown option: \"${1?}\"!" \
        >&2
      
      exit "1"
  esac
done

case "${file:?}" in
  (?*".gz") ;;
  (*)
    "echo" \
      "File to download does not indicate that it is compressed with GZip!" \
      >&2

    exit "1"
esac

"wget" \
  -O "/bind/${file:?}" \
  "https://github.com/${owner:?}/${repository:?}/releases/download/${release:?}/${file:?}"

"gunzip" "/bind/${file:?}"
