#!/bin/sh

BASE_BRANCH="origin/master"
REMOTE_NAME=gh-robux4

#git remote prune $REMOTE_NAME

echo "" > to_remove.txt
echo "#!/bin/sh" > del_remote.sh
echo "for branch in \\" >> del_remote.sh


# delete branches that have been fully merged upstream
for branch in $(git branch -r --list --sort=-committerdate --format="%(refname:lstrip=3)" "$REMOTE_NAME/*"); do
# for branch in ci-llvm11; do
    if [ "$branch" = "master" ] || [ "$branch" = "HEAD" ]; then
        continue
    fi

    echo ""
    echo "* Branch $REMOTE_NAME/$branch"

    # remove remote first (verify it merges cleanly first)
    ALL_MERGED=$(git cherry $BASE_BRANCH $REMOTE_NAME/$branch | sed '/^- /d' | wc -l)
    if test 0 -eq "$ALL_MERGED"; then
        echo "Branch $branch can be removed"
        echo "Branch $REMOTE_NAME/$branch can be removed" >> to_remove.txt
        echo "  $branch \\" >> del_remote.sh
    else
        echo "Branch $branch has not been merged ($ALL_MERGED commits differ)"
    fi
done

echo "  none_
do
    if [ \"\$branch\" = \"none_\" ]; then
        continue
    fi

    echo \$branch
    git push $REMOTE_NAME --delete \$branch
done
" >> del_remote.sh
