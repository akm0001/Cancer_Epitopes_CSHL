#!/bin/bash

function bam2hla_fastq() {
  echo "Usage: $0 -b SRR1616919.sorted.bam -r NC_000006.12:29600000-33500000 -o test --path /opt/samtools/1.3.1/bin/
    -b,     --BAM               BAM file. Required.
    -r,     --region            Region for which reads will be extracted in this format: <chr:start-end> . Optional.
    -o,     --output            Prefix for output files. Required.
    -p,     --path              Path to samtools installation. Optional."
    }

function exitWithError() {
  echo -e "$1\n" #| tee -a $logfile
  if [ ! -z "$2" ]; then echo "$2"; fi
  bam2hla_fastq
  exit 1
}

function exitWithError2() {
  echo -e "$1\n" #| tee -a $logfile
  if [ ! -z "$2" ]; then echo "$2"; fi
 # bam2hla_fastq
  exit 1
}


function checkExitStatus() {
  if [ $? -ne 0 ]; then exitWithError "$1" "$2"; fi
}

# Initialize all options
BAM=""
REGION=""
OUT=""
PATH=""

# Parse command line arguments
if [ $# -eq 0 ]; then
   exitWithError "Not enough command line arguments."
fi

until [ -z "$1" ]; do 
  case $1 in
    -b | --BAM) 
      BAM=${2%/}
      shift; shift;;
    -r | --region)
      REGION=${2%/}
      shift; shift;;
    -o | --output)
      OUT=${2%/}
      shift; shift;;
    -p | --path)
      PATH=${2%/}
      shift; shift;;
    -*)
      exitWithError "Invalid option ($2).";;
    *)
      break;;
  esac
done


# extract reads overlapping with MHC locus and turn them into two fastq files
${PATH}/samtools view -h $BAM $REGION | ${PATH}/samtools bam2fq -1 ${OUT}_read1.fq -2 ${OUT}_read2.fq -