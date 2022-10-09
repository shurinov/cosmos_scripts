# Cosmos node tool scripts

Clone repository (with submodules)
```
git clone --recurse-submodules https://github.com/shurinov/cosmos_scripts.git
```
or if you already cloned the project 
```
git submodule init
git submodule update
```

## Basic Usage
1. Copy file **cos_var_template.sh** and rename to **cos_var.sh**
```
cd cosmos_scripts
cp template_cos_var.sh cos_var.sh
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
5. Add to bash_profile load your COS_** variables to enviromet if it's need
```
echo . $PWD/cos_var.sh >> $HOME/.bash_profile && . $HOME/.bash_profile
```
6. Install some utils
```
sudo apt update && sudo apt install curl jq -y
```
7. Scripts ready to use


## Setup Alerts

Edit Alerts variables if it need
```
nano cos_var.sh
```
Copy tg bot template and insert Bot token and chat id
```
cd scripts_stuff
cp template_tgbot_vars.sh tgbot_vars.sh
nano tgbot_vars.sh
```

Setup cron for run alert each 1 minute
```
crontab -e
*/1 * * * * /path/to/cos_alerts.sh
```
