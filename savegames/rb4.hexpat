// Rock Band 4 savegame ImHex pattern (v2)
// by Emma / InvoxiPlayGames, 2025
//
// Designed for game version 2.3.7
// (Xbox 2.0.2.6, PS4 2.21)
// 
// Changelog:
//    v2 - Added structures for everything else in the save, and fixes some
//         of the Rockudrama and Tour data meaning an in-progress Rockudrama
//         campaign will be read properly. Character data is still missing,
//         pending a pattern to read binary 'DataArray's.
//    v1 - Initial pattern. Can parse a save with an in-progress tour,
//         a completed Rockudrama campaign and played songs. Will likely
//         fail to parse any save with an incomplete tour, will 100% fail
//         to parse an in-progress Rockudrama campaign.

#pragma author InvoxiPlayGames
#pragma description Rock Band 4 save file (version 0x19)
#pragma magic [ 7A 19 00 00 00 ] @ 0x00
#pragma endian little

// Symbol/String definition
struct Symbol {
  u32 mLen;
  char mStr[mLen];
};

// RevisionStream header
// all RevisionStream end with byte 0x7B as footer
struct RevisionStream {
  u8 mMagic; // 0x7A
  u32 mRevision;
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
  u32 mVersion; // 0x1
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
  
  u8 rev_footer;
};

// Campaign: Per-city progress
struct RBCampaignCityProgressPersistentData {
  Symbol mCityName; // not part of the class - part of the map
  RevisionStream rev; // Revision 0x0
  
  u32 mFansEarned;
  u32 mMoneyEarned;
  u32 mGigProgress_length;
  RBCampaignGigProgressPersistentData mGigProgress[mGigProgress_length];
  
  u8 rev_footer;
};

// Campaign: Rockudrama high score
struct RBBTMScore {
  RevisionStream rev;  // Revision 0x0
  
  u32 mFame;
  Symbol mBandName;
  
  u8 rev_footer;
};

// Campaign: Rockudrama score result
struct RBBTMSongResult {
  RevisionStream rev; // Revision 0x3
  
  Symbol mSongShortName;
  u32 mScore;
  float mStars;
  float mStarsFraction;
  u32 mWholeStars;
  u32 mPlayedDifficulty;
  u32 mAwardedPlayerCallout;
  float mDrumContribution;
  float mBassContribution;
  float mGuitarContribution;
  float mVocalsContribution;
  
  u8 rev_footer;
};

// Campaign: Rockudrama chapter gig result
struct RBBTMGigResult {
  Symbol mGigName; // not part of the class - part of the vector
  u32 mUnknown;
  RevisionStream rev; // Revision 0x9
  
  u32 mStarsWagered;
  bool mWagerRequiresGoldStars;
  u32 mFameEarned;
  u32 mBaseFamePerStar;
  u32 mFameEarnedFromChallengeBonus;
  u32 mFameEarnedFromWager;
  u32 mResults_length;
  RBBTMSongResult mResults[mResults_length];
  Symbol mShowName;
  u32 mShowNumOfSongs;
  bool mOfferedRaisedStakesWager;
  bool mAcceptedRaisedStakesWager;
  u32 mRaisedStakesRawStarsNeeded;
  u32 mRaisedStakesRawStarsEarned;
  u32 mRaiseStakesFame;
  
  u8 rev_footer;
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
  RBBTMGigResult mChapterGigResults[mChapterGigResults_length];
  
  u8 rev_footer;
};

// Campaign: Rockudrama data block
// BTM = Behind the Music
struct RBBTMBandPersistentData {
  RevisionStream rev; // Revision 0x0
  
  RBBTMScore mBestScore;
  RBBTMCampaignProgress mCurrentBTMProgress;
  
  u8 rev_footer;
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
struct RBCampaignBandPersistentData {
  RevisionStream rev; // Revision 0x13
  
