#!/bin/zsh

set -e
set -u

# this script prepares a branch of LoopWorkspace based on current local branch.
# It brings in the tip of all the submodule branches which should have just
# been updated with the manual download, import, review and finalize scripts.
# After all those PR are merged and the translation branches trimmed,
# the next step is to prepare the PR to update LoopWorkspace dev branch

source Scripts/define_common.sh

echo "You must be in the LoopWorkspace folder ready to bring in "
echo "  all the latest versions of the submodules which were "
echo "  just translated"

echo ""
echo "1. ./Scripts/update_submodule_refs.sh will be executed"
echo "2. If the branch name is not already '${translation_dir}', then"
echo "   that branch will be created and used for this PR"
echo "3. The commit message in ${message_file} will be used"
cat ${message_file}
echo "4. Once the PR is prepared, additional commits can be added as needed"

echo "Enter y to proceed, any other character exits"
read query

if [[ ${query} == "y" ]]; then

    if git switch "${translation_dir}"; then
        echo "The branch ${translation_dir} exists"
    else
        echo "The branch ${translation_dir} does not exist; it will be created from the current path"
        git switch -c "${translation_dir}"
    fi

    ./Scripts/update_submodule_refs.sh

    echo ""
    echo "After completing this process, merging the PR and trimming the ${translation_dir} branch,"
    echo "  be sure to run the export and upload scripts again from the updated dev branch"

else
    echo "user opted to exit the script"
fi
