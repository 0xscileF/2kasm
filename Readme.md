# 2Kasm
### Builds specified Application(s) available as Docker/Unraid Archlinux-Kasm-DockerImage
## https://kasmweb.com/
## https://www.linuxserver.io/

Provides Applications as Kasm Workspaces / Unraid Docker and Template, it doesn't work all the time completly automatic but most of the time its good enough.80/20
if multiple programs are given, the webtop base will be used for building.

set your DockerHub username in 2kasm.sh to enable auto pushing the built images to dockerhub, enabling us to directly use them in kasm

DOCKERHUB_USERNAME= 

The Workspaces currently still have to be created manually in kasm thorugh add workspace.
Or just clone another workspace and set 

Docker image to your username/imagename and change the

Docker Registry to https://index.docker.io/v1/

Docker Run Config override: 
Be sure to test out beforehand if you can get away without "security_opt": ["seccomp=unconfined"]

{
  "user": 1000,
  "entrypoint": [
    "/kasminit"
  ],
  "environment": {
    "HOME": "/home/kasm-user"
  },
  "security_opt": [
    "seccomp=unconfined"
  ]
}

A possible Thumbnail candidate URl should have been printed while building the container

Cores/Memory/GPU's to taste, overprovisioning is a thing 


Example Usage:
```
[deck@archDriver 2kasm]$  bash 2kasm.sh firefox
Can handle multiple programs, one fails all; First is autostarted; Space seperated list.
firefox
Searching for firefox in Core/Extra...
Wanted firefox Got: firefox
Replacing in pacman
grep: warning: * at start of expression
Extracted Exec path is < /usr/lib/firefox/firefox-bin >
EXEC_PATH= /usr/lib/firefox/firefox-bin
ICONURL=https://www.mozilla.org/favicon.ico
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Warning: Failed to open the file out/arch-firefox/root/config/nobody/novnc-16x16.png: No such file or directory
  0  1409    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
curl: (23) client returned ERROR on write of 988 bytes
[+] Building 42.8s (18/18) FINISHED                                                                                                                                                                                          docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                                                   0.8s
 => => transferring dockerfile: 704B                                                                                                                                                                                                   0.0s
 => [internal] load metadata for ghcr.io/linuxserver/baseimage-kasmvnc:arch                                                                                                                                                            2.0s
 => [internal] load .dockerignore                                                                                                                                                                                                      0.7s
 => => transferring context: 2B                                                                                                                                                                                                        0.0s
 => [ 1/13] FROM ghcr.io/linuxserver/baseimage-kasmvnc:arch@sha256:684cc1477551852775a060df152f679dfcb2ad12ba5473fe8e1d9d084f2c0b53                                                                                                    0.0s
 => [internal] load build context                                                                                                                                                                                                      1.0s
 => => transferring context: 629B                                                                                                                                                                                                      0.0s
 => CACHED [ 2/13] RUN pacman -Syu --noconfirm && pacman -S --noconfirm base-devel git                                                                                                                                                 0.0s
 => CACHED [ 3/13] RUN mkdir -p /tmp/yay-build                                                                                                                                                                                         0.0s
 => CACHED [ 4/13] RUN useradd -m -G wheel builder && passwd -d builder                                                                                                                                                                0.0s
 => CACHED [ 5/13] RUN chown -R builder:builder /tmp/yay-build                                                                                                                                                                         0.0s
 => CACHED [ 6/13] RUN echo 'builder ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers                                                                                                                                                          0.0s
 => CACHED [ 7/13] RUN su - builder -c "git clone https://aur.archlinux.org/yay.git /tmp/yay-build/yay"                                                                                                                                0.0s
 => CACHED [ 8/13] RUN su - builder -c "cd /tmp/yay-build/yay && makepkg -si --noconfirm"                                                                                                                                              0.0s
 => CACHED [ 9/13] RUN rm -rf /tmp/yay-build                                                                                                                                                                                           0.0s
 => CACHED [10/13] RUN pacman -Syu --noconfirm                                                                                                                                                                                         0.0s
 => [11/13] RUN su - builder -c "yay -S  firefox --noconfirm"                                                                                                                                                                         20.3s
 => [12/13] COPY /root /                                                                                                                                                                                                               6.0s 
 => [13/13] RUN chmod -R 777 /defaults/                                                                                                                                                                                                4.0s 
 => exporting to image                                                                                                                                                                                                                 5.2s 
 => => exporting layers                                                                                                                                                                                                                4.5s 
 => => writing image sha256:8310d00fa7404a7c4cb2b440eb998c77d07f32f3a3bda03c937b901ea62d3141                                                                                                                                           0.1s 
 => => naming to docker.io/0xscilef/firefox                                                                                                                                                                                            0.1s 
Using default tag: latest
The push refers to repository [docker.io/0xscilef/firefox]
b07dc821c25c: Pushed 
6f0603b6f1cd: Pushed 
609d0201ee70: Pushed 
41a807bd38fe: Mounted from 0xscilef/ghidra 
06d936c2ed3a: Mounted from 0xscilef/ghidra 
859851f6b14e: Mounted from 0xscilef/ghidra 
10bd2fabf41d: Mounted from 0xscilef/ghidra 
6147e160efec: Mounted from 0xscilef/ghidra 
b97e0d7133f4: Mounted from 0xscilef/ghidra 
c444e228b66c: Mounted from 0xscilef/ghidra 
87c85999af5b: Mounted from 0xscilef/ghidra 
9e618cd6f80e: Mounted from 0xscilef/ghidra 
6e0c5fc5f966: Mounted from 0xscilef/ghidra 
0ed7384b9dab: Mounted from 0xscilef/ghidra 
102bb46b1ee4: Mounted from 0xscilef/ghidra 
4dee4e26aa26: Mounted from 0xscilef/ghidra 
64dc08d95265: Mounted from 0xscilef/ghidra 
db1a10a157e3: Mounted from 0xscilef/ghidra 
2a6bd754d439: Mounted from 0xscilef/ghidra 
2b8730222862: Mounted from 0xscilef/ghidra 
918b8824b727: Mounted from 0xscilef/ghidra 
f9f03f306998: Mounted from 0xscilef/ghidra 
415351f21d57: Mounted from 0xscilef/ghidra 
latest: digest: sha256:514c1a906e9d5ef53d16512e883fefade79a5bded39e65d3e87f062c86db9673 size: 5134

```
Add it as new workspace in kasm


# OLD stuff 


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
