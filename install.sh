DIR=$HOME/.ilm/ilmpg

if [ ! -d "$DIR" ]; then
    echo "Copying manual..."
    echo "Copying themes..."
    echo "Copying config.json..."

    cp -r ./ilmpg-install-dir $DIR

    echo "Complete!"
else
    echo "ilmpg installer: $DIR already exists"
fi