# ToonTool

The goal for this is to use the Blizzard World of Warcraft API's via PowerShell to get the information I want to manage my toons. I'm not trying to build some cool GUI for this, but rather just manage the retrieval and loading of the data. Once the data is loaded, we have the PowerShell command line to look at interesting things.

```powershell
$myToons = Get-Content -Path .\characters.json -Raw | ConvertFrom-Json
$myToons.characters.Count
# 41
$myToons.characters | Sort-Object -Property lastModified | Select-Object -First 5  -Property name,realm
# name and realm of the five toons I've left alone for the longest
$myToons.characters | Sort-Object -Property lastModified | Select-Object -Last 3  -Property name,realm
# name and realm of the three toons I've most recently played
```

Starting to understand how the various pieces I'm trying to put together work. Starting here with a clean slate.

---

## Updates/News

**19-Oct-2019** - I've been toying around on several different machines with several different directions and mostly not really getting serious about this. Probably not going to get too serious now, but I have some code that is starting to come together so I've made this (mostly empty) repo public and will start pulling the bits of code together and try to get some things working.

I'm focusing on the new API that Blizzard is in the process of moving to and mostly trying to do things natively in PowerShell.

---

## Stuff I haven't figured out

Part of my slow with this project is I keep getting wrapped up trying to solve some issues. I've decided to postpone these so they don't block me; as long as I have a workaround, I can make progress with the rest. **If you know how to solve one of these, let me know!**

1. Getting the client token via `Invoke-WebRequest`|`Invoke-RestMethod`. I'm currently using curl.exe but this means that the code is locked to Windows 10 or cases where someone has a usable curl.exe in the path. I think this is probably relatively easily solvable, I just got frustrated with it and decided to cheat for now.
1. User Authentication. I don't know if this is solveable for a non-web set of tools. There are some examples of creating a web client and getting the auth but I haven't played with that yet; not sure if the redirect URL will get in the way. I have a small website where I played with the user auth in Python/Flask. AFAICT, the only thing I really need the user auth for is to get the list of toons. Currently I'm cheating by getting the JSON output of /wow/user/characters call (soon to be replaced with /profile/{account-id}/wow).

---

## Random bits

I'm somewhat structuring this repo in a manner that I use with my day job but currently I'm not putting all of the infrastructure (mostly the parts that build the module into a nupkg) for now. Once this gets to the level that I think others may have interest, I'll add in those bits as I'll need them if I want to push the module into the PSGallery.
