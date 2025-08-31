# Manual Localization Instructions

Table of Contents:

* [Overview](#overview)
    * [Overview: From lokalise to LoopWorkspace](#overview-from-lokalise-to-loopworkspace)
    * [Overview: From LoopWorkspace to lokalise](#overview-from-loopworkspace-to-lokalise)
    * [Open questions and notes](#open-questions-and-notes)
* [Loop Dashboard at lokalise](#loop-dashboard-at-lokalise)
* Script Usage
* Translations
* From lokalise to LoopWorkspace
    * [Download from lokalise](#download-from-lokalise)
    * [Import xliff files into LoopWorkspace](#import-xliff-files-into-loopworkspace)
    * [Review Differences](#review-differences)
    * [Commit Submodule Changes and Create PRs](#commit-submodule-changes-and-create-prs)
    * [Review the Open PR and merge](#review-the-open-pr-and-merge)
* [Finalize with PR to LoopWorkspace](#finalize-with-pr-to-loopworkspace)
* From LoopWorkspace to lokalise
    * [Prepare xliff_out folder](#prepare-xliff_out-folder)
    * [Update lokalise strings](#update-lokalise-strings)
* [Utility Scripts](#utility-scripts)

## Overview

Translations for Loop are performed by volunteers at [lokalise](https://app.lokalise.com/projects). 
Several scripts were added to assist in bringing those translations into the repositories and updating keys when strings are added or modified.

To volunteer, join [Loop zulipchat](https://loop.zulipchat.com/) and send a direct message to Marion Barker with your email address and the language(s) you can translate.

The first set of scripts were created in 2023 to automate the localization process. (Refer to these as the original scripts.)

* Scripts/import_localizations.sh
* Scripts/export_localizations.sh

New scripts were created in 2025 to provide smaller steps and to allow review before the modifications are committed and PR are opened.

These new scripts have "manual" in the script name.

* The "import" in the original script name refered to importing xliff files from lokalise to provide updated localization for LoopWorkspace and associated submodules
    * This script was used to bring in new translations into the LoopWorkspace submodules
* The "export" in the original script name refered to exporting localization from LoopWorkspace and associated submodules into xliff files and uploading them to the localise site
    * This script was used to upload modifications to the strings in any of the workspace submodules

In addition to breaking the original import and export scripts into components:
* Scripts/define_common.sh is used by other scripts to provide a single source for the list of:
    * filename with message indicating download time from lokalise for commit messages and PR titles
    *  used by some of the scripts for output and input
    * LANGUAGES (list of all languages to be included)
    * projects (all the submodules for LoopWorkspace with owners and branches)

### Overview: From lokalise to LoopWorkspace

For details, see [From lokalise to LoopWorkspace](#from-lokalise-to-loopworkspace)

These scripts break the original import_localizations script into smaller components:

* manual_download_from_lokalise.sh
* manual_import_localizations.sh
* manual_review_translations.sh
* manual_finalize_translations.sh

### Overview: From LoopWorkspace to lokalise

For details, see [From LoopWorkspace to lokalise](#from-loopworkspace-to-lokalise)

This script prepares xliff files for each language (for all repositories) from LoopWorkspace suitable to be uploaded to lokalise:

* manual_export_localizations.sh
* manual_upload_to_lokalise.sh (wip not tested yet)

### Open questions and notes

> Notes from Marion Barker:

#### Question 1:

I do not believe these keys should be included in the translation process:

* CFBundleGetInfoString
* CFBundleNames
* NSHumanReadableCopyright

These were almost all empty. I deleted these keys on 2025-07-27 on the lokalise site.

At the current time, these keys will be deleted manually after dragging xliff files to the localise site. Eventually, it would be nice to automate this, but one step at a time.

#### Question 2:

A lot of the changes that were proposed were white space changes. If we need to make these whitespace changes, then we can do so. But if there's a method I missed to avoid them, I'd prefer to take that.

I discussed this with Pete and we agreed to do the one time change to all the repositories for the keys.

Here's an example of a whitespace change:

```
diff --git a/RileyLinkKitUI/nb.lproj/Localizable.strings b/RileyLinkKitUI/nb.lproj/Localizable.strings
index fbfc31e..db53cbd 100644
--- a/RileyLinkKitUI/nb.lproj/Localizable.strings
+++ b/RileyLinkKitUI/nb.lproj/Localizable.strings
@@ -74,7 +74,7 @@
 "Name" = "Navn";
 
 /* Detail text when battery alert disabled.
-   Text indicating LED Mode is off */
+Text indicating LED Mode is off */
 "Off" = "Av";
 
 /* Text indicating LED Mode is on */
```

#### Question 3:

Both OmniBLE and OmniKit seem to be adding new xx.lproj folders at the top level with the languages already being present in other folders. These have associated changes to the `pbxproj` file. I'm confused by this and wonder if this is something that should be fixed.

#### Status on 2025-08-10

Updated the LocalizationInstructions.md file after running through the sequence documented in this file:

1. Download from lokalise (manual_download_from_lokalise.sh)
2. Import into LoopWorkspace (manual_import_localizations.sh)
3. Review Differences (manual_review_translations.sh)
4. Commit Submodule Changes and Create PRs (manual_finalize_translations.md)

Only 4 PR were opened because of permission limits and desire to go over the method before finalizing. All 4 PR were converted to drafts.

> These were created with the updated scripts and will be discussed before merging. They exhibit questions 1, 2 and 3.

#### Status on 2025-08-24

Additional changes were made to the scripts and this file was updated in the course of running the scripts.

In several cases, the script would have modified a pbxproj file in the manner discussed in [Review Differences](#review-differences). These were avoided for these repositories:

* LoopKit, OmniBLE, OmniKit
* did a spot check and the majority of the strings in the newly added top level ll.lproj/Localizable.strings were already in a lower level folder, so removing those additions are probably OK
* can always add them later if this was a mistake
* would rather not add more confusion right now

specific commands for those repositories
```
cd LoopKit
git restore LoopKit.xcodeproj/project.pbxproj
rm -rf LoopKit/it.lproj/
rm -rf LoopKit/nb.lproj/
cd ..

cd OmniBLE
# ignore the top level lproj folders already there:
#   de, it, nb, nl, pl, ru
git restore OmniBLE.xcodeproj/project.pbxproj
rm -rf da.lproj/
rm -rf fr.lproj/
cd ..

cd OmniKit
git restore OmniKit.xcodeproj/project.pbxproj
rm -rf da.lproj/
rm -rf de.lproj/
rm -rf fr.lproj/
rm -rf it.lproj/
rm -rf nb.lproj/
rm -rf nl.lproj/
rm -rf pl.lproj/
rm -rf ru.lproj/
cd ..
```
 
## Loop Dashboard at lokalise

When you log into the [lokalise portal](https://app.lokalise.com/projects), navigate to the Loop dashboard, you see all the languages and the % complete for translation.

## Translations

The translations are performed by volunteers. To volunteer, join [Loop zulipchat](https://loop.zulipchat.com/) and send a direct message to Marion Barker with your email address and the language(s) you can translate.

## Script Usage

Some scripts require a LOKALISE_TOKEN. 

When the user is a manager for the Loop project at lokalise, they create a LOKALISE_TOKEN (API token) with read/write privileges and use those scripts after generating their own token and exporting that token, e.g.,

```
export LOKALISE_TOKEN=<token>
```

Be sure to save the token in a secure location.

## From lokalise to LoopWorkspace

This has been broken into 4 separate scripts to allow review at each step.

### Download from lokalise

The `manual_download_from_lokalise.sh` script requires a LOKALISE_TOKEN with at least read privileges, see [Script Usage](#script-usage).

This script:

* deletes any existing xliff_in folder
* downloads the localization information from lokalise into a new xliff_in folder
* generates a temporary `xlate_pr_title.txt` file used for the commit message and titles for PRs to the submodules and LoopWorkspace

If you get a warning: `Warning: Project too big for sync export. Please use our async export endpoint instead`
just try again later.

### Import xliff files into LoopWorkspace

**Bullet summary** of the `manual_import_translations.sh` script:

* create `translations` branch for each submodule (project)
* command-line Xcode build before importing xliff files
* command-line Xcode build for each language importing from the associated xliff file
* after completion, LoopWorkspace may have uncommitted changes in submodules

**Descriptive summary** of the  `manual_import_translations.sh` script.

The `manual_import_translations.sh` script pulls the most recent tip from each submodule, creates a `translations` branch at that level in preparation for importing the localizations from xliff_in into LoopWorkspace and all the submodules.

> Warning: this deletes any existing `translations` branch from each submodule. If you need to "save your work", check out [Utility Scripts](#utility-scripts).

It then goes through each language and brings in updates from the xliff_in folder.

The result is that any updated localizations shows up as a diff in each submodule.

> The default branch name used for all the submodules is `translations`. If you want to modify that, edit Scripts/define_common.sh and change `translation_dir` before executing the script. This change will then be reflected in 3 scripts: import, review and finalize. In general, it is best to stick with `translations` as the branch name.

Before running this script:

* Confirm the list of `projects` in Scripts/define_common.sh  is up to date regarding owner, repository name, repository branch
* Trim any branches on GitHub with the name `translations`
    * The trimming should have happened when the last set of translations PR were merged
    * If not, do it now

Execute this script:

```
./Scripts/manual_import_localizations.sh
```

### Review Differences

The `InfoPlist.strings` may already be included in some cases. Don't worry about those. But do not add new ones.

* If there is a change to the *.xcodeproj/project.pbxproj - it may be duplicate strings
    * make sure that any new strings in the new files are handled in the existing Localizable.strings files for each language that has a new lproj folder added at the top level
    * git restore the pbxproj file
    * rm the new files that contain those strings
    * verify that LoopWorkspace still builds correctly
* Note - when there already duplicates of the same string in more than one lproj folder
    * save doing clean up for later
    * just do not add to the confusion for now

Use the `manual_review_translations.sh` script in one terminal and open another terminal if you want to look in detail at a particular submodule:

```
./Scripts/manual_review_translations.sh
```

After each submodule, if any differences are detected, the script pauses with the summary of files changed and allows time to do detailed review (in another terminal). Hit return when ready to continue the script.

Examine the diffs for each submodule to make sure they are appropriate.

> In earlier tests, there are some changes that are primarily white space, so I did not commit those. See question 2 in [Open questions and notes](#open-questions-and-notes).

> Go ahead and prepare the white space diffs as PR for final review.

### Commit Submodule Changes and Create PRs

> Before running this script, ensure that code builds using Mac-Xcode GUI.

**Bullet summary** of action for each submodule by the `manual_finalize_translations.sh` script:

* if there are no changes, no action is taken
* if there are changes
    * git add .; commit all with automated message
    * push the `translations` branch to origin
    * create a PR from `translations` branch to default branch for that repository
    * open the URL for the PR

**Descriptive summary** of action for each submodule by the `manual_finalize_translations.sh` script.

You should have trimmed any `translations` branches on any GitHub repositories before running the import script. If not, do it before running the `manual_finalize_translations.sh` script.

Once all the diffs have been reviewed and you are ready to proceed, run this script:

```
./Scripts/manual_finalize_translations.sh
```

Assuming the permission are ok for each repository that is being changed, this should run without errors, create the PRs and open each one.

If the person running the script does not have appropriate permissions to push the branch, the commits are already made for that repository before attempting to push, so the user can just run the script again to proceed to the next repository.

The missing PR need to be handled separately. But really the person running the script should have permissions to open new PR.

If an error is seen with this hint - you need to go to GitHub and trim the translations branch and then push and create the pr manually:

> Updates were rejected because the tip of your current branch is behind its remote counterpart.

### Review the Open PR and merge

At this point, get someone to approve each of the open PR and merge them. Be sure to trim the `translations` branch once the PR are merged.

## Finalize with PR to LoopWorkspace

An interim script was added. It creates a new branch: dev_translations_test and commits the changes for any submodule that has a translations branch. It also allows updates to scripts and instructions to be committed as well. See:

* manual_test_LoopWorkspace_translations.sh

Once all the localization PR have been finished and merged, LoopWorkspace needs to be updated as well. Below are some of the CLI steps that could be used. Probably want to create another manual script for doing the final PR leading to the next update to dev branch.

Prepare the local clone for updates and create a new branch:

```
git switch dev
git pull --recurse
git switch -c translations
```

Update all submodules to the latest tip of their branches - this brings in all the new translations:

```
./Scripts/update_submodule_refs.sh
```

Use the `xlate_pr_title.txt` file created when downloading from lokalise:
```
git commit -F xlate_pr_title.txt
git push --set-upstream origin translations
```

Create the PR from this branch.

```
gh pr create -B dev  -R LoopKit/translations --title xlate_pr_title.txt
```

All the actions above can be done with a script once one is prepared.

## From LoopWorkspace to lokalise

### Prepare xliff_out folder

The `manual_export_translations.sh` script is used to prepare xliff files to be uploaded to lokalise for translation.

It is normally required for any code updates that add or modify the strings that require localization.

First navigate to the LoopWorkspace directory in the appropriate branch, normally this is the `dev` branch. Make sure it is fully up to date with GitHub.

Make sure the scripts are executable. You may need to apply `chmod +x` to the scripts.

Make sure the Xcode workspace is **not** open on your Mac or this will fail.

```
./Scripts/manual_export_localizations.sh
```

This creates an xliff_out folder filled with xliff files, one for each language, that contains all the keys and strings for the entire clone (including all submodules).

### Update lokalise strings

This section requires the user have `manager` access to the Loop project.

The instructions here are for a manual drag and drop. At a later time, the manual_upload_to_localise.sh script will be tested and should replace this section.

Log into the [lokalise portal](https://app.lokalise.com/projects) and navigate to Loop.

Select [Upload](https://app.lokalise.com/upload/414338966417c70d7055e2.75119857/)

Drag the *.xliff files from the xliff_out folder (created by export_localizations.sh) into the drag and drop location.

Be patient

* while each language is uploaded, the `uploading` indicator shows up under each language on the left side
* at the bottom of the list, the `Import Files` should be available when all have completed uploading
    * Tap on `Import Files`
* progress will show at upper right

When this is done, check the Loop lokalise dashboard again to see updated statistics.

Go through an delete all the keys from InfoPlist.strings. We do not yet know how to prevent these from being added as items to translate.

Next time through, hide the keys instead of deleting them, maybe that will "stick" and we won't have to do it again

These keys should not be included in the translation process - make sure they are hidden (or possibly deleted):

* CFBundleGetInfoString
* CFBundleNames
* NSHumanReadableCopyright

## Utility Scripts

If you need to start over but don't want to lose prior work, use archive_translations.sh. This is suitable for use after manual_import_localizations and manual_review_translations and before manual_finalize_translations.

If you want to change paths for translations and archived translations, edit Scripts/define_common.sh before running.

* archive_translations.sh
    * internal names that can be edited in define_common.sh:
        * archive_dir="test_translations"
        * translation_dir="translations"

