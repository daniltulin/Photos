hash oclint &> /dev/null
if [ $? -eq 1 ]; then
  echo >&2 "oclint not found, analyzing stopped"
  exit 1
fi

cd ${TARGET_TEMP_DIR}

if [ ! -f compile_commands.json ]; then
  echo "[*] compile_commands.json not found, possibly clean was performed"
  echo "Workspace Path : ${MY_WORKSPACE}"
  echo "[*] starting xcodebuild to rebuild the project.."
  # clean previous output

  if [ -f xcodebuild.log ]; then
    rm xcodebuild.log
    echo "Oclint Clean performed"
  fi

  cd ${SRCROOT}

  xcodebuild clean

  #build xcodebuild.log
  xcodebuild ONLY_ACTIVE_ARCH=NO -workspace ${PROJECT_NAME}.xcworkspace -scheme ${PROJECT_NAME} -configuration Debug clean build| tee ${TARGET_TEMP_DIR}/xcodebuild.log | xcpretty
  #xcodebuild <options>| tee ${TARGET_TEMP_DIR}/xcodebuild.log

  echo "[*] transforming xcodebuild.log into compile_commands.json..."
  cd ${TARGET_TEMP_DIR}
  #transform it into compile_commands.json
  oclint-xcodebuild

fi

echo "[*] starting analyzing"
cd ${TARGET_TEMP_DIR}

oclint-json-compilation-database -e ${SRCROOT}/Pods/ -e ${SRCROOT}/Hackathon/Model -v oclint_args | sed 's/\(.*\.\m\{1,2\}:[0-9]*:[0-9]*:\)/\1 warning:/'
