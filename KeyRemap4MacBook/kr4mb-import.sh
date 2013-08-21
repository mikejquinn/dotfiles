#!/bin/sh

cli=/Applications/KeyRemap4MacBook.app/Contents/Applications/KeyRemap4MacBook_cli.app/Contents/MacOS/KeyRemap4MacBook_cli

$cli set remap.controlL2controlL_escape 1
/bin/echo -n .
$cli set space_cadet.left_control_to_hyper 1
/bin/echo -n .
$cli set parameter.keyoverlaidmodifier_timeout 300
/bin/echo -n .
$cli set private.shifts_to_parens 1
/bin/echo -n .
/bin/echo
