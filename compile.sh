#!/bin/bash
src="./src/" # Make sure to put a "/" at the end
bin="./bin"
template="./template.tex"
tex=$(find $src -name "PS_*.tex")
flags="-halt-on-error -output-directory $bin"

mkdir -p $bin

# Get a PS filepath given a number
get_f () {
    return "${src%?}/PS_$1.tex"
}

# Compile a single file given its filepath
comp () {
    pdflatex $flags $1
    raw=$(echo "${1%.tex}" | cut -c ${#src}-)
    rm $bin/$raw.log
}
# Compile all tex files in $src
comp_all () {
    for doc in $tex; do
        comp $doc
    done;
}

# Make a new problem set
new () {
    echo "this is running"
    n=1
    for doc in $tex; do
        n=$(($n + 1))
    done;
    echo "$n"
    cp $template $src/PS_$n.tex
}

# Compile everything
if [ "$1" = "all" ]; then
    comp_all
fi

# Compile a specific ps
if [ "$1" = "ps" ]; then
    f=get_f $2
    comp $f
fi

# Initialize new problem set
if [ "$1" = "new" ]; then
    new
fi

# Clean bin/
if [ "$1" = "clean" ]; then
    rm -rf $bin/
fi

# Display help
if [ "$1" = "help" ]; then
    echo "Basic TeX Compilation Script"
    echo "commands:"
    echo "  - all"
    echo "      compile all problem sets"
    echo ""
    echo "  - ps <ps number>"
    echo "      compile a specific problem set"
    echo ""
    echo "  - new"
    echo "      create a new problem set"
    echo ""
    echo "  - clean"
    echo "      clean the build dir"
    echo ""
fi