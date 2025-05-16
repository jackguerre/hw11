; hw11translate2Ascii.asm
; Translates bytes in inputBuf into printable hex format in outputBuf
; and prints the resulting string using Linux syscalls.

section .data
    inputBuf db 0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
    inputLen equ 8
    hexDigits db "0123456789ABCDEF"

section .bss
    outputBuf resb 80     ; plenty of space for 8 bytes * 3 = 24 max, plus newline

section .text
    global _start

_start:
    mov esi, inputBuf     ; ESI = pointer to input buffer
    mov edi, outputBuf    ; EDI = pointer to output buffer
    xor ecx, ecx          ; ECX = index counter

translate_loop:
    cmp ecx, inputLen
    jge finalize_output           ; Exit loop if all bytes processed

    mov al, [esi + ecx]           ; Load byte from input buffer
    call byteToHex                ; Convert AL to hex (results in AH and AL)

    ; Store high nibble (AH)
    mov [edi], ah
    inc edi

    ; Store low nibble (AL)
    mov [edi], al
    inc edi

    ; Store space character
    mov byte [edi], ' '
    inc edi

    inc ecx
    jmp translate_loop

; -----------------------------------------------------------------------------
; Finalize and Print Output
; -----------------------------------------------------------------------------
finalize_output:
    dec edi                       ; Overwrite last space with newline
    mov byte [edi], 0x0A

    ; Calculate length of output buffer
    mov eax, 4                    ; syscall: sys_write
    mov ebx, 1                    ; file descriptor: stdout
    mov ecx, outputBuf            ; pointer to output
    mov edx, edi
    sub edx, outputBuf            ; edx = length of written output
    inc edx                       ; include newline
    int 0x80

    ; Exit the program
    mov eax, 1                    ; syscall: sys_exit
    xor ebx, ebx                  ; status = 0
    int 0x80

; -----------------------------------------------------------------------------
; Subroutine: byteToHex
; Converts a byte in AL to two ASCII characters in AH (high nibble) and AL (low)
; -----------------------------------------------------------------------------
byteToHex:
    push ebx

    mov bl, al                    ; Copy AL to BL
    shr bl, 4                     ; Extract high nibble
    movzx bx, bl
    mov ah, [hexDigits + ebx]     ; Convert to ASCII

    mov bl, al
    and bl, 0x0F                  ; Extract low nibble
    movzx bx, bl
    mov al, [hexDigits + ebx]     ; Convert to ASCII

    pop ebx
    ret
