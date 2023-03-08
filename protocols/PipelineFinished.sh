#MOLGENIS walltime=05:59:00 mem=10gb ppn=6

#string intermediateDir
#string Project
#string logsDir
#string runID

set -e
set -u
set -o pipefail

# Touch log file for NGS_Automated for starting copying rawdata to PRM

if [[ -e "${logsDir}/${Project}/${runID}.arrayConversion.started" ]]
then
	mv "${logsDir}/${Project}/${runID}.arrayConversion."{started,finished}
else
	touch "${logsDir}/${Project}/${runID}.arrayConversion.finished"
fi
