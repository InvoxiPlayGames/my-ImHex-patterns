// Rock Band 4 savegame ImHex pattern (v1)
// by Emma / InvoxiPlayGames, 2025
//
// Designed for game version 2.3.7
// (Xbox 2.0.2.6, PS4 2.21)
// 
// Changelog:
//    v1 - Initial pattern. Can parse a save with an in-progress tour,
//         a completed Rockudrama campaign and played songs. Will likely
//         fail to parse any save with an incomplete tour, will 100% fail
//         to parse an in-progress Rockudrama campaign.

#pragma author InvoxiPlayGames
#pragma description Rock Band 4 save file (version 0x19)
#pragma magic [ 7A 19 00 00 00 ] @ 0x00

// Symbol/String definition
struct Symbol {
  u32 len;
  char string[len];
};

// RevisionStream header
struct RevisionStream {
  u8 revision_magic;
  u32 revision;
};

// Harmonix utility structures
struct DateTime {
  u8 mSec;
  u8 mMin;
  u8 mHour;
  u8 mDay;
  u8 mMonth;
  u8 mYear;
};
struct HxGuid {
  u32 mData[4];
};

// Campaign: Per-gig progress
struct RBCampaignGigProgressPersistentData {
  Symbol mGigName; // not part of the class - part of the map
  RevisionStream rev; // Revision 0x2
  
  Symbol mVenueLocation;
  u32 mStarsEarned;
  bool mHaveAttempted;
  u32 mHighestScore;
  u32 mDisplayStars;
  
  u8 unk_0x7B;
};

// Campaign: Per-city progress
struct RBCampaignCityProgressPersistentData {
  Symbol mCityName; // not part of the class - part of the map
  RevisionStream rev; // Revision 0x0
  
  u32 mFansEarned;
  u32 mMoneyEarned;
  u32 mGigProgress_length;
  RBCampaignGigProgressPersistentData mGigProgress[mGigProgress_length];
  
  u8 unk_0x7B;
};

// Campaign: Rockudrama high score
struct RBBTMScore {
  RevisionStream rev;  // Revision 0x0
  
  u32 mFame;
  Symbol mBandName;
  
  u8 unk_0x7B;
};

// Campaign: Rockudrama current progress
struct RBBTMCampaignProgress {
  RevisionStream rev; // Revision 0x5
  
  u32 mTotalFame;
  Symbol mCurrentChapter;
  Symbol mLastViewedChapter;
  u32 mLastViewedShowIndex;
  u32 mNumCompletedShowsSeenThisChapter;
  u32 mShowsUsed_length;
  Symbol mShowsUsed[mShowsUsed_length];
  u32 mNarrativesUsed_length;
  Symbol mNarrativesUsed[mNarrativesUsed_length];
  u32 mNextSongRandomVal;
  u32 mNextShowRaiseStakesRandomVal;
  u32 mChapterGigResults_length;
  // TODO
  // RBBTMGigResult mChapterGigResults[mChapterGigResults_length];
  
  u8 unk_0x7B;
};

// Campaign: Rockudrama data block
struct RBBTMBandPersistentData {
  RevisionStream rev; // Revision 0x0
  
  RBBTMScore mBestScore;
  RBBTMCampaignProgress mCurrentBTMProgress;
  
  u8 unk_0x7B;
};

// Not actual classes/structures, but is how the eastl maps are serialized
struct RBCampaignSessionMusician {
  u32 unk1; // possibly mSlot?
  Symbol mMusicianName;
  bool unk2; // possibly mBuiltInCharacter?
};
struct RBCampaignTourFansEarned {
  Symbol mTourName;
  u32 mFansEarned;
};
struct RBCampaignTourCashEarned {
  Symbol mTourName;
  u32 mCashEarned;
};

// Campaign: Band information
// TODO: Some fields in here could be in the totally wrong order
struct RBCampaignBandPersistentData {
  RevisionStream rev; // Revision 0x13
  
  Symbol mBandName;
  Symbol mHomeCity;
  Symbol mLastCityVisited_maybe;
  u32 mCityProgress_length;
  RBCampaignCityProgressPersistentData mCityProgress[mCityProgress_length];
  u32 mCompletedTours_length;
  Symbol mCompletedTours[mCompletedTours_length];
  Symbol mCurrentTour_maybe;
  Symbol mCityForNextTourChoice_maybe;
  u32 mStarsAtTourStart;
  bool mNarrativeEndingReached_maybe;
  u32 mCashSpent_maybe;
  u32 mSessionMusicians_length;
  RBCampaignSessionMusician mSessionMusicians[mSessionMusicians_length];
  u32 mPendingFanGigUnlocks_maybe;
  bool mRecentlyPlayed;
  u32 mTourFansEarned_length;
  RBCampaignTourFansEarned mTourFansEarned[mTourFansEarned_length];
  u32 mTourCashEarned_length;
  RBCampaignTourCashEarned mTourCashEarned[mTourCashEarned_length];
  Symbol mLastCompletedTourGig_maybe;
  // campaigns started on Rivals will always have nothing for mDeprecatedSongData
  // (TODO: fix for saves brought forward, if such a thing exists...)
  u32 mDeprecatedSongData_length;
  // SongPersistentData? mDeprecatedSongData[mDeprecatedSongData_length];
  u32 mSongsPlayed_length;
  u32 mSongsPlayed[mSongsPlayed_length];
  u32 unk_0x1;
  HxGuid mBandGuid;
  u32 mPatchesToRun_length;
  Symbol mPatchesToRun[mPatchesToRun_length];
  RBBTMBandPersistentData mBTMData;
  
  u8 unk_0x7B;
};

// Not actual classes/structures - ImHex doesn't support multi-dimensional arrays
struct SongScores {
  u32 mScore[4]; // per-difficulty
};
struct SongStars {
  u8 mStars[4];
};
struct SongAccuracy {
  u8 mAccuracy[4];
};
struct SongFullCombo {
  u8 mFullCombo[4];
};

// High scores: General data
struct SongPersistentData {
  u32 song_id;
  RevisionStream rev; // Revision 0x8
  
  u32 mSongID;
  u32 mVersion;
  DateTime mLastPlayed;
  SongScores mScore[7]; // per-instrument
  SongStars mStars[7];
  SongAccuracy mAccuracy[7];
  SongFullCombo mFullCombo[7];
  
  u8 unk_0x7B;
};

// High scores: MIDI checksum / leaderboard information
struct MidiChecksum {
  RevisionStream rev; // Revision 0x3
  
  u8 digest[0x14];
  u8 leaderboardRevs[7];
  u32 scoreChecksums[7];
  
  u8 unk_0x7B;
};

// High scores: For quickplay and brutal mode
struct QuickplaySongPersistentData {
  SongPersistentData mSongPersistentData;
  MidiChecksum mChecksum;
};

// Savegame
struct RBProfile {
  RevisionStream rev; // Revision 0x19
  
  u32 mCampaignBands_length;
  RBCampaignBandPersistentData mCampaignBands[mCampaignBands_length];
  u32 mQuickplaySongData_length;
  QuickplaySongPersistentData mQuickplaySongData[mQuickplaySongData_length];
  u32 mBrutalSongData_length;
  QuickplaySongPersistentData mBrutalSongData[mBrutalSongData_length];
  
  // TODO: the rest of the fields
};
 
RBProfile profile @ 0x0;
