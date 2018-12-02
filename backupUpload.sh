#!/bin/sh
# Takes backup of a particular mysql database and uploads it to google drive
set -e

# user running the script should have write access to it.
DUMP_DIR="/location/to/db_dump_dir"
DB_NAME=db_name_here
DB_USER=db_user_here
DB_PASSWORD=db_password_here
DATE_FORMAT="%Y-%m-%d_%H"
# Example
# https://drive.google.com/drive/folders/THIS_IS_SOME_RANDOM_FOLDER_ID
GOOGLE_DRIVE_FOLDER=google_drive_folder_id

file_name="$(date +$DATE_FORMAT)"
sql_file="$file_name.sql"
gz_file="$file_name.tar.gz"

# make sure that the folder exists
mkdir -p $DUMP_DIR
cd $DUMP_DIR

# mysqlbackup, tar gz and delete sql file
mysqldump -u$DB_USER -p$DB_PASSWORD $DB_NAME > $sql_file
tar -zvcf $gz_file $sql_file
rm $sql_file

gdrive upload --parent $GOOGLE_DRIVE_FOLDER $gz_file
rm $gz_file
