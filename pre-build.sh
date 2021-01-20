source_repo="https://github.com/diegorqc/perform2021-quality-gates"
repo_folder="perform2021-quality-gates" 
clone_folder="bootstrap"
home_folder="/home/$shell_user"

##############################
# Clone repo                 #
##############################
cd $home_folder
mkdir "$clone_folder"
cd "$home_folder/$clone_folder"
git clone "$source_repo" .
chown -R $shell_user $home_folder/$clone_folder
cd $repo_folder
./build.sh "$home_folder" "$clone_folder" "$source_repo"

