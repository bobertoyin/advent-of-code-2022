for file in advent/*
do
    echo "running $file"
    racket "$file"
done