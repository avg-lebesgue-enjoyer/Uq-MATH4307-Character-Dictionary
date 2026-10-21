if [ -n "$0" -a "$#" -eq 1 ]; then
  echo `date` '-- Compiling with `pdflatex`, but no BibTeX'
  pdflatex --shell-escape -synctex=1 -interaction=nonstopmode -file-line-error main.tex > /dev/null
  if [ $? -ne 0 ]; then
    # The `grep -A 1 ...` line matches, for example, `./Body/1/submain.tex:10:Undefined control sequence`
    # All `grep -v ...` lines match other garbage to be ignored
    cat main.log \
      | grep -v '^Package graphics Info' \
      | grep -v 'File: l3backend-pdftex.def' \
      | grep -v ' file:line:error style messages enabled.' \
      | grep -A 1 '^\./.*:.*:.*' \
      | less
    echo '^ there were problems'
    false # Set exit code to `1`
  else
    exit 0 2> /dev/null > /dev/null
  fi
elif [ -n "$1" ]; then
  if [ "$1" = 'r' ]; then
    cd '../../..'
  elif [ "$1" = 'addq' ]; then
    if [ -n "$2" ]; then
      mkdir "Body/$2"
      cp './base-question-submain.tex' "Body/$2/submain.tex"
    else
      echo 'a.sh: argument `addq` requires a second argument!'
    fi
  else
    echo 'a.sh: bad argument!'
  fi
else
  echo 'a.sh: no argument!'
fi

