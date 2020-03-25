#MOLGENIS walltime=05:59:00 mem=8gb ppn=1

#string iaapVersion
#string bpmFile
#string egtFile
#string egt
#string SentrixBarcode_A
#string ConvertDir
#string IDATFilesPath
#string logsDir
#string Project
#string runID
#string resultDir
#string GTCFilesPath

module load "${iaapVersion}"
module list

mkdir -p "${ConvertDir}/"
mkdir -p "${ConvertDir}/${SentrixBarcode_A}"

if [ ! -f "${logsDir}//${Project}/${SentrixBarcode_A}.${runID}.AGCT.started" ]
then
	touch ${logsDir}//${Project}/${SentrixBarcode_A}.${runID}.AGCT.started
else
	echo "${logsDir}//${Project}/${SentrixBarcode_A}.${runID}.AGCT.started allready exist"
fi

##Command to convert IDAT files to GTC files
/apps/software/IAAP/cli-rhel.6-x64-1.1.0/iaap-cli/iaap-cli gencall "${bpmFile}" "${egtFile}" "${ConvertDir}/${SentrixBarcode_A}" -f "${IDATFilesPath}/${SentrixBarcode_A}" -g


## md5sum the output

for gtcfile in $(ls ${ConvertDir}/${SentrixBarcode_A}/*.gtc)
do
	md5sum "${gtcfile}" > "${gtcfile}".md5
done

#Move GTC files and md5's to rawdata/array/GTC/ folder
mkdir -p "${resultDir}"

echo "moving ${ConvertDir}/${SentrixBarcode_A} ${GTCFilesPath}/"
mv "${ConvertDir}/${SentrixBarcode_A}" "${GTCFilesPath}/"

# Make symlinks
mkdir -p "${resultDir}/${SentrixBarcode_A}"
cd "${resultDir}/${SentrixBarcode_A}"

for i in $(ls ${GTCFilesPath}/${SentrixBarcode_A}/*.gtc)
do
	echo ${i}
done

cd -

## touch file to let know conversion is completed
if [ "${logsDir}//${Project}/${SentrixBarcode_A}.${runID}.AGCT.started" ]
then
	mv ${logsDir}//${Project}/${SentrixBarcode_A}.${runID}.AGCT.started ${logsDir}//${Project}/${SentrixBarcode_A}.${runID}.AGCT.finished
else
	echo "${logsDir}//${Project}/${SentrixBarcode_A}.${runid}.AGCT.started does not exist!"
fi
