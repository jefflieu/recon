/******************************************************************************
Created by Jeff Lieu <lieumychuong@gmail.com>
******************************************************************************/

#ifndef __RECON_ADC_HW_DESCRIPTION__
#define __RECON_ADC_HW_DESCRIPTION__

#include <recon_types.h>

/*
 * Sequencer Core Command Register Register
 */
#define SEQUENCER_CMD_REG                    0
#define SEQUENCER_CMD_MSK                    (0x0000000F)

#define SEQUENCER_CMD_RUN_MSK                (0x00000001)
#define SEQUENCER_CMD_RUN_START              (0x00000001)
#define SEQUENCER_CMD_RUN_STOP               (0x00000000)

#define SEQUENCER_CMD_MODE_MSK               (0x0000000E)
#define SEQUENCER_CMD_MODE_CONTINUOUS        (0x00000000)
#define SEQUENCER_CMD_MODE_ONCE              (0x00000002)
#define SEQUENCER_CMD_MODE_RECALIBRATE       (0x0000000E)



/*
 * IO Read Write helper Macros
 */
#define READ_CMD_REG(base) \
  HWREG32(base+SEQUENCER_CMD_REG)

#define WRITE_CMD_REG(base, data) \
  do {HWREG32(base + SEQUENCER_CMD_REG) = data;} while (0)


/*
 * RUN - START/STOP helper Macros
 */
#define READ_CMD_RUN_REG(base) \
        READ_CMD_REG(base)     \
           & SEQUENCER_CMD_RUN_MSK

/*
 To Start the Sequencer Core
*/
#define SEQUENCER_START(base)      \
   WRITE_CMD_REG(base, (  \
   READ_CMD_REG(base)    \
    & ~(SEQUENCER_CMD_RUN_MSK) )   \
      | SEQUENCER_CMD_RUN_START)

/*
 To Stop the Sequencer Core
 Step:
     1. Write 0 to RUN bit
     2. Poll the RUN bit until it read 0.
 */
#define SEQUENCER_STOP(base)       \
do {                                                  \
   WRITE_CMD_REG(base, (  \
   READ_CMD_REG(base)    \
    & ~(SEQUENCER_CMD_RUN_MSK))    \
      | SEQUENCER_CMD_RUN_STOP);   \
   while(                                             \
   READ_CMD_REG(base)    \
      & SEQUENCER_CMD_RUN_MSK);    \
} while (0)



/*
 * MODE - ONCE/CONTINUOUS helper Macros
 */

/*
 Set sequencer to run once only
*/
#define SEQUENCER_MODE_RUN_ONCE(base) \
   WRITE_CMD_REG(base, (     \
   READ_CMD_REG(base)       \
    & ~(SEQUENCER_CMD_MODE_MSK) )     \
      | SEQUENCER_CMD_MODE_ONCE)

/*
 Set sequencer to run continuously
*/
#define SEQUENCER_MODE_RUN_CONTINUOUSLY(base) \
   WRITE_CMD_REG(base, (             \
   READ_CMD_REG(base)               \
    & ~(SEQUENCER_CMD_MODE_MSK) )             \
      | SEQUENCER_CMD_MODE_CONTINUOUS)

/*
 Set sequencer to recalibration mode
*/
#define SEQUENCER_MODE_RUN_RECALIBRATION(base) \
   WRITE_CMD_REG(base, (              \
   READ_CMD_REG(base)                \
    & ~(SEQUENCER_CMD_MODE_MSK) )              \
      | SEQUENCER_CMD_MODE_RECALIBRATE)

      
/**
  Sample storage space 
*/      
#define SAMPLE_STORAGE_REG                   0
#define SAMPLE_STORAGE_MSK                   (0x00000FFF)
#define SAMPLE_STORAGE_FIRST_SLOT            0
#define SAMPLE_STORAGE_LAST_SLOT             63
      
#define SAMPLE_STORAGE_IRQ_ENABLE_REG        0x40
#define SAMPLE_STORAGE_IRQ_ENABLE_MSK        (0x00000001)
#define SAMPLE_STORAGE_IRQ_ENABLED           (0x00000001)
#define SAMPLE_STORAGE_IRQ_DISABLED          (0x00000000)
#define SAMPLE_STORAGE_IRQ_STATUS_REG        0x44
      
#endif /* __RECON_ADC_HW_DESCRIPTION__ */