  Symbol mBandName;
  Symbol mHomeCity;
  Symbol mCurrentTour;
  u32 mCityProgress_length;
  RBCampaignCityProgressPersistentData mCityProgress[mCityProgress_length];
  u32 mCompletedTours_length;
  Symbol mCompletedTours[mCompletedTours_length];
  Symbol mLastCompletedTourGig;
  Symbol mLastCityVisited;
  u32 mStarsAtTourStart;
  bool mNarrativeEndingReached;
  u32 mCashSpent;
  u32 mSessionMusicians_length;
  RBCampaignSessionMusician mSessionMusicians[mSessionMusicians_length];
  u32 mPendingFanGigUnlocks;
  bool mRecentlyPlayed;
  u32 mTourFansEarned_length;
  RBCampaignTourFansEarned mTourFansEarned[mTourFansEarned_length];
  u32 mTourCashEarned_length;
  RBCampaignTourCashEarned mTourCashEarned[mTourCashEarned_length];
  Symbol mCityForNextTourChoice;
  // campaigns started on Rivals will always have nothing for mDeprecatedSongData
  // (TODO: fix for saves brought forward, if such a thing exists...)
  u32 mDeprecatedSongData_length;
  // SongPersistentData? mDeprecatedSongData[mDeprecatedSongData_length];
  u32 mSongsPlayed_length;
  u32 mSongsPlayed[mSongsPlayed_length];
  HxGuid mBandGuid;
  u32 mPatchesToRun_length;
  Symbol mPatchesToRun[mPatchesToRun_length];
  RBBTMBandPersistentData mBTMData;
  
  u8 rev_footer;
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
  
  u8 rev_footer;
};

// High scores: MIDI checksum / leaderboard information
struct MidiChecksum {
  RevisionStream rev; // Revision 0x3
  
  u8 digest[0x14];
  u8 leaderboardRevs[7];
  u32 scoreChecksums[7];
  
  u8 rev_footer;
};

// High scores: For quickplay and brutal mode
struct QuickplaySongPersistentData {
  SongPersistentData mSongPersistentData;
  MidiChecksum mChecksum;
};

// Song ratings
struct RBSongRating {
  u32 mSongID;
  u8 mRating;
};

// Gameplay options
struct RBGameplayPersistentData {
  RevisionStream rev; // Revision 0xB
  
  bool mIsGuitarLefty;
  bool mIsDrumLefty;
  u32 mGuitarSoloMode;
  u32 mDrumFillLogic;
  bool mVocalImprovEnabled;
  u32 mBreakneckSpeedModifierIndex;
  u32 mMicVolumeIndex;
  u32 mVocalStemVolumeIndex;
  u32 mIGSVolumeIndex;
  bool mMicODDeployEnabled;
  
  u8 rev_footer;
};

// TODO: figure out what this is
struct RBUnknownData {
  RevisionStream rev; // Revision 0x1
  
  u32 mData[10];
  
  u8 rev_footer;
};

// Character list
struct RBCharacterPersistentData {
  RevisionStream rev; // Revision 0x4
  
  u32 mNumCharacters;
  Symbol mSavedCharName;
  bool mSavedCharIsPrefab;
  // TODO: RBChar mCharacters[mNumCharacters];
  // PLACEHOLDER: u8 mCharactersData[0x6DAF];
  
  u8 rev_footer;
};

// Rock Shop: Item information (unlocked, owned and unseen)
struct RBRockShopPersistentData {
  RevisionStream rev; // Revision 0x3
  
  u32 mUnlockedPieces_length;
  Symbol mUnlockedPieces[mUnlockedPieces_length];
  u32 mOwnedPieces_length;
  Symbol mOwnedPieces[mOwnedPieces_length];
  u32 mNotViewedPieces_length;
  Symbol mNotViewedPieces[mNotViewedPieces_length];
  
  u8 rev_footer;
};

// "First time user experience" - information pop-ups explaining stuff
struct FTUEPersistentData {
  RevisionStream rev; // Revision 0x0
  
  u32 mEventsSeen_length;
  Symbol mEventsSeen[mEventsSeen_length];
  
  u8 rev_footer;
};

// Rockudrama information
struct RBBTMPersistentData {
  RevisionStream rev; // Revision 0x0
  
  u32 mBTMCampaignsStarted;
  u32 mBTMCampaignsFinished;
  RBBTMScore mBestScore;
  
  u8 rev_footer;
};

// Unlocked venues
struct RBVenuePersistentData {
  RevisionStream rev; // Revision 0x0
  
  u32 mUnlockedVenues_length;
  Symbol mUnlockedVenues[mUnlockedVenues_length];
  
  u8 rev_footer;
};

// Achievement data: Song list related stats
struct RBAchSongListPersistentData {
  RevisionStream rev; // Revision 0x1
  
  u32 mRB4FanSongs_length;
  u32 mRB4FanSongs[mRB4FanSongs_length];
  u32 mRB4MasterSongs_length;
  u32 mRB4MasterSongs[mRB4MasterSongs_length];
  u32 mRB4ImmortalSongs_length;
  u32 mRB4ImmortalSongs[mRB4ImmortalSongs_length];
  u32 mRB4GoldStarSongs_length;
  u32 mRB4GoldStarSongs[mRB4GoldStarSongs_length];
  u32 mRB4AuthoredSoloSongs_length;
  u32 mRB4AuthoredSoloSongs[mRB4AuthoredSoloSongs_length];
  u32 mAwesomeVocalsSongs_length;
  u32 mAwesomeVocalsSongs[mAwesomeVocalsSongs_length];

  u8 rev_footer;
};

// Achievement data: Campaign related stats
struct RBAchCampaignPersistentData {
  RevisionStream rev; // Revision 0x0
  
  u32 mAttemptedGigs_length;
  Symbol mAttemptedGigs[mAttemptedGigs_length];
  u32 mBonusSetsPlayed_length;
  Symbol mBonusSetsPlayed[mBonusSetsPlayed_length];
  u32 mCashEarned;
  u32 mFansEarned;

  u8 rev_footer;
};

// Achievement/trophy data
// The class is different between PS4 and XB1... but not really
struct RBAchPersistentData {
  RevisionStream rev; // Revision 0x3
  
  RBAchSongListPersistentData mSongList;
  RBAchCampaignPersistentData mCampaign;
  u32 mRejectionStreak;
  
  u8 rev_footer;
};

// A saved setlist
struct RBSetlist {
  RevisionStream rev; // Revision 0x3
  
  Symbol mName;
  float mRuntimeMs;
  u32 mSongList_length;
  u32 mSongList[mSongList_length];
  bool mShuffle;
  HxGuid mGuid;
  
  u8 rev_footer;
};

// Saved in-game setlists
struct RBSetlistCollection {
  RevisionStream rev; // Revision 0x0
  
  u32 mSetlists_length;
  RBSetlist mSetlists[mSetlists_length];
  
  u8 rev_footer;
};

// Track skin options
struct RBTrackSkinPersistentData {
  RevisionStream rev; // Revision 0x1
  
  Symbol mSelectedSkin;
  u32 mSelectedColour;
  bool mShowSkin;
  u8 mUnknown;
  bool mRandomizeSkin;
  bool mRandomizeColor;
  
  u8 rev_footer;
};

// Rivals crew data: Spotlight high scores
struct SpotlightSongHighScoreInstrumentInfo {
  bool mHasInfo;
  u32 mInstrument;
  u32 mHighScore;
  u32 mStars;
  u32 mDifficulty;
  bool mBrutal;
  Symbol mPlatformUID;
  Symbol mGamertag;
  Symbol mUnused;
  Symbol mOnlineID;
  u32 mSpotlightPercent;
  bool mIsMine;
};

// Not an actual class; internally this is of <int, vector<SpotlightSongHighScoreInstrumentInfo>>
struct RBClanSpotlightSongHighScore {
  u32 mSongID;
  u32 mHighScores_length;
  SpotlightSongHighScoreInstrumentInfo mHighScores[mHighScores_length];
};

// Rivals crew data
// TODO: Figure out the unknowns (maybe they'll be obvious at the end of week/season)
struct RBClanPersistentData {
  RevisionStream rev; // Revision 0x6

  u32 mUnknown1;
  u32 mUnknown2;
  u32 mUnknown3;
  u32 mTier; // 1 = Highest (Bloodstone), 6 = Lowest (Bronze)
  u32 mHighestTier;
  u32 mCachedSpotlightSongEventID;
  u32 mSpotlightSongHighScores_length;
  RBClanSpotlightSongHighScore mSpotlightSongHighScores[mSpotlightSongHighScores_length];
  u32 mUnknown4;
  u32 mSpotlightPercent;
  u32 mCrewXPPercent;
  u32 mLPPercent;
  u32 mTotalPoints;
  
  u8 rev_footer;
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
  u32 mSongRatings_length;
  RBSongRating mSongRatings[mSongRatings_length];
  RBGameplayPersistentData mGameplayOptions;
  RBUnknownData mUnknownData; // TODO: figure out what this is (and whether it's variable size)
  RBCharacterPersistentData mCharacters;
  
  // TODO: Once character data parsing works, uncomment these - they should all be correct.
  //RBRockShopPersistentData mRockShopData;
  //FTUEPersistentData mFTUEData;
  //RBAchPersistentData mAchPersistentData;
  //u32 mTotalSongPlays;
  //RBSetlistCollection mSetlistData;
  //RBBTMPersistentData mBTMData;
  //RBVenuePersistentData mUnlockedVenueData;
  //RBClanPersistentData mClanPersistentData;
  //RBTrackSkinPersistentData mTrackTextureData;
  //u32 mEntitlements_length;
  //u32 mEntitlements[mEntitlements_length];
  
  //u8 rev_footer;
};
 
RBProfile profile @ 0x0;
