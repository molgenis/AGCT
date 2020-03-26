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

##Command to convert IDAT files to GTC files
/apps/software/IAAP/cli-rhel.6-x64-1.1.0/iaap-cli/iaap-cli gencall "${bpmFile}" "${egtFile}" "${ConvertDir}/${SentrixBarcode_A}" -f "${IDATFilesPath}/${SentrixBarcode_A}" -g


## md5sum the output

for gtcfile in $(ls ${ConvertDir}/${SentrixBarcode_A}/*.gtc*)
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

for i in $(ls ${GTCFilesPath}/${SentrixBarcode_A}/*.gtc*)
do
	echo "symlinking: ${i}"
	ln -s "${i}"
done



cd -
