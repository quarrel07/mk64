/*
 * Mario Kart 64 ROM header
 * Only the first 0x18 bytes matter to the console.
 */

.byte  0x80, 0x37, 0x12, 0x40   /* PI BSD Domain 1 register */
.word  0x0000000F               /* Clockrate setting*/
.word  entry_point               /* Entrypoint */

/* Revision */  
.ifdef VERSION_CN
.word  0x0000144C /* iQue Player */
.else
.word  0x00001446 /* NTSC-U */
.endif

/*
 * An iQue image carries no CIC checksum, ROM name or cartridge ID. The player
 * authenticates content through its own signed metadata instead, so everything
 * from 0x10 to 0x3F is zero in the dump. Region and revision bytes included:
 * there is no "C" region code to emit.
 */
.ifdef VERSION_CN
.fill 0x30, 1, 0
.else

.word  0x3E5055B6               /* Checksum 1 */
.word  0x2E92DA52               /* Checksum 2 */
.word  0x00000000               /* Unknown */
.word  0x00000000               /* Unknown */
.ascii "MARIOKART64         "   /* Internal ROM name */
.word  0x00000000               /* Unknown */
.word  0x0000004E               /* Cartridge */
.ascii "KT"                     /* Cartridge ID */

/* Region */

.ifdef VERSION_EU
.ascii "P"                      /* PAL (Europe) */
.endif

.ifdef VERSION_JP
.ascii "J"                      /* NTSC-J (Japan) */
.endif

.ifdef VERSION_US
.ascii "E"                      /* NTSC-U (North America) */
.endif


.ifdef VERSION_EU_V11
.set REVISION_V11, 1
.endif

.ifdef VERSION_JP_V11
.set REVISION_V11, 1
.endif

.ifdef REVISION_V11
.byte  0x01                     /* Version */
.else
.byte  0x00                     /* Version */
.endif

.endif
