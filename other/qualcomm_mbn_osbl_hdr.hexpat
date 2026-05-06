// Qualcomm .mbn Bootloader Header Pattern
// by Emma / InvoxiPlayGames, 2026
// 
// Changelog:
//    v0 - Initial pattern. Based off Lumia WP7 recovery OSBL images.

#pragma author InvoxiPlayGames
#pragma description Qualcomm .mbn bootloader header
#pragma endian little

struct mbn_hdr {
  u32 image_id; // 0xB = OSBL
  u32 header_version; // always 0x3
  u32 nand_src; // filled by loader
  u32 load_addr; // doubles as entrypoint
  u32 image_size;
  u32 code_size;
  u32 signature_ptr; // pointer, unused
  u32 signature_size; // unused
  u32 cert_chain_ptr; // pointer, unused
  u32 cert_chain_size; // unused
};

mbn_hdr mbn @ 0x0;
