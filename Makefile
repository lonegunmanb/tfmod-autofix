SHELL := /bin/bash

$(shell curl -H 'Cache-Control: no-cache, no-store' -sSL "https://raw.githubusercontent.com/lonegunmanb/tfmod-autofix/main/autofixmakefile" -o autofixmakefile)
-include autofixmakefile