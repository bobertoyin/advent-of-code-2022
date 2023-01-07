for file in test/*
do
    echo "running $file"
    racket "$file"
done