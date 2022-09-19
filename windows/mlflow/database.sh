createuser -e mlflow -s
psql -U postgres -c "CREATE DATABASE mlflow;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow;"

exit