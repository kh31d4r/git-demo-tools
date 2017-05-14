find_repo_root()
{
    start_dir=$PWD;

    if [ -d .git ]; then
        return;
    fi
    if [ $PWD = "/" ]; then
        echo "Not in a git repository";
        exit 1;
    fi

    cd ..;
    find_repo_root;
}

init_repo()
{
    mkdir .git;
    mkdir .git/refs;
    mkdir .git/objects;
    echo 'ref: refs/heads/master' > .git/HEAD;
}

replace_current_repo()
{
    rm -rf .git *;
    init_repo;
    git remote add origin $EXAMPLEREPOS/$1;
    git pull -q origin master;
    git remote rm origin;
}
