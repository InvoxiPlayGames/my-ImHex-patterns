// Amplitude (2016) savegame ImHex pattern (v0)
// by Emma / InvoxiPlayGames, 2024
// 
// Changelog:
//    v0 - Initial pattern.

#pragma author InvoxiPlayGames
#pragma description Amplitude (2016) save file
#pragma magic [ 7A 01 00 00 00 ] @ 0x00

// Uncomment if providing a PS3 save file, leave commented for PS4
//#pragma endian big

// Symbol/String definition
struct sym {
  u32 len;
  char string[len];
};

// "RevisionStream" header
struct revstream {
  u8 revision_magic;
  u32 revision; // always 1
};

struct unknown {
  u8 byte_0x19; // 0x1A on PS3
  u32 int_0;
};

struct score {
  sym shortname;
  u16 score;
  u8 diff;
  u8 unknown[4]; // unknown[2] possibly related to blaster/co-op mode
};

struct score_table {
  u32 num_scores;
  score scores[num_scores];
};

struct unlock_table {
  u32 num_entries;
  sym entries[num_entries];
};

// I assume this is a table, I don't know what the flags are though...
struct flag_table {
  u32 num;
  u32 flag[num];
};

// The same between a fresh PS3 save and a finished PS4 save
struct unknown_2 {
  u32 ints_2_1_2[3];
  u8 byte_0;
};

struct campaign_score {
  u16 score;
  u8 zero;
  u8 diff;
};

struct campaign {
  u8 unk1[3];
  u32 unk2;
  u8 unk3[2];
  sym next_song;
  u8 song_idx;
  u8 always_0xFF; // Unknown
  campaign_score scores[15];
  u8 always_0x06; // Unknown
  u8 always_0x01; // Unknown
};

struct ampsave {
  revstream rev;
  unknown unk;
  score_table score;
  sym control;
  flag_table flags;
  unknown_2 unk2;
  unlock_table unlock;
  campaign camp;
};
 
ampsave save @ 0x0;
