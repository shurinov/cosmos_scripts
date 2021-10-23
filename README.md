# Cosmos node tool scripts

## Usadge
1. Copy file **cos_var_template.sh** and rename to **cos_var.sh**
2. Insert your's node parameters in **cos_var.sh**
3. Change scripts permissions: 
 ```
chmod +x *.sh 
 ```
4. Add **cosmos_scripts** directory to PATH
```
echo export PATH='$PATH':$PWD >> $HOME/.bash_profile && . $HOME/.bash_profile
```
5. Scripts ready to use
