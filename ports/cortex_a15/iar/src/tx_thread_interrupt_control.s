;/**************************************************************************/
;/*                                                                        */
;/*       Copyright (c) 2024 Microsoft Corporation.        */
;/*                                                                        */
;/*       This software is licensed under the Microsoft Software License   */
;/*       Terms for Microsoft Azure RTOS. Full text of the license can be  */
;/*       found in the LICENSE file at https://aka.ms/AzureRTOS_EULA       */
;/*       and in the root directory of this software.                      */
;/*                                                                        */
;/**************************************************************************/
;
;
;/**************************************************************************/
;/**************************************************************************/
;/**                                                                       */ 
;/** ThreadX Component                                                     */ 
;/**                                                                       */
;/**   Thread                                                              */
;/**                                                                       */
;/**************************************************************************/
;/**************************************************************************/
;
;#define TX_SOURCE_CODE
;
;
;/* Include necessary system files.  */
;
;#include "tx_api.h"
;#include "tx_thread.h"  */
;

INT_MASK        =   0x03F

;/**************************************************************************/ 
;/*                                                                        */ 
;/*  FUNCTION                                               RELEASE        */ 
;/*                                                                        */ 
;/*    _tx_thread_interrupt_control                      Cortex-A15/IAR    */ 
;/*                                                           6.1          */
;/*  AUTHOR                                                                */
;/*                                                                        */
;/*    William E. Lamie, Microsoft Corporation                             */
;/*                                                                        */
;/*  DESCRIPTION                                                           */
;/*                                                                        */ 
;/*    This function is responsible for changing the interrupt lockout     */ 
;/*    posture of the system.                                              */ 
;/*                                                                        */ 
;/*  INPUT                                                                 */ 
;/*                                                                        */ 
;/*    new_posture                           New interrupt lockout posture */ 
;/*                                                                        */ 
;/*  OUTPUT                                                                */ 
;/*                                                                        */ 
;/*    old_posture                           Old interrupt lockout posture */ 
;/*                                                                        */ 
;/*  CALLS                                                                 */ 
;/*                                                                        */ 
;/*    None                                                                */ 
;/*                                                                        */ 
;/*  CALLED BY                                                             */ 
;/*                                                                        */ 
;/*    Application Code                                                    */ 
;/*                                                                        */ 
;/*  RELEASE HISTORY                                                       */ 
;/*                                                                        */ 
;/*    DATE              NAME                      DESCRIPTION             */
;/*                                                                        */
;/*  09-30-2020     William E. Lamie         Initial Version 6.1           */
;/*                                                                        */
;/**************************************************************************/
;UINT   _tx_thread_interrupt_control(UINT new_posture)
;{
    RSEG    .text:CODE:NOROOT(2)
    PUBLIC  _tx_thread_interrupt_control
    CODE32
_tx_thread_interrupt_control
;
;    /* Pickup current interrupt lockout posture.  */
;
    MRS     r3, CPSR                    ; Pickup current CPSR
    MOV     r2, #INT_MASK               ; Build interrupt mask
    AND     r1, r3, r2                  ; Clear interrupt lockout bits
    ORR     r1, r1, r0                  ; Or-in new interrupt lockout bits
;
;    /* Apply the new interrupt posture.  */
;
    MSR     CPSR_c, r1                  ; Setup new CPSR
    BIC     r0, r3, r2                  ; Return previous interrupt mask
#ifdef TX_THUMB
    BX      lr                          ; Return to caller
#else
    MOV     pc, lr                      ; Return to caller
#endif
;}

    END

