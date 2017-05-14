find_repo_root()
{
    start_dir=$PWD;

    if is_repo ".git"; then
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
    repo=".git";
    if ! is_example_repo $repo; then
       echo "Not an example repo!";
       exit 1;
    fi

    rm -rf $repo *;
    init_repo;
    cp -r $EXAMPLEREPOS/$1/repotools .git;
    git remote add origin $EXAMPLEREPOS/$1;
    git pull -q origin master;
    git remote rm origin;
}

save_current_repo()
{
    repo_basedir=$EXAMPLEREPOS/$1;
    description="$2";
    rm -rf "$repo_basedir";
    mkdir -p "$repo_basedir";
    mkdir -p .git/repotools;
    echo "$description" > .git/repotools/description;
    cp -r .git/* $repo_basedir;
}

list_repos()
{
    for dir in $EXAMPLEREPOS/*; do
        if is_repo "$dir"; then
            repo=$(basename "$dir");
            description=$(read_description "$dir");
            printf "%-20s %s\n" "$repo" "$description";
        fi
    done
}

is_repo()
{
    dir=$1
    [ -d "$dir/refs" ] && [ -d "$dir/objects" ] && [ -f "$dir/HEAD" ];
}

is_example_repo()
{
    dir="$1";
    [ -d "$dir/repotools" ];
}

read_description()
{
    dir="$1"
    descriptionFile="$dir/repotools/description";
    if [ -f $descriptionFile ]; then
        cat $descriptionFile;
    else
        echo "";
    fi
}
