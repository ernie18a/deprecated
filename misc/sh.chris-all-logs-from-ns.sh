#!/bin/bash
x=kube
a=$(kubectl get pod -A |grep $x )
b=$(kubectl get pod -A |grep $x | wc -l )
for (( y=1 ; y<=${b} ;  y++ ))
do
        c=`kubectl get pod -A |grep $x | awk NR==$y'{print $1}'`
        d=`kubectl get pod -A |grep $x | awk NR==$y'{print $2}'`
        kubectl logs $d -n $c --all-containers > $d.log
done
exit 0
