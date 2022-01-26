#!/usr/bin/python3


# Dit script is bedoelt om de users van Zentyal over te zetten naar een .txt
# bestand. Een ander script zorgt er voor dat deze bestanden uitgelezen worden
# en naar een AD-vriendelijk csv bestand omgezet worden.

import os
import subprocess


# Run het commando 'sudo samba-tool user list' en sla het resultaat op
# User list laat alle gebruikers in Zentyal zien
result = subprocess.run(['sudo', 'samba-tool', 'user', 'list'], stdout=subprocess.PIPE).stdout.decode('utf-8').split('\n')
print(result)

for name in result:
    
    # Voor elk resultaat gaan we het object opzoeken en relevante informatie uithalen zoals naam en student/docent
    obj = subprocess.run(['sudo', 'samba-tool', 'user', 'show', name], stdout=subprocess.PIPE).stdout.decode('utf-8').split('\n')
    name_txt = ''.join(str(x) for x in ['echo ', str(name), '>>', 'user', '.txt'])
    os.system(name_txt)
    for lines in obj:
        full_txt = ''.join(str(x) for x in ['echo ', str(lines), '>>', name, '.txt']) 
        os.system(full_txt)
        #print(full_txt)
    
#os.system('ls')
#print('Hello world')


