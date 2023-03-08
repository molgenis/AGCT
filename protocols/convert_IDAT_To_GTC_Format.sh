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

set -e
set -u
set -o pipefail

module load "${iaapVersion}"
module list

mkdir -p "${convertDir}/${SentrixBarcode_A}"

#
# Convert IDAT files to GTC files.
#
"${EBROOTIAAP}"/iaap-cli/iaap-cli gencall "${bpmFile}" "${egtFile}" "${convertDir}/${SentrixBarcode_A}" -f "${IDATFilesPath}/${SentrixBarcode_A}" -g

#
# Create md5 checksums for the GTC files.
#
for gtcfile in "${convertDir}/${SentrixBarcode_A}/"*.gtc
	[[ -e "${gtcfile}" ]] || break  # Handle the case when no GTC files were present.
	md5sum "${gtcfile}" > "${gtcfile}".md5
done

#
# Move GTC files and their md5 checksums and optionally missingIDATs.txt to the rawdata/array/GTC/${SentrixBarcode_A}/ folder.
#
mkdir -p "${GTCFilesPath}/${SentrixBarcode_A}/"
echo "Moving ${convertDir}/${SentrixBarcode_A}/* to ${GTCFilesPath}/${SentrixBarcode_A}/ ..."
mv "${convertDir}/${SentrixBarcode_A}/"* "${GTCFilesPath}/${SentrixBarcode_A}/"

if [[ -e "${IDATFilesPath}/${SentrixBarcode_A}/missingIDATs.txt" ]]
then
	cp "${IDATFilesPath}/${SentrixBarcode_A}/missingIDATs.txt" "${GTCFilesPath}/${SentrixBarcode_A}/"
fi

#
# Make symlinks.
#
mkdir -p "${resultDir}/${SentrixBarcode_A}"
for gtcfile in "${GTCFilesPath}/${SentrixBarcode_A}"/*.gtc
do
	[[ -e "${gtcfile}" ]] || break  # Handle the case when no GTC files were present.
	echo "Symlinking: ${gtcfile} and corresponding checksum file ..."
	$(cd "${resultDir}/${SentrixBarcode_A}" && ln -sf "${gtcfile}" . && ln -sf "${gtcfile}.md5" .)
done
