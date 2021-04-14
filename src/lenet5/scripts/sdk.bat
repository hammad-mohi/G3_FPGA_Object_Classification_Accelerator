::===========================================================================
:: open a new cmd terminal in current directory (where this .bat is located)
:: source the vivado settings64 script
:: delete any log and journal files if any
:: open vivado in batch mode and execute the specified TCL script
:: PAUSE after running the TCL scrip; wait for 'enter' to close terminal
:: TODO: send tcl script as an argument
::===========================================================================
set "vivado_settings=C:\DESL\Xilinx\Vivado\2018.3\settings64.bat"
set "vivado_tcl_cmd=vivado -mode batch -source sdk.tcl"
start cmd.exe /c "%vivado_settings% && del *.log & del *.jou & %vivado_tcl_cmd% && PAUSE"