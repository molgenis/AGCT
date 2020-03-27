#MOLGENIS walltime=05:59:00 mem=10gb ppn=6

#string intermediateDir
#string Project
#string logsDir
#string runID

set -e
set -u

# Touch log file for NGS_Automated for starting copying rawdata to PRM

touch "${logsDir}/${Project}/${runID}.AGCT.finished
