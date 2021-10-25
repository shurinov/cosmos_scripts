# Cosmos node tool scripts

## Usage
1. Copy file **cos_var_template.sh** and rename to **cos_var.sh**
```
cd cosmos_scripts
cp cos_var_template.sh cos_var.sh
```
2. Insert your's node parameters in **cos_var.sh**
```
nano cos_var.sh    #or another favorite text editor 
```
You should change **Common variables** and **Node info** section
Daemon's ports settings in template are according to cosmos default values. Most likely you will not need to change them.
3. Change scripts permissions: 
 ```
chmod +x *.sh 
 ```
4. Add **cosmos_scripts** directory to PATH
```
echo export PATH='$PATH':$PWD >> $HOME/.bash_profile && . $HOME/.bash_profile
```
5. Install some utils
```
sudo apt update && sudo apt install curl -y
```
6. Scripts ready to use
