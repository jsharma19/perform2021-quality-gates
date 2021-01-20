source_repo="https://github.com/diegorqc/perform2021-quality-gates" 
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
chmod +rx build.sh
./build.sh $home_folder $clone_folder $source_repo

