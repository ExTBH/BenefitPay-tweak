# BenefitPay-tweak
Benefit is a nice app but ofcouse as a banking app they have to implement jailbreak detection.
In the past detection was simple just use A-Bypass and you good, but now with version 2.0.0 they have integrated [DexProtector](https://licelus.com/products/dexprotector).
So how do we bypass it now?
Well its simple
1. first Open the app in any disassembler and start analzying the app and see whats happeing
2. Look at crash logs and identify a potential reason, looking at benefit's crashes it was crashing before the app is ran so it suggested it might be a framework or an [init function](https://stackoverflow.com/a/30703178/16619237)
3. Before diving in the init funtions and suffering with obfuscated arm stuff, why not finish checking the whole app first? so i went looking in the frameworks.
   where i arrived at an obfuscated framework, everything was encrypted every string every method every class, except one thing, the info.plist file, it had the reverse DNS of the framework `com.licel.WbInject`
   googling that and we arrive at the homepage of licel where they have DexProtector as a service, with that we know who's the reason.
4. Now time to break it, first going through the binary, we notice everything is encrypted and done at runtime, there's nothing we can hook
5. so i was like, what happens if the class can't be initalized? since everything is done at runtime
6. with that i decided to hook the 3 classes available in the binary and prevent their initalization, to do that we hook the [load method](https://developer.apple.com/documentation/objectivec/nsobject/1418815-load?language=objc)
7. hooking that and opening the app and tada!! it works fine.

## Future proofing
But knowing everything is encrpyted, i knew each new update i have to redo these steps and recompile the tweak again so i decided to future proof it this way
first rewrite the hooking code to be done at runtime
then i decided to store a JSON file with each version and their corresponding classes 
then write [this](https://github.com/ExTBH/BenefitPay-tweak/blob/77c4e4ea3b071b30bf69b77a143d676d02ef6958/Jailbreak.m#L73C7-L73C7)
and now all i have to do is just update the json whenever a new version is out and all will work fine, and it's been working fine since i wrote it 7 months ago
