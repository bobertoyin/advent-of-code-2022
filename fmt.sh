for file in advent/*
do
    echo "formatting $file"
    raco fmt -i "$file"
done

for file in test/*
do
    echo "formatting $file"
    raco fmt -i "$file"
done