# 2Kasm
### Builds specified Application(s) available as Archlinux-Kasm-DockerImage
## https://kasmweb.com/
## https://www.linuxserver.io/

Uses PKGBUILD entries to
- set AutoStartPaths accordingly
- set default icon

Available Applications:
Arch (Core/Extra/Community) 

### Tested with:
- Ghidra (Community) 
- Firefox (Extra) 
- intellij-idea-ce  (Community)
- libreoffice-still
- cura-bin
- clion

# Plain builder
```
bash 2kasm.sh cura-bin
1= cura-bin
cura-bin
Searching for cura-bin in Core/Extra...
Searching for cura-bin in Community...
Possible Candidates:
cura-bin, : name = cura-bin
Wanted cura-bin Got: cura-bin
Replacing in yay
egrep: warning: egrep is obsolescent; using grep -E
grep: warning: * at start of expression
Extracted Exec path is < /usr/bin/cura >
EXEC_PATH= /usr/bin/cura
ICONURL=https://ultimaker.com/favicon.ico

Not an unraid system.
Run minimaly using:
docker run -d -p 9017:3000 --name=cura-bin  -v /etc/localtime:/etc/localtime:ro felix/cura-bin

```

# Usage Unraid
```
cd 2kasm 
bash 2kasm.sh <programm>
In Unraid navigate to "Docker" -> addContainer
Choose TemplateFile: felix-<programm>
```
If there is no exact match a list  of candidates will be returned

Example
```
~$ bash 2kasm.sh intellij
Searching for intellij in Core/Extra...
Searching for intellij in Community...
Possible Candidates:
intellij-idea-plugin-emmy-lua
intellij-idea-community-edition-git
intellij-idea-ce
intellij-idea-community-edition-no-jre
intellij-idea-community-edition-jre
intellij-idea-ultimate-edition
intellij-idea-ultimate-edition-jre
intellij-idea-ue-eap
intellij-idea-ce-ea

~$ bash 2kasm.sh brave brave-nightly firefox
brave
Searching for brave in Core/Extra...
Searching for brave in Community...
Possible Candidates:
brave, : name = brave
Wanted brave Got: brave
Replacing in yay
brave-nightly
Searching for brave-nightly in Core/Extra...
Searching for brave-nightly in Community...
Wanted brave-nightly Got: brave-nightly-bin
Replacing in yay
firefox
Searching for firefox in Core/Extra...
Wanted firefox Got: firefox
Replacing in yay

```
Useful links:
    - https://github.com/linuxserver/docker-baseimage-kasmvnc

# Based on linuxserver.io / kasm with inspiration from bin-hex
[Kasm](https://kasmweb.com/)
[lscio](https://www.linuxserver.io/)
[bin-hex](https://github.com/binhex/)