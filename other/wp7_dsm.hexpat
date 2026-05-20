// Windows Phone 7 DSM file ImHex pattern
// by Emma / InvoxiPlayGames, 2026
// 
// Changelog:
//    v0 - Initial pattern.

#pragma author InvoxiPlayGames
#pragma description Windows Phone 7 DSM file
#pragma magic [ 74 00 00 00 ] @ 0x00
#pragma endian little

struct version_info {
  u16 major;
  u16 minor;
  u16 qfe;
  u16 build;
};

struct guid {
  u32 p1;
  u16 p2;
  u16 p3;
  u16 p4;
  u8 p5[6];
};

struct file_entry {
  u32 name_len;
  u32 flags;
  u32 name_offset;
  u32 base_addr;
  u32 size;
  
  char16 fake_filename[name_len] @ name_offset;
};

struct dsm_header {
  u32 hdr_size;
  u32 flags;
  u32 processor;
  u32 os_version;
  u32 platform_id;
  u32 name_len;
  u32 name_offset;
  u32 deps_count;
  u32 deps_offset;
  u32 shadow_count;
  u32 shadow_offset;
  u32 file_count;
  u32 file_offset;
  u32 cert_len;
  u32 cert_offset;
  
  version_info package_ver;
  version_info previous_ver;
  version_info interface_ver;
  
  guid package_guid;
  guid interface_guid;
  
  char16 fake_name[name_len] @ name_offset;
};

dsm_header hdr @ 0x0;
guid dependencies[hdr.deps_count] @ hdr.deps_offset;
guid shadows[hdr.shadow_count] @ hdr.shadow_offset;
file_entry files[hdr.file_count] @ hdr.file_offset;
u8 cert[hdr.cert_len] @ hdr.cert_offset;
