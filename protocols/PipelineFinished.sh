#MOLGENIS walltime=05:59:00 mem=10gb ppn=6

#string intermediateDir
#string Project
#string logsDir
#string runID

set -e
set -u

# Touch log file for NGS_Automated for starting copying rawdata to PRM

if [ -f "${logsDir}//${Project}/${Project}.${runID}.AGCT.started" ]
then
	mv "${logsDir}/${Project}/${Project}.${runID}.AGCT".{started,finished}
else
	echo "${logsDir}//${Project}/${Project}.${runID}.AGCT.started does not exist"
	exit 1
fi

echo "${logsDir}/${Project}/${Project}.${runID}.AGCT.finished is created"
