
ILMDIR="$HOME/.ilm"
DIR=$ILMDIR/ilmpg

if [ ! -d "$ILMDIR" ]; then
    mkdir "$ILMDIR"
    mkdir "$ILMDIR/extensions"
fi

if [ ! -d "$DIR" ]; then
    echo "Copying manual..."
    echo "Copying themes..."
    echo "Copying config.json..."
    cp -r ./ilmpg-install-dir "$DIR"

    echo "Copying ilmpg extension..."
    cp -r ./ilmpg-ext "$ILMDIR/extensions/ilmpg"

    echo "Complete!"
else
    echo "ilmpg installer: $DIR already exists"
fi