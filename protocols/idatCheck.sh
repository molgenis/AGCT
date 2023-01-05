#MOLGENIS walltime=05:59:00 mem=8gb ppn=1

#string SentrixBarcode_A
#list SentrixPosition_A
#string IDATFilesPath
#string logsDir
#string Project
#string runID
#string samplesheet

##Command to convert IDAT files to GTC files

array_contains () {
	local array="$1[@]"
	local seeking="${2}"
	local in=1
	for element in "${!array-}"; do
		if [[ "${element}" == "${seeking}" ]]; then
			in=0
			break
		fi
	done
	return "${in}"
}

POSITION=()

for SentrixPosition in "${SentrixPosition_A[@]}"
do
		array_contains POSITION "${SentrixPosition}" || POSITION+=("${SentrixPosition}")
done

missingIDATs=()

for position in "${POSITION[@]}"
do
	if ls "${IDATFilesPath}/${SentrixBarcode_A}/${SentrixBarcode_A}_${position}_Grn.idat" 1> /dev/null 2>&1
	then
		echo "${IDATFilesPath}/${SentrixBarcode_A}/${SentrixBarcode_A}_${position}_Grn.idat available
		if find "${IDATFilesPath}/${SentrixBarcode_A}/${SentrixBarcode_A}_${position}_Red.idat" 1> /dev/null 2>&1
		then
			echo "${IDATFilesPath}/${SentrixBarcode_A}/${SentrixBarcode_A}_${position}_Red.idat available
		else
			echo "${IDATFilesPath}/${SentrixBarcode_A}/${SentrixBarcode_A}_${position}_Red.idat not found"
			missingIDATs+=("${position}")
		fi
	else
		echo "${IDATFilesPath}/${SentrixBarcode_A}/${SentrixBarcode_A}_${position}_Grn.idat not found"
		missingIDATs+=("${position}")
		continue
	fi


done

rm -f "${IDATFilesPath}/${SentrixBarcode_A}/missingIDATs.txt"
samplesheetSize=$(tail -n+2 ${samplesheet} | wc -l)
if [[ "${#missingIDATs[@]}" == "0" ]]
then
	echo "All the IDATs for ${SentrixBarcode_A} are created"
elif [[ "${#missingIDATs[@]}" == "${samplesheetSize}" ]]
then
	echo -e "There are no idat files scanned (probably due to a restart which produced the ${SentrixBarcode_A}_qc.txt and therefore a false start of the pipeline)\n, exit!"
	exit 1
else
	for position in ${missingIDATs[*]}
	do
		declare -a sampleSheetColumnNames=()
		declare -A sampleSheetColumnOffsets=()
		IFS=',' sampleSheetColumnNames=($(head -1 "${samplesheet}"))

		for (( _offset = 0 ; _offset < ${#sampleSheetColumnNames[@]:-0} ; _offset++ ))
		do
			sampleSheetColumnOffsets["${sampleSheetColumnNames[${_offset}]}"]="${_offset}"
		done
		sampleIDFieldIndex=$((${sampleSheetColumnOffsets['Sample_ID']} + 1 ))
		sampleID=$(grep ${SentrixBarcode_A} ${samplesheet} | grep ${position} | head -1 | awk -v extId="${sampleIDFieldIndex}" 'BEGIN {FS=","}{print $extId}')
		echo "For sample: ${sampleID} the IDATs are missing! Plate ${SentrixBarcode_A}, position: ${position}"
		echo "For sample: ${sampleID} the IDATs are missing! Plate ${SentrixBarcode_A}, position: ${position}" >> "${logsDir}/${Project}/${SentrixBarcode_A}.missingIDATs.txt"
		echo "${sampleID}:${SentrixBarcode_A}_${position}" >> "${IDATFilesPath}/${SentrixBarcode_A}/missingIDATs.txt"
	done
fi
