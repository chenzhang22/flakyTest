#!/bin/bash  
  
function func_testreco  
{  
    # args  
    param_1=$1  
    for i in $param_1  
    do  
        cmd1=“A &”  
        cmd2="B &"  
        cmd3="C &"  
        cmd4="D &"  
    done  
    wait  
}  
  
set -o errexit  
func_testreco $param_1 
