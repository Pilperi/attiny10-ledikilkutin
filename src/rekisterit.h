#ifndef REKISTERIT_H
#define REKISTERIT_H

#include <avr/io.h>

#define REG_ZERO       R16
#define REG_TMP1       R17
#define REG_TMP2       R18
#define REG_TMP3       R19
#define REG_ITER1      R20
#define REG_ITER2      R21
#define REG_ITER3      R22
#define REG_DATA1      R23
#define REG_DATA2      R24
#define REG_DATA3      R25
#define REG_POINT_XL   R26
#define REG_POINT_XH   R27
#define REG_POINT_YL   R28
#define REG_POINT_YH   R29
#define REG_POINT_ZL   R30
#define REG_POINT_ZH   R31

#define REG_PNT_CNTL   YL
#define REG_PNT_CNTH   YH
#define REG_PNT_CNT    Y

#define REG_PUNA       REG_DATA1
#define REG_SINI       REG_DATA2
#define REG_MOLEMMAT   REG_DATA3

#endif // REKISTERIT_H