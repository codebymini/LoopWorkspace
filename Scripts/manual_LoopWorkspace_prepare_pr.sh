#!/bin/zsh

set -e
set -u

# this script prepares a branch of LoopWorkspace based on current local branch.
# It brings in the tip of all the submodule branches which should have just
# been updated with the manual download, import, review and finalize scripts.
# After all those PR are merged and the translation branches trimmed,
# the next step is to prepare the PR to update LoopWorkspace dev branch

source Scripts/define_common.sh

section_divider

echo "You must be in the LoopWorkspace folder ready to bring in "
echo "  all the latest versions of the submodules which were "
echo "  just translated"

echo ""
echo "This script will prepare a PR to LoopWorkspace '${target_loopworkspace_dir}' branch"

echo ""
echo "1. If the branch name is not already '${translation_dir}', then"
echo "   that branch will be created and used for this PR"
echo "2. ./Scripts/update_submodule_refs.sh will be executed"
echo "3. The commit message in the ${message_file} will be used"
cat ${message_file}
echo "4. Once the PR is prepared, additional commits can be added as needed"

section_divider

echo "Enter y to proceed, any other character exits"
read query

if [[ ${query} == "y" ]]; then

    current_branch=$(git branch --show-current 2>/dev/null)
    echo "current_branch = $current_branch"

    if [[ "${current_branch}" == "${translation_dir}" ]]; then
            echo "already on $translation_dir, ok to continue"
    
    elif git rev-parse --verify --quiet "${translation_dir}"; then
        echo "Local branch '$translation_dir' exists."
            echo "You are on $current_branch and $translation_dir already exists"
            echo "quitting"
            exit 1 # exit with failure
    
    else
        echo "Local branch $translation_dir does not exist,"
        echo "creating it from the current branch, $current_branch."
        git switch -c "${translation_dir}"
    fi

    section_divider

    ./Scripts/update_submodule_refs.sh

    section_divider
    echo ""
    echo "After you review, get approvals and merge the PR"
    echo " be sure to trim the ${translation_dir} branch,"
    echo " and then run the export and upload scripts again from the updated dev branch"
    section_divider

else
    echo "user opted to exit the script"
    section_divider
fi
