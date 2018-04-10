#!/bin/bash

# Please enter your information here
printf "Please enter your SEASNet ID: "
read SEASNET_ID

# Configuration
# this server is more stable than cs32 and does the exact same thing
SEASNET_SERVER="lnxsrv07.seas.ucla.edu"
TARBALL="project1.tar.gz"
DESTINATION="$SEASNET_ID@$SEASNET_SERVER"
FILES_WITHOUT_MAIN="Flatulan.h Player.h History.h City.h Game.h globals.h Flatulan.cpp
Player.cpp History.cpp City.cpp Game.cpp utilities.cpp"
REMOTE_PROJECT_PATH="~/CS32/Project1/test"
MAIN_TEST_FOLDER="main_test"
g32="/usr/local/cs/bin/g32"

# If compiled with these test main files, the compilaation should pass
MAIN_TEST_PASS_LIST="main_test0.cpp main_test1.cpp main_test2.cpp main_test3.cpp main_test4.cpp
main_test5.cpp main_test6.cpp main_test7.cpp main_test8.cpp main_test9.cpp"

# IF compiled with these test main files, the compilation should fail
MAIN_TEST_FAIL_LIST="main_test_n0.cpp main_test_n1.cpp main_test_n2.cpp main_test_n3.cpp"

compile_on_server () {
    main_test=$1
    intend_to=$2

    echo "Start testing $main_test..."
    cp $MAIN_TEST_FOLDER/$main_test .
    FILES="$FILES_WITHOUT_MAIN $main_test"

    echo "Transferring source codes onto server..."
    # Compress the desired files into a tarball
    # the COPYFILE_DISABLE option will stop Mac from creating the annoying ._* files
    COPYFILE_DISABLE=1 tar czf "$TARBALL" $FILES
    # Make a directory to host testing files in the server and clear all the existing files
    ssh "$DESTINATION" "rm -rf $REMOTE_PROJECT_PATH && mkdir -p $REMOTE_PROJECT_PATH"
    # Transfer the file to SEASNet server
    scp -q "$TARBALL" "$DESTINATION:$REMOTE_PROJECT_PATH"

    # Delete the generated local files
    rm -f "$main_test" "$TARBALL"

    # Extract source codes on the server
    ssh "$DESTINATION" "cd $REMOTE_PROJECT_PATH && tar xzf $TARBALL"

    RED='\033[0;31m'
    echo "Compiling the source codes on SEASnet server..."
    if [ "$intend_to" = "pass" ]
    then
       ssh "$DESTINATION" "cd $REMOTE_PROJECT_PATH && $g32 -o project1 *.cpp" || (echo -e "${RED}Compilation should succeed but failed." && exit)
       echo "Compilation succeeds as desired."
       echo
    fi

    if [ "$intend_to" = "fail" ]
    then
        ssh "$DESTINATION" "cd $REMOTE_PROJECT_PATH && $g32 -o project1 *.cpp" && (echo -e "${RED}Compilation should fail but succeeded." && exit)
        echo "Compilation fails as desired."
        echo
    fi
}

for main_test in $MAIN_TEST_PASS_LIST; do
    compile_on_server "$main_test" "pass"
done

for main_test in $MAIN_TEST_FAIL_LIST; do
    compile_on_server "$main_test" "fail"
done

