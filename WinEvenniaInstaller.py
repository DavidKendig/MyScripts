import os

devDir = "C:/EvenniaWorlds"
mudName = "French Creek"

if os.path.exists(devDir) == False:
    os.system('powershell.exe "mkdir C:/EvenniaWorlds"')

if os.path.exists(devDir) == True:
    if os.path.exists(devDir + '/evennia') == False:
        os.system('powershell.exe "git clone https://github.com/evennia/evennia.git C:/EvenniaWorlds/evennia"')
    else:
        print('Evennia Server instance already exists')

if os.path.exists(devDir + '/evennia/evennia') == True:
    os.system('powershell.exe "pip install virtualenv"')

if os.path.exists(devDir + '/evennia/evennia') == True:
    os.system('powershell.exe "pip install virtualenv"')

if os.path.exists(devDir + '/evennia/evennia') == True:
    file = open(devDir + '/EvenniaCMDer.bat', 'w')
    file.writelines(['@echo off',
    '\nTitle EvenniaCMDer',
    '\ncolor 0a',
    '\n:loop',
    '\necho Please select the command you would like to be performed',
    '\necho [1] Enable evenv',
    '\necho [2] Change Directory',
    '\necho [0] Exit',
    '\nset input=',
    '\nset /p input= Please select Command:',
    '\nif %input%==1 goto evenv',
    '\nif %input%==0 goto exit',
    '\nexit',
    '\n:evenv',
    '\nC:/EvenniaWorlds/evenv/scripts/activate.bat'
    '\necho evenv active',
    '\necho --------------------------------------------------------------------------------',
    '\ngoto loop',
    '\n:exit',
    '\nexit'])
    file.close
