source_repo="https://github.com/jsharma19/perform2021-quality-gates"
clone_folder="bootstrap"
home_folder="/home/dtu_training"

rm -rf bootstrap
##############################
# Clone repo                 #
##############################
cd $home_folder
mkdir "$clone_folder"
cd "$home_folder/$clone_folder"
git clone "$source_repo" .
chown -R dtu_training $home_folder/$clone_folder
cd "$home_folder/$clone_folder/"
chmod u+x ./build.sh  
./build.sh "$home_folder" "$clone_folder" "$source_repo"

