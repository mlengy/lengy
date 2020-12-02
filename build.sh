#!/bin/bash
IFS=$'\n'
RED='\033[0;31m';
GREEN='\033[0;32m';
YELLOW='\033[0;33m';
CYAN='\033[0;36m';
PURPLE='\033[0;35m';
RESET='\033[0m';
ENDING="\n${RED}";
INDENT="${RESET}    ";
DIR_CHMOD=755;
FILE_CHMOD=644;

if [ -z ${LENGY_DEV+x} ]; then
    printf "${RED}ERROR: [${PURPLE}\$LENGY_DEV${RED}] is not set!\n";
    exit 1;
fi

if [ -z ${LENGY_WWW+x} ]; then
    printf "${RED}ERROR: [${PURPLE}\$LENGY_WWW${RED}] is not set!\n";
    exit 1;
fi

if [ -z ${LENGY_ROOT+x} ]; then
    printf "${RED}ERROR: [${PURPLE}\$LENGY_ROOT${RED}] is not set!\n";
    exit 1;
fi

printf "${RED}WARNING: This will erase [${PURPLE}${LENGY_WWW}${LENGY_ROOT}${RED}] if it exists!\n${RESET}Press ${GREEN}enter${RESET} to continue or ${RED}ctrl-c${RESET} to cancel.\n";
read -p "";

printf "${YELLOW}Refreshing root...\n${ENDING}";

printf "${INDENT}Recursively removing [${RED}${LENGY_WWW}${LENGY_ROOT}${RESET}]${ENDING}";
sudo rm -rf ${LENGY_WWW}${LENGY_ROOT};

printf "${INDENT}Recreating [${PURPLE}${LENGY_WWW}${LENGY_ROOT}${RESET}]${ENDING}";
sudo mkdir ${LENGY_WWW}${LENGY_ROOT};

printf "\n";

printf "${YELLOW}Mirroring directories...\n${ENDING}";

for directory in $(find ${LENGY_DEV}${LENGY_ROOT} -type d); do
    trimmed_directory=$(echo ${directory#${LENGY_DEV}});
    if [ "${LENGY_WWW}${trimmed_directory}" != "${LENGY_WWW}${LENGY_ROOT}" ]; then
        printf "${INDENT}Creating [${PURPLE}${LENGY_WWW}${trimmed_directory}${RESET}]${ENDING}";
        sudo mkdir ${LENGY_WWW}${trimmed_directory};
    else
        printf "${INDENT}Skipping [${YELLOW}${LENGY_WWW}${trimmed_directory}${RESET}]${ENDING}";
    fi
done

printf "\n";

for directory in $(find ${LENGY_WWW}${LENGY_ROOT} -type d); do
    printf "${INDENT}Adjusting permissions on [${CYAN}${directory}${RESET}] to [${YELLOW}${DIR_CHMOD}${RESET}]${ENDING}";
    sudo chmod ${DIR_CHMOD} ${directory};
done

printf "\n";

printf "${YELLOW}Mirroring files...\n${ENDING}";

for file in $(find ${LENGY_DEV}${LENGY_ROOT} -type f); do
    trimmed_file=$(echo ${file#${LENGY_DEV}});
    printf "${INDENT}Copying [${CYAN}${LENGY_DEV}${trimmed_file}${RESET}] to [${GREEN}${LENGY_WWW}${trimmed_file}${RESET}]${ENDING}";
    sudo cp ${LENGY_DEV}${trimmed_file} ${LENGY_WWW}${trimmed_file};
done

printf "\n";

for file in $(find ${LENGY_WWW}${LENGY_ROOT} -type f); do
    printf "${INDENT}Adjusting permissions on [${CYAN}${file}${RESET}] to [${YELLOW}${FILE_CHMOD}${RESET}]${ENDING}";
    sudo chmod ${FILE_CHMOD} ${file};
done

printf "\n${GREEN}Done!${RESET}\n";

unset IFS;
