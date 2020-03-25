#MOLGENIS walltime=05:59:00 mem=10gb ppn=6

#string intermediateDir
#string Project
#string logsDir
#string runID

set -e
set -u

# Touch log file for GAP_Automated for starting copying project data to PRM

if [ -f "${logsDir}//${Project}/${Project}.${runID}.convert_idat_gtc.started" ]
then
	mv "${logsDir}/${Project}/${Project}.${runID}.convert_idat_gtc".{started,finished}
else
	echo "${logsDir}//${Project}/${Project}.${runID}.convert_idat_gtc.started does not exist"
	exit 1
fi

echo "${logsDir}/${Project}/${Project}.${runID}.convert_idat_gtc.finished is created"
