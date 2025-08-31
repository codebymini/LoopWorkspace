#!/bin/zsh

set -e
set -u

# this script prepares a branch of LoopWorkspace based on dev plus the translation branches just created
# users can build this branch to get the most recent localizations before this is merged to the dev branch

source Scripts/define_common.sh
submodule_list=" "

echo "You must be in the LoopWorkspace folder and the translations folders must exist for submodules with updates"

if git switch "${test_lw_dir}"; then
    echo "The branch ${test_lw_dir} exists"
else
    echo "The branch ${test_lw_dir} does not exist; it will be created from dev"
    git switch dev
    git pull
    git switch -c "${test_lw_dir}"
fi

echo "The ${translation_dir} branch will be commited for each submodule with changes"
echo "Enter y to continue, any other key to exit"
read query
if [[ ${query} == "y" ]]; then

    for project in ${projects}; do
        echo "checking submodule $project"
        IFS=":" read user dir branch <<< "$project"
        echo "parts = $user $dir $branch"
        cd $dir
        if git switch "${translation_dir}"; then
            submodule_list+=" ${dir}"
        fi
        cd -
        git add ${dir}
    done

    echo "The submodules to update are ${submodule_list}"
    # Get the length of the string
    string_length=${#submodule_list}
    MIN_LENGTH=4

    if [[ ${string_length} -gt $MIN_LENGTH ]]; then
        git commit -m "update submodules: use translation branch before merge"
        git push --set-upstream origin ${test_lw_dir} 
        echo "The branch ${test_lw_dir} has been pushed to LoopKit / LoopWorkspace"
    else
        echo "No submodules have branches named ${translation_dir}"
        echo "quitting with no changes"
    fi

fi