#MOLGENIS walltime=05:59:00 mem=8gb ppn=1

#string iaapVersion
#string bpmFile
#string egtFile
#string egt
#string SentrixBarcode_A
#string convertDir
#string IDATFilesPath
#string logsDir
#string Project
#string runID
#string resultDir
#string GTCFilesPath

module load "${iaapVersion}"
module list

mkdir -p "${convertDir}/"
mkdir -p "${convertDir}/${SentrixBarcode_A}"

##Command to convert IDAT files to GTC files
${EBROOTIAAP}/iaap-cli/iaap-cli gencall "${bpmFile}" "${egtFile}" "${convertDir}/${SentrixBarcode_A}" -f "${IDATFilesPath}/${SentrixBarcode_A}" -g

## md5sum the output

for gtcfile in $(ls "${convertDir}/${SentrixBarcode_A}/"*.gtc)
do
	md5sum "${gtcfile}" > "${gtcfile}".md5
done

#Move GTC files and md5s to rawdata/array/GTC/ folder
mkdir -p "${GTCFilesPath}/${SentrixBarcode_A}/"

echo "moving ${convertDir}/${SentrixBarcode_A}/* ${GTCFilesPath}//${SentrixBarcode_A}/"
mv "${convertDir}/${SentrixBarcode_A}/"* "${GTCFilesPath}/${SentrixBarcode_A}/"


# Make symlinks
mkdir -p "${resultDir}"
mkdir -p "${resultDir}/${SentrixBarcode_A}"

cd "${resultDir}/${SentrixBarcode_A}"


for i in $(ls "${GTCFilesPath}/${SentrixBarcode_A}"/*.gtc)
do
	echo "symlinking: ${i}"
	ln -sf "${i}"
	echo "symlinking: ${i}.md5"
	ln -sf "${i}.md5"
done

cd -
