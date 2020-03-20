#MOLGENIS walltime=05:59:00 mem=10gb ppn=6

#string intermediateDir
#string Project
#string logsDir
#string runID

set -e
set -u

# Touch log file for GAP_Automated for starting copying project data to PRM

if [ -f "${logsDir}//${Project}/${runID}.convert_idat_gtc.started" ]
then
	mv "${logsDir}/${Project}/${runID}.convert_idat_gtc".{started,finished}
else
	touch "${logsDir}/${Project}/${runID}.convert_idat_gtc.finished"
fi

if [ -f "${logsDir}/${Project}/${runID}.convert_idat_gtc.failed" ]
then
	rm -f "${logsDir}/${Project}/${runID}.convert_idat_gtc.failed"
fi

echo "${logsDir}/${Project}/${runID}.convert_idat_gtc.finished is created"

if [ ! -d "${logsDir}/${Project}/" ]
then
	mkdir -p "${logsDir}/${Project}/"
fi

touch convert_idat_gtc.finished
