# [ANY] CTraceFilterSimple Instance
This is a SourceMod Plugin that allows developers to create an instance of the `CTraceFilterSimple` class from the game so that it can be used for ray casts since Source games use it quite a lot. Currently, only Team Fortress 2 is supported but the game data file can be modified so that other games are supported.

# API
```
methodmap CTraceFilterSimple < MemoryBlock
{
	public native CTraceFilterSimple( int iPassEntity, int nCollisionGroup );
	public native bool ShouldHitEntity( int iEntity, int fContentsMask );
};
```

# Requirements
- [SourceMod 1.8+](https://www.sourcemod.net/downloads.php?branch=stable)
- [Source Scramble](https://github.com/nosoop/SMExt-SourceScramble)

# Supported Platforms
- Windows
- Linux
