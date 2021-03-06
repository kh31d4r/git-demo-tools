find_repo_root()
{
    start_dir="$PWD";

    if is_repo ".git"; then
        return;
    fi
    if [ "$PWD" = "/" ]; then
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
    if ! is_example_repo "$repo"; then
       echo "Not an example repo!";
       exit 1;
    fi

    rm -rf "$repo" *;
    mkdir .git;
    cp -r $EXAMPLEREPOS/$1/metadata/* .git;
    cp -r $EXAMPLEREPOS/$1/tree/* .;
}

save_current_repo()
{
    repo_basedir="$EXAMPLEREPOS/$1";
    description="$2";
    rm -rf "$repo_basedir";
    mkdir -p $repo_basedir/{tree,metadata};
    cp -r * "$repo_basedir/tree";
    cp -r .git/* "$repo_basedir/metadata"

    mkdir -p "$repo_basedir/metadata/repotools";
    echo "$description" > "$repo_basedir/metadata/repotools/description";
}

list_repos()
{
    for dir in $EXAMPLEREPOS/*; do
        if [ -d "$dir" ]; then
            repo=$(basename "$dir");
            description=$(read_description "$dir");
            printf "%-20s %s\n" "$repo" "$description";
        fi
    done
}

is_repo()
{
    dir="$1"
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
    descriptionFile="$dir/metadata/repotools/description";
    if [ -f $descriptionFile ]; then
        cat $descriptionFile;
    else
        echo "";
    fi
}
