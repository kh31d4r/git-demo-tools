ensure_config()
{
    if [ -z $EXAMPLEREPOS ]; then
        echo '$EXAMPLEREPOS not set!';
        exit 1;
    fi
}

ensure_notempty()
{
    if [ -z $2 ]; then
        echo "Missing parameter: $1";
        exit 1;
    fi
}
