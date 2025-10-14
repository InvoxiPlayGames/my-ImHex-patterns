// Amplitude (2016) savegame ImHex pattern (v1, PS4)
// by Emma / InvoxiPlayGames, 2024-2025
// 
// Changelog:
//    v1 - Cleaned up names and made them match closer to originals.
//         Made the AmpSystemOptions structure more accurate (previously
//         the second set of settings was a fixed array) and corrected
//         some info in the scoring data. PS4 and PS3 patterns are now two
//         different files.
//    v0 - Initial pattern.

#pragma author InvoxiPlayGames
#pragma description Amplitude (2016, PS4) save file
#pragma magic [ 7A 01 00 00 00 ] @ 0x00
#pragma endian little

// Symbol/String definition
struct Symbol {
  u32 mLen;
  char mStr[mLen];
};

// RevisionStream header
struct RevisionStream {
  u8 mMagic; // 0x7A
  u32 mRevision;
};

struct AmpSongPersistentData {
  Symbol mSongName;
  u16 mScore;
  u8 mDifficulty;
  u8 mHighestStreak;
  u8 mPercentCleared;
  u8 mScoreType;
  u8 mProgress;
};

struct AmpSystemOptions {
  Symbol mControlScheme;
  u32 mSettings1_length;
  u32 mSettings1[mSettings1_length];
  u32 mSettings2_length;
  u32 mSettings2[mSettings2_length];
};

struct AmpCampaignScore {
  u16 mScore;
  u8 mZero;
  u8 mDifficulty;
};

struct AmpCampaignPersistentData {
  u8 mUnknown1;
  u8 mUnknown2;
  u32 mUnknown3;
  u8 mUnknown4;
  u8 mUnknown5;
  u8 mUnknown6;
  Symbol mNextSong;
  u8 mSongIndex;
  u8 mUnknown7;
  AmpCampaignScore mScores[15];
};

struct AmpProfileFooter {
  u8 mUnknown1_0x6;
  u8 mUnknown2_0x1;
  u32 mUnknown3;
};

struct AmpProfile {
  RevisionStream rev;
  
  u8 mVersion;
  Symbol mUnused;
  u32 mSongData_length;
  AmpSongPersistentData mSongData[mSongData_length];
  AmpSystemOptions mOptions;
  u8 mUnknown;
  u32 mUnlocks_length;
  Symbol mUnlocks[mUnlocks_length];
  AmpCampaignPersistentData mCampaign;
  AmpProfileFooter mFooter;
};

AmpProfile profile @ 0x0;
