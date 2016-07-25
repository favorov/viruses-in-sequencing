#!/bin/bash
#take sam alignment ($1) and shows all the hpv's seen there
samtools view -S $1 | grep hpv | cut -f 3 | grep hpv | uniq