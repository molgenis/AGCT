#MOLGENIS walltime=05:59:00 mem=8gb ppn=1

#string #iaapVersion
#string bpmFile
#string egtFile
#string SentrixBarcode_A
#string ConvertDir
#string IDATFilesPath
#string logsDir
#string Project
#string runID


module load "${iaapVersion}"
module list

makeTmpDir "${ConvertDir}/"
tmpConvertDir="${MC_tmpFile}"

if [ !-f "${logsDir}//${Project}/${runID}.convert_idat_gtc.started" ]
then
	touch ${logsDir}//${Project}/${runID}.convert_idat_gtc.started
else
	echo "${logsDir}//${Project}/${runID}.convert_idat_gtc.started allready exist"
done

##Command to convert IDAT files to GTC files
/apps/software/IAAP/cli-rhel.6-x64-1.1.0/iaap-cli/iaap-cli gencall "${bpmFile}" "${egtFile}" "${tmpConvertDir}" "${IDATFilesPath}/${SentrixBarcode_A}"


## md5sum the output



mkdir -p "${resultDir}/"

#Move vcf and sd values to intermediateDir
echo "moving ${tmpConvertDir}/${SentrixBarcode_A} ${resultDir}/"
mv "${tmpConvertDir}/${SentrixBarcode_A}" "${resultDir}/"
