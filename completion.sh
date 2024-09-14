#!/bin/bash

_completions() {
  local cur prev opts
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="build new"

  if [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  elif [[ ${prev} == "new" ]]; then
    if [[ ${cur} == n=* ]]; then
      COMPREPLY=()
    else
      COMPREPLY=( $(compgen -W "--name" -- ${cur}) )
    fi
  else
    COMPREPLY=()
  fi
}

# فایل اجرایی شما
complete -F _completions cargof
complete -F _completions cf